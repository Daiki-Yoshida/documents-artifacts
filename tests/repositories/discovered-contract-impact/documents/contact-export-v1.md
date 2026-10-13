# Contact Export v1 — published wire contract

The batch export command is `bash bin/contactctl export "$raw_name"`.

Its stdout is exactly one line:

```text
contact<TAB><raw_name><LF>
```

`<TAB>` means one actual tab byte; `<LF>` means one newline byte. The name bytes following the tab are **the original imported string**, including leading, trailing and repeated ASCII spaces.

This is an existing published contract. A downstream importer uses the raw field for identity matching and preserves its exact whitespace; human-friendly presentation rules do not apply to the export. Callers and providers must stay compatible with the previous output. Changing this wire guarantee requires explicit authorization for a breaking public contract change.

The staff preview has different ownership: its spacing is presentation, not interchange data.
