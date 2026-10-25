#!/usr/bin/env bash
# Run this from inside ~/projects/jarvis (your cloned repo).
set -e

mkdir -p .github

cat > AGENTS.md <<'EOF'
# Jarvis: Personal AI Assistant (project brief)

You are the lead engineer for Jarvis. Design, implement, test and document it.
Do not just give me instructions. Work in small milestones and stop after each one.

## Context
- Owner: cybersecurity student, comfortable with Linux. Develops on Windows + WSL2 (Ubuntu).
- Prefer free / open-source software and free AI model tiers.
- ntfy notifications already work (phone receives them).
- No local AI models. Cloud providers only.

## Goal
A personal assistant that accepts tasks, manages projects, does permitted work in the
background, verifies results, and notifies me when action is needed or work is done.

## Requirements
1. Backend: Python 3.11+, FastAPI, SQLite. Modular, documented, typed where practical.
2. Tasks: create, list, update, prioritize, complete. Deadlines, project association,
   status, execution history, errors. State survives restarts.
3. Model routing: configurable providers (OpenRouter free models first, Gemini free tier second).
   Keys come from environment variables only. Fallback on rate limits/outages with bounded retries.
   Never silently switch to a paid provider. Paid models disabled by default.
   Never circumvent provider quotas. Adding a provider must not require a rewrite.
4. Background execution: jobs persisted and recoverable after restart, run in an isolated
   Docker workspace, tests captured, cancellation and bounded retries, honest failure reports.
5. Notifications: plain HTTP POST to ntfy (topic from env var). Send started / completed / failed.
   Never report success before verification.
6. Voice/phone: design for it later; do not implement now.
7. Security: no root, no unrestricted shell via API or MCP, never read or modify SSH keys or files
   outside this repo, protect credentials, require approval for destructive actions.
8. Cost: free services first, configurable request and retry limits, report exhausted providers.

## Working rules
- Do only the milestone I ask for. Then stop and summarize.
- Run the tests and show real output. Never claim something works without running it.
- Never invent test results.
- Never commit secrets. Use .env (gitignored) and keep .env.example up to date.
- If a decision is ambiguous, ask me.
- Prefer simple, maintainable solutions.

## Milestones
1. Tasks API + SQLite + tests
2. ntfy notification on task status change
3. Background worker running jobs in a Docker container
4. Model router: OpenRouter then Gemini fallback, paid off
5. Natural-language interface creating tasks via tool calls
6. Voice / phone (much later)
EOF

cp AGENTS.md .github/copilot-instructions.md

cat > .gitignore <<'EOF'
.env
.venv/
venv/
__pycache__/
*.pyc
*.db
*.sqlite3
.pytest_cache/
.idea/
.vscode/
workspaces/
EOF

cat > .env.example <<'EOF'
# Copy to .env and fill in. Never commit .env.
OPENROUTER_API_KEY=
GEMINI_API_KEY=

# Pick a long, random topic name (ntfy topics are public if guessable)
NTFY_URL=https://ntfy.sh
NTFY_TOPIC=

# Safety defaults
ALLOW_PAID_MODELS=false
MAX_REQUESTS_PER_TASK=20
MAX_RETRIES=2
EOF

cat > README.md <<'EOF'
# Jarvis

Personal AI assistant. See AGENTS.md for the project brief and milestones.
EOF

echo "Done. Files created:"
ls -A
