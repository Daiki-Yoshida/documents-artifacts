#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)/shared/name.sh"

export_contact() {
  local raw_name="$1"
  printf 'contact\t%s\n' "$(contact_name "$raw_name")"
}
