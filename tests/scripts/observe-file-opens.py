#!/usr/bin/env python3
"""Optional scoped file-open observer for prepared synthetic test fixtures.

Linux-only, Python standard library only (ctypes + inotify). Records
IN_OPEN events for an explicit allowlist of regular files inside a
prepared run's repo/ directory. Corroborating evidence for reported
file opens — not proof of reading or understanding.

Limits (never overclaim):

- an OPEN event is not a read, parse, or comprehension;
- events may coalesce; event counts are not unique-open counts;
- timestamps are collection time at this observer;
- inotify supplies no process identity — no attribution is possible;
- a renamed/deleted/invalidated watch marks the record incomplete;
- files already open, auto-loaded context, or cached content may never
  produce an open event;
- only subjects on the same filesystem are observable;
- absence of opens is meaningful only inside a completed observation
  window (ready → stop handshake).

Usage:

    observe-file-opens.py --run-root <RUN_ROOT> \
        --allow <repo-relative-path> [--allow ...] \
        --output <RUN_ROOT>/FILE_OPEN_EVENTS.jsonl \
        --ready-file <RUN_ROOT>/OBSERVE_READY \
        --stop-file <RUN_ROOT>/OBSERVE_STOP

The ready file appears only after every selected watch is registered;
create the stop file (or send SIGTERM/SIGINT) to end the window. The
observer never reads watched file contents.
"""

import argparse
import ctypes
import fnmatch
import json
import os
import select
import signal
import stat
import struct
import sys
import time

IN_OPEN = 0x00000020
IN_DELETE_SELF = 0x00000400
IN_MOVE_SELF = 0x00000800
IN_UNMOUNT = 0x00002000
IN_Q_OVERFLOW = 0x00004000
IN_IGNORED = 0x00008000
WATCH_MASK = IN_OPEN | IN_DELETE_SELF | IN_MOVE_SELF | IN_UNMOUNT | IN_IGNORED

MASK_NAMES = [
    (IN_OPEN, "IN_OPEN"),
    (IN_DELETE_SELF, "IN_DELETE_SELF"),
    (IN_MOVE_SELF, "IN_MOVE_SELF"),
    (IN_UNMOUNT, "IN_UNMOUNT"),
    (IN_Q_OVERFLOW, "IN_Q_OVERFLOW"),
    (IN_IGNORED, "IN_IGNORED"),
]

EVENT_STRUCT = struct.Struct("iIII")

SECRET_NAME_PATTERNS = [
    ".env", ".env.*", "*.pem", "*.key", "*.p12", "*.pfx", "*.jks",
    "*.keystore", "id_rsa", "id_rsa.*", "id_ed25519", "id_ed25519.*",
    "credentials", "credentials.*", "secrets", "secrets.*",
    ".netrc", ".npmrc", ".pypirc",
]


def fail(msg):
    print(f"observe-file-opens: {msg}", file=sys.stderr)
    sys.exit(1)


def iso_utc(ts):
    return time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(ts)) + \
        f".{int((ts % 1) * 1e6):06d}Z"


def mask_names(mask):
    names = [name for bit, name in MASK_NAMES if mask & bit]
    return names or [f"0x{mask:x}"]


def check_secret_name(name, rel):
    for pat in SECRET_NAME_PATTERNS:
        if fnmatch.fnmatch(name, pat):
            fail(f"allowlist path matches a credential-like name: {rel!r}")


def validate_allow(repo_real, rel):
    """Return (normalized label, (dev, ino)) or fail closed.

    Every path component is validated without following symlinks: a
    symlinked intermediate directory — including an alias into .git — is
    rejected, and the resolved identity is re-checked for forbidden
    components.
    """
    if not rel or rel.startswith("/") or rel.startswith("~"):
        fail(f"allowlist path must be a plain relative path: {rel!r}")
    norm = os.path.normpath(rel)
    if norm == ".." or norm.startswith("../") or norm == ".":
        fail(f"allowlist path escapes the prepared repo: {rel!r}")
    parts = norm.split(os.sep)
    if ".git" in parts:
        fail(f"allowlist path enters .git internals: {rel!r}")
    check_secret_name(parts[-1], rel)
    # intermediate components must be real directories — lstat each so a
    # directory symlink cannot smuggle in .git internals or an escape
    cur = repo_real
    for comp in parts[:-1]:
        cur = os.path.join(cur, comp)
        try:
            st = os.lstat(cur)
        except OSError:
            fail(f"allowlist path component does not exist: {rel!r}")
        if not stat.S_ISDIR(st.st_mode) or stat.S_ISLNK(st.st_mode):
            fail(f"allowlist path component is not a real directory: "
                 f"{rel!r}")
    candidate = os.path.join(repo_real, norm)
    try:
        st = os.lstat(candidate)
    except OSError:
        fail(f"allowlist path does not exist: {rel!r}")
    if not stat.S_ISREG(st.st_mode):
        fail(f"allowlist path is not a regular file (symlinks rejected): "
             f"{rel!r}")
    if st.st_nlink != 1:
        fail(f"allowlist path has extra hardlinks: {rel!r}")
    real = os.path.realpath(candidate)
    if not real.startswith(repo_real + os.sep):
        fail(f"allowlist path resolves outside the prepared repo: {rel!r}")
    # forbidden-component checks apply to the resolved identity as well
    real_rel = os.path.relpath(real, repo_real)
    if ".git" in real_rel.split(os.sep):
        fail(f"allowlist path resolves into .git internals: {rel!r}")
    check_secret_name(os.path.basename(real), rel)
    return norm, (st.st_dev, st.st_ino)


def main():
    ap = argparse.ArgumentParser(prog="observe-file-opens.py")
    ap.add_argument("--run-root", required=True)
    ap.add_argument("--allow", action="append", required=True)
    ap.add_argument("--output", required=True)
    ap.add_argument("--ready-file", required=True)
    ap.add_argument("--stop-file", required=True)
    args = ap.parse_args()

    if sys.platform != "linux":
        fail("unsupported platform: Linux inotify required")

    run_root = args.run_root
    repo = os.path.join(run_root, "repo")
    # the prepared-run boundary itself must be real directories — a
    # symlinked run root or repo could alias a sibling directory with a
    # planted .git, defeating the boundary check
    for comp in (run_root, repo):
        try:
            st = os.lstat(comp)
        except OSError:
            fail(f"run boundary component does not exist: {comp}")
        if not stat.S_ISDIR(st.st_mode) or stat.S_ISLNK(st.st_mode):
            fail(f"run boundary component is not a real directory: {comp}")
    if not os.path.isdir(os.path.join(repo, ".git")):
        fail("not a prepared run boundary (missing repo/.git): "
             f"{args.run_root}")
    repo_real = os.path.realpath(repo)

    labels = []
    label_ids = {}
    seen = set()
    seen_ids = set()
    for rel in args.allow:
        norm, ident = validate_allow(repo_real, rel)
        if norm in seen:
            fail(f"duplicate allowlist path: {rel!r}")
        if ident in seen_ids:
            fail(f"allowlist paths share one inode identity: {rel!r}")
        seen.add(norm)
        seen_ids.add(ident)
        labels.append(norm)
        label_ids[norm] = ident

    for p in (args.output, args.ready_file, args.stop_file):
        if os.path.lexists(p):
            fail(f"refusing to overwrite existing path: {p}")

    libc = ctypes.CDLL(None, use_errno=True)
    try:
        inotify_init1 = libc.inotify_init1
        inotify_add_watch = libc.inotify_add_watch
    except AttributeError:
        fail("inotify unavailable on this platform")
    inotify_init1.restype = ctypes.c_int
    inotify_init1.argtypes = [ctypes.c_int]
    inotify_add_watch.restype = ctypes.c_int
    inotify_add_watch.argtypes = [ctypes.c_int, ctypes.c_char_p,
                                  ctypes.c_uint32]

    fd = inotify_init1(os.O_NONBLOCK | os.O_CLOEXEC)
    if fd < 0:
        fail(f"inotify_init1 failed: errno {ctypes.get_errno()}")

    wd_to_label = {}
    try:
        for label in labels:
            wd = inotify_add_watch(
                fd, os.path.join(repo_real, label).encode(), WATCH_MASK)
            if wd < 0:
                fail(f"inotify_add_watch failed for {label}: "
                     f"errno {ctypes.get_errno()}")
            if wd in wd_to_label:
                fail("two allowed paths resolve to one watch identity: "
                     f"{label} aliases {wd_to_label[wd]}")
            wd_to_label[wd] = label
    except BaseException:
        os.close(fd)
        raise

    seq = 0
    reasons = []
    started_wall = time.time()
    started_mono = time.monotonic()
    try:
        out = open(args.output, "x", encoding="utf-8")
    except OSError as exc:
        os.close(fd)
        fail(f"cannot create output file: {exc}")

    def emit(obj):
        out.write(json.dumps(obj, separators=(",", ":")) + "\n")
        out.flush()

    def parse_events(data):
        nonlocal seq
        off = 0
        while off + EVENT_STRUCT.size <= len(data):
            wd, mask, _cookie, length = EVENT_STRUCT.unpack_from(data, off)
            off += EVENT_STRUCT.size + length
            seq += 1
            names = mask_names(mask)
            if wd == -1:  # IN_Q_OVERFLOW carries wd=-1
                emit({"type": "event", "seq": seq, "label": None,
                      "mask": names,
                      "wall": iso_utc(time.time()),
                      "mono": time.monotonic()})
                reasons.append("queue-overflow")
                continue
            label = wd_to_label.get(wd)
            emit({"type": "event", "seq": seq, "label": label,
                  "mask": names,
                  "wall": iso_utc(time.time()), "mono": time.monotonic()})
            if mask & (IN_IGNORED | IN_DELETE_SELF | IN_MOVE_SELF
                       | IN_UNMOUNT):
                reasons.append(f"watch-invalidated:{label}")

    stopping = False

    def _sig(_signum, _frame):
        nonlocal stopping
        stopping = True
    signal.signal(signal.SIGTERM, _sig)
    signal.signal(signal.SIGINT, _sig)

    try:
        emit({"type": "observe-file-opens", "version": 1,
              "labels": labels,
              "wall": iso_utc(started_wall), "mono": started_mono})
        # READY handshake: published only after every selected watch is
        # registered — before the subject is launched.
        emit({"type": "ready", "watches": len(wd_to_label),
              "wall": iso_utc(time.time()), "mono": time.monotonic()})
        with open(args.ready_file, "x", encoding="utf-8") as rf:
            rf.write("ready\n")

        while not (stopping or os.path.exists(args.stop_file)):
            r, _, _ = select.select([fd], [], [], 0.2)
            if r:
                parse_events(os.read(fd, 65536))

        # explicit stop/end handshake: drain the still-queued events,
        # then close the window with a footer record; a queue that never
        # empties within the bound marks the record incomplete
        for _ in range(50):
            r, _, _ = select.select([fd], [], [], 0.1)
            if not r:
                break
            data = os.read(fd, 65536)
            if not data:
                break
            parse_events(data)
        else:
            r, _, _ = select.select([fd], [], [], 0)
            if r:
                reasons.append("drain-truncated")

        # end-of-window path revalidation: a renamed parent directory
        # leaves the registered pathname stale without any file-watch
        # event — compare each label's current inode identity (never its
        # contents) so a lost path binding marks the record incomplete
        for label in labels:
            try:
                st = os.lstat(os.path.join(repo_real, label))
            except OSError:
                reasons.append(f"path-binding-lost:{label}")
                continue
            if (not stat.S_ISREG(st.st_mode)
                    or (st.st_dev, st.st_ino) != label_ids[label]):
                reasons.append(f"path-binding-lost:{label}")

        emit({"type": "stop", "drained": True,
              "incomplete": bool(reasons),
              "reasons": sorted(set(reasons)),
              "wall": iso_utc(time.time()), "mono": time.monotonic()})
    except BaseException:
        try:
            emit({"type": "abort",
                  "wall": iso_utc(time.time()), "mono": time.monotonic()})
        finally:
            out.close()
            os.close(fd)
        raise

    out.close()
    os.close(fd)


if __name__ == "__main__":
    main()
