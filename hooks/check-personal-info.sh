#!/bin/sh
# Privacy guard scanner. Returns 1 if any personal-info pattern matches.
#
# Usage:
#   check-personal-info.sh <file>...           # scan working-tree files
#   check-personal-info.sh --stdin <label>     # scan stdin, attribute hits to <label>
#
# Patterns are intentionally narrow to avoid false positives in Dutch text.
# Adjust the PATTERN string below if a real-world string keeps tripping it.

set -eu

# Patterns are the things that should never end up in a public commit.
# Note: bare "VinceVerbon" is intentionally NOT here — that handle is the
# public repo owner and appears in the GitHub URL. The patterns below catch
# identifiers that are NOT already public from the repo URL alone:
#   vverb        Windows username (also catches vverbon)
#   verbon\.net  personal email domain (vverbon@verbon.net)
#   vincent@     work email start (vincent@syquens.com)
#   @syquens     work email/domain
#   syquens      company name
#   MYAI_*       internal env-var names
#   OP_SA_TOKEN  1Password service-account env-var
#   gho_/ghp_/ghs_  GitHub OAuth/PAT/server tokens
#   op://        1Password secret references
#   C:\Users\vverb  local Windows home path
#   Kim en Vince    1Password vault name
#   Hymer 2018      previously-scrubbed camper model hint (block re-introduction)
PATTERN='vverb|verbon\.net|vincent@|@syquens\.com|syquens|MYAI_SYSTEM_ID|OP_SA_TOKEN|gho_[A-Za-z0-9_]{30,}|ghp_[A-Za-z0-9_]{30,}|ghs_[A-Za-z0-9_]{30,}|op://|C:\\Users\\vverb|Kim en Vince|Hymer 2018'

scan_one() {
  _label="$1"
  _content="$2"
  _hits=$(printf '%s\n' "$_content" | grep -EniH --label="$_label" "$PATTERN" || true)
  if [ -n "$_hits" ]; then
    printf '\033[31mPRIVACY GUARD\033[0m: hit(s) in %s\n%s\n\n' "$_label" "$_hits" >&2
    return 1
  fi
  return 0
}

rc=0

if [ "${1:-}" = "--stdin" ]; then
  label="${2:-stdin}"
  content=$(cat)
  scan_one "$label" "$content" || rc=1
else
  for f in "$@"; do
    [ -f "$f" ] || continue
    case "$f" in
      hooks/*|scripts/install-hooks.*|CLAUDE.md|.claude/*|.git/*) continue ;;
    esac
    content=$(cat "$f")
    scan_one "$f" "$content" || rc=1
  done
fi

if [ "$rc" -ne 0 ]; then
  printf 'BLOCKED. Scrub personal info, or refine the pattern in hooks/check-personal-info.sh.\n' >&2
  printf 'To bypass for a known-safe edit (NOT for routine use): git commit --no-verify / git push --no-verify.\n' >&2
fi

exit $rc
