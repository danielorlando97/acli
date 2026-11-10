# acli

> Multi-profile launcher for **Antigravity CLI**, **OpenCode**, **Antigravity IDE**, **Claude Code** and **Codex CLI** — manage independent accounts, credentials, and sessions for every job or client on the same machine.

---

## The Problem

If you work across multiple jobs or clients, each with separate AI tool accounts (Antigravity, OpenCode), you've probably hit this:

- Logging into a second account kicks you out of the first
- Histories, tokens, and preferences bleed between contexts
- Opening two Antigravity IDE windows connects them to the same account

`acli` solves this by giving each job **a fully isolated profile** with its own credentials, session history, and configuration — all launched from one simple command.

---

## Installation

### Quick install (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/danielorlando97/acli/main/install.sh | bash
```

### Manual

```bash
# Clone the repo
git clone https://github.com/danielorlando97/acli.git
cd acli

# Install to ~/.local/bin (or /usr/local/bin if writable)
./install.sh
```

---

## Usage

```
acli <tool> <profile> [arguments...]
acli create <profile>
acli list
acli path <profile>
acli delete <profile>
acli version
acli help
```

### Available Tools

| Tool alias | Launches |
|---|---|
| `agy`, `cli` | Antigravity CLI (`agy`) |
| `opencode`, `oc` | OpenCode |
| `ide`, `app` | Antigravity Desktop IDE |
| `claude`, `cc` | Claude Code (`claude`) |
| `codex` | Codex CLI (`codex`) |

---

## Examples

### Create a profile

```bash
acli create work-empresa1
```

Profiles are stored in `~/.acli/profiles/`. They're created automatically on first use too.

### Antigravity CLI

```bash
# Start agy — if new, it will prompt you to log in
acli agy work-empresa1

# Continue last session
acli agy work-empresa1 --continue

# Use a specific model
acli agy work-empresa1 -m gemini-2.5-pro
```

### OpenCode

```bash
# Configure credentials for this profile
acli opencode work-empresa2 providers auth

# Launch the TUI
acli opencode work-empresa2

# Run with a specific model
acli opencode work-empresa2 --model anthropic/claude-sonnet-4-5
```

### Antigravity IDE (Desktop App)

```bash
# Open the desktop IDE with the account for empresa3
acli ide work-empresa3 .

# Multiple windows, multiple accounts — all at once
acli ide work-empresa1 ~/src/empresa1
acli ide work-empresa2 ~/src/empresa2
```

### Claude Code

```bash
# Start Claude Code — first run will prompt you to log in
acli claude work-empresa4

# Continue the last session
acli claude work-empresa4 --continue

# Use claude with a specific tool config
acli claude work-empresa4 --allowedTools Bash Edit
```

### Codex CLI

```bash
# Log in to OpenAI for this profile
acli codex work-empresa5 login

# Start a new session
acli codex work-empresa5

# Run non-interactively
acli codex work-empresa5 exec "refactor this file"
```

### Profile Management

```bash
# View all profiles and their auth status
acli list

# Print the directory path for a profile
acli path work-empresa1

# Delete a profile and all its data
acli delete old-client
```

---

## How It Works

Each profile creates an isolated directory under `~/.acli/profiles/<profile>/`:

```
~/.acli/profiles/work-empresa1/
├── home/                    # Isolated $HOME for agy → owns ~/.gemini/antigravity-cli
│   ├── .ssh -> ~/.ssh       # Symlink — your SSH keys work as normal
│   └── .gitconfig           # Copied from your real .gitconfig as a base
├── opencode/
│   ├── config/              # XDG_CONFIG_HOME for OpenCode
│   ├── data/                # XDG_DATA_HOME (auth tokens, DB)
│   └── cache/               # XDG_CACHE_HOME
├── antigravity-ide/         # --user-data-dir for the desktop IDE
├── claude/                  # CLAUDE_CONFIG_DIR for Claude Code
└── codex/                   # CODEX_HOME for Codex CLI
```

### Isolation strategy per tool

| Tool | Mechanism |
|---|---|
| `agy` | `HOME` override → each profile owns its `~/.gemini/antigravity-cli` |
| `opencode` | `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME` overrides |
| Antigravity IDE | `--user-data-dir` flag + `open -n` (macOS new instance) |
| `claude` | `CLAUDE_CONFIG_DIR` override |
| `codex` | `CODEX_HOME` override |

---

## Configuration

### Custom base directory

By default profiles live in `~/.acli/profiles`. Override with:

```bash
export ACLI_BASE="/Volumes/WorkDrive/.acli/profiles"
```

### Shell autocompletion (Zsh)

Add to your `~/.zshrc`:

```zsh
_acli() {
  local -a tools
  tools=(agy cli opencode oc ide app create list path delete version help)
  if (( CURRENT == 2 )); then
    _describe 'tool' tools
  elif (( CURRENT == 3 )) && [[ "$words[2]" != "list" && "$words[2]" != "help" && "$words[2]" != "version" ]]; then
    local -a profiles
    if [ -d "${ACLI_BASE:-$HOME/.acli/profiles}" ]; then
      profiles=($(ls "${ACLI_BASE:-$HOME/.acli/profiles}" 2>/dev/null))
    fi
    _describe 'profile' profiles
  fi
}
compdef _acli acli
```

---

## Requirements

- macOS (Linux support planned)
- One or more of:
  - [`agy`](https://antigravity.google) — Antigravity CLI
  - [`opencode`](https://opencode.ai) — OpenCode CLI
  - Antigravity IDE (`/Applications/Antigravity.app`)
  - [`claude`](https://claude.ai/download) — Claude Code CLI
  - [`codex`](https://github.com/openai/codex) — Codex CLI

---

## License

MIT © [Daniel Ortiz](https://github.com/danielorlando97)
