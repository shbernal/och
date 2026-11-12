#!/usr/bin/env bash
# `och session list` on a machine with no OpenClaw sessions says so and exits 0.
set -euo pipefail

och="$(cd "$(dirname "$0")/.." && pwd)/och"
home="$(mktemp -d)"
trap 'rm -rf "$home"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

out="$(HOME="$home" bash "$och" session list 2>&1)" || fail "exit status $? with no agents dir"
[[ "$out" == "no sessions found" ]] || fail "no agents dir printed: $out"

mkdir -p "$home/.openclaw/agents/main/sessions"
printf '{"agent:main:x":{"displayName":"hi"}}\n' >"$home/.openclaw/agents/main/sessions/sessions.json"
out="$(HOME="$home" NO_COLOR=1 bash "$och" session list 2>&1)" || fail "exit status $? with one session"
[[ "$out" == *"agent:main:x -> hi"* ]] || fail "one session printed: $out"

printf 'ok: session list\n'
