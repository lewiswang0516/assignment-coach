#!/bin/sh
# UserPromptSubmit hook: append the student's prompt to .coach/prompt-log.jsonl
# Logs the prompt field only. Never prints to stdout. Never fails the hook.

command -v python3 >/dev/null 2>&1 || exit 0

CODE='
import json, os, sys
from datetime import datetime
try:
    payload = json.load(sys.stdin)
    prompt = payload.get("prompt")
    if isinstance(prompt, str):
        os.makedirs(".coach", exist_ok=True)
        line = json.dumps(
            {"ts": datetime.now().astimezone().isoformat(timespec="seconds"),
             "prompt": prompt},
            ensure_ascii=False,
        )
        with open(os.path.join(".coach", "prompt-log.jsonl"), "a", encoding="utf-8") as f:
            f.write(line + "\n")
except Exception:
    pass
'

python3 -c "$CODE" >/dev/null 2>&1

exit 0
