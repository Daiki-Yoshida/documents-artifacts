#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)/shared/name.sh"

preview_contact() {
  local raw_name="$1"
  # Current defect: the staff display repeats imported whitespace.
  printf 'Name: %s\n' "$(contact_name "$raw_name")"
}
