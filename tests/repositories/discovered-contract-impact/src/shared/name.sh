#!/usr/bin/env bash
# Shared imported-contact value, not a presentation-only formatter.
# Both staff preview and the published batch export use this operation.

contact_name() {
  printf '%s' "$1"
}
