# Dotfiles

A modern, fast, and cross-platform dotfiles configuration for **macOS** and **Linux** managed via [chezmoi](https://www.chezmoi.io/).

## Highlights

- **Manager**: [chezmoi](https://www.chezmoi.io/) for declarative state management, diffing, and templating.
- **Shell**: Fast, framework-free **Zsh** with history deduplication, intelligent tab completion, and `.nvmrc` auto-switching.
- **Prompt**: [Starship](https://starship.rs/) cross-shell prompt with Git, Node, and Go indicators.
- **Git Profiles**: Dynamic work vs. personal identities using Git's `includeIf` directory matching.
- **Editor**: Cross-platform **VS Code** synchronization (`~/.config/Code/User/` on Linux, `~/Library/Application Support/Code/User/` on macOS).
- **AI Tooling**: Global configurations, custom skills, rules, and MCP servers for **Antigravity (AGY)**.
- **Zero Secrets in Git**: Clean uncommitted `~/.zshrc.local` pattern for API keys and machine overrides.

---

## Quickstart & Installation

### Option A: One-Liner (New Machine)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply EoinTraynor
```

### Option B: Clone & Run Local Installer
```bash
git clone https://github.com/EoinTraynor/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles
./install.sh
```

---

## Directory Layout

```text
dotfiles/
├── .chezmoi.toml.tmpl                 # Prompts for personal name, email & work directory
├── .chezmoiignore                     # Ignore list (filters OS-specific target paths)
├── .chezmoiversion                    # Minimum required chezmoi version
├── .chezmoitemplates/                 # Shared template snippets (VS Code settings, etc.)
│   ├── vscode-settings.json
│   └── vscode-keybindings.json
│
├── dot_zshenv                         # Environment variables (XDG, PATH, GOPATH)
├── dot_zprofile                       # Login shell startup (Homebrew paths for macOS/Linux)
├── dot_zshrc.tmpl                     # Interactive Zsh config & Starship initialization
│
├── dot_config/
│   ├── starship.toml                  # Starship prompt theme
│   └── Code/User/                     # VS Code config (Linux target)
│       ├── settings.json.tmpl
│       └── keybindings.json.tmpl
│
├── Library/Application Support/Code/User/ # VS Code config (macOS target)
│   ├── settings.json.tmpl
│   └── keybindings.json.tmpl
│
├── dot_gemini/config/                 # Antigravity (AGY) global configurations
│   ├── mcp_config.json.tmpl           # Global MCP server declarations
│   ├── rules/                         # Global coding and behavior rules
│   └── skills/                        # Global custom workflow skills
│
├── dot_gitconfig.tmpl                 # Personal Git configuration (default)
├── dot_gitconfig-work.tmpl            # Work Git identity override
├── dot_gitignore_global               # Global Git ignore rules
│
├── install.sh                         # Bootstrap installer script
├── CONTRIBUTING.md                    # Guide to extending and adding new tools
└── README.md
```

---

## Daily Workflow Cheat Sheet

| Command | Action |
| :--- | :--- |
| `chezmoi diff` | Inspect differences between dotfiles repo and your home directory |
| `chezmoi apply` | Safely apply changes from the repository to `$HOME` |
| `chezmoi edit <file>` | Edit a managed file directly in your editor and apply immediately |
| `chezmoi cd` | Open a shell inside the local dotfiles repository |
| `chezmoi update` | Pull remote git updates and apply them in one step |

Convenient aliases are pre-configured in `.zshrc`:
- `cm` -> `chezmoi`
- `cmd` -> `chezmoi diff`
- `cma` -> `chezmoi apply`
- `cme` -> `chezmoi edit`
- `dotfiles` -> jumps directly to the dotfiles repository

---

## Configuration & Customization

### 1. Work vs. Personal Git Identities
- **Personal (Default)**: Any repo on your machine defaults to your personal name and email defined in `~/.gitconfig`.
- **Work Overrides**: Any repo placed inside your designated work folder (default `~/work/`) automatically inherits the work identity from `~/.gitconfig-work`.

To configure or change your work email:
```bash
chezmoi edit ~/.gitconfig-work
```

### 2. Secret Management (API Keys & Tokens)
Never commit secrets, tokens, or API credentials to git. Place them in:
```bash
~/.zshrc.local
```
Example content:
```zsh
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GEMINI_API_KEY="..."
export GITHUB_TOKEN="..."
```
This file is automatically sourced by `.zshrc` if present, but is excluded from version control.

---

## Extending & Contributing

Want to add a new tool (e.g. `tmux`, `ghostty`, or CLI utilities)?
See the **[CONTRIBUTING.md](./CONTRIBUTING.md)** guide for conventions, templates, and testing steps.
