#!/usr/bin/env python3
import sys
import json
import subprocess

def format_tokens(n):
    if not n:
        return "0"
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n / 1_000:.1f}k"
    return str(n)

try:
    raw = sys.stdin.read()
    data = json.loads(raw) if raw.strip() else {}
    parts = []

    # 1. Git / VCS info
    vcs = data.get("vcs") or {}
    branch = vcs.get("branch")
    is_dirty = vcs.get("dirty", False)

    # Fallback to fast local git if agy has not cached branch yet
    if not branch and vcs.get("type") == "git":
        try:
            branch = subprocess.check_output(
                ["git", "rev-parse", "--abbrev-ref", "HEAD"],
                stderr=subprocess.DEVNULL,
                timeout=0.1,
                text=True
            ).strip()
            status = subprocess.check_output(
                ["git", "status", "--porcelain"],
                stderr=subprocess.DEVNULL,
                timeout=0.1,
                text=True
            ).strip()
            is_dirty = bool(status)
        except Exception:
            branch = None

    if branch:
        if is_dirty:
            git_str = f"\033[33m⎇ {branch}*\033[0m"
        else:
            git_str = f"\033[32m⎇ {branch}\033[0m"
        parts.append(git_str)

    # 2. Context window usage
    ctx = data.get("context_window") or data.get("context") or {}
    limit = ctx.get("context_window_size") or ctx.get("limit") or 1_048_576
    used = ctx.get("total_tokens") or (ctx.get("total_input_tokens", 0) + ctx.get("total_output_tokens", 0)) or ctx.get("used", 0)
    pct = ctx.get("used_percentage") or ((used / limit * 100) if limit else 0)
    ctx_color = "\033[32m" if pct < 60 else ("\033[33m" if pct < 80 else "\033[31m")
    parts.append(f"Context: {ctx_color}{format_tokens(used)}/{format_tokens(limit)} ({pct:.1f}%)\033[0m")

    # 3. Token flow (in / out)
    cost = data.get("cost") or {}
    in_tok = cost.get("input_tokens") or ctx.get("total_input_tokens") or 0
    out_tok = cost.get("output_tokens") or ctx.get("total_output_tokens") or 0
    parts.append(f"Tokens: \033[34m↑{format_tokens(in_tok)} ↓{format_tokens(out_tok)}\033[0m")

    # 4. Spend & Subagents breakdown
    total_usd = cost.get("total_usd", 0.0)
    sub_usd = cost.get("subagent_usd", 0.0)
    subagents = data.get("subagents") or data.get("subagent") or []
    sub_count = len(subagents) if isinstance(subagents, list) else data.get("subagent_count", 0)

    spend_str = f"Spend: \033[32m${total_usd:.4f}\033[0m"
    if sub_usd > 0 or sub_count > 0:
        sub_details = []
        if sub_count > 0:
            sub_details.append(f"{sub_count} sub{'s' if sub_count != 1 else ''}")
        if sub_usd > 0:
            sub_details.append(f"${sub_usd:.4f}")
        spend_str += f" (\033[35m🤖 {', '.join(sub_details)}\033[0m)"

    parts.append(spend_str)

    print(" │ ".join(parts))
except Exception:
    pass
