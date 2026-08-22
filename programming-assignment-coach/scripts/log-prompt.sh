#!/bin/sh
# UserPromptSubmit hook: append the student's prompt to .coach/prompt-log.jsonl
# Logs the redacted prompt field only. Reports failures without printing prompts.

if ! command -v python3 >/dev/null 2>&1; then
    printf '%s\n' 'assignment-coach prompt log: python3 is not available' >&2
    exit 1
fi

CODE='
import json, os, re, sys
from datetime import datetime

def fail(message):
    print("assignment-coach prompt log: " + message, file=sys.stderr)
    raise SystemExit(1)

def redact(text):
    patterns = (
        (r"-----BEGIN [^-]*PRIVATE KEY-----.*?-----END [^-]*PRIVATE KEY-----", "[REDACTED PRIVATE KEY]"),
        (r"(?i)\bBearer\s+[A-Za-z0-9._~+/=-]{8,}", "Bearer [REDACTED]"),
        (r"\b(?:sk-[A-Za-z0-9_-]{8,}|gh[pousr]_[A-Za-z0-9]{20,}|AKIA[A-Z0-9]{16})\b", "[REDACTED CREDENTIAL]"),
        (r"(?i)\b(api[_ -]?key|access[_ -]?token|auth[_ -]?token|password|secret|private[_ -]?key)\b(\s*(?:is|:|=)\s*)[^\s,;]+", r"\1\2[REDACTED]"),
    )
    for pattern, replacement in patterns:
        text = re.sub(pattern, replacement, text, flags=re.DOTALL if "PRIVATE KEY" in pattern else 0)
    return text

try:
    payload = json.load(sys.stdin)
except (json.JSONDecodeError, OSError):
    fail("invalid hook input")

if not isinstance(payload, dict):
    fail("hook input is not an object")

prompt = payload.get("prompt")
if not isinstance(prompt, str):
    fail("hook input has no string prompt")

project_dir = payload.get("cwd")
if not isinstance(project_dir, str) or not os.path.isabs(project_dir):
    project_dir = os.getcwd()

coach_dir = os.path.join(project_dir, ".coach")
enabled_path = os.path.join(coach_dir, "prompt-log-enabled")
if not os.path.isfile(enabled_path):
    raise SystemExit(0)

try:
    os.makedirs(coach_dir, exist_ok=True)
    log_path = os.path.join(coach_dir, "prompt-log.jsonl")
    line = json.dumps(
        {"ts": datetime.now().astimezone().isoformat(timespec="seconds"),
         "prompt": redact(prompt)},
        ensure_ascii=False,
    )
    descriptor = os.open(log_path, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o600)
    with os.fdopen(descriptor, "a", encoding="utf-8") as log_file:
        log_file.write(line + "\n")
    os.chmod(log_path, 0o600)
except (OSError, ValueError):
    fail("could not append to .coach/prompt-log.jsonl")
'

python3 -c "$CODE"
