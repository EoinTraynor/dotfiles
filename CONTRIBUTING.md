# Contributing & Extending Dotfiles

This guide outlines conventions and best practices for adding new tools, modifying configurations, and maintaining cross-platform compatibility across **macOS** and **Linux**.

---

## 1. Golden Rules

1. **No Secrets**: Never commit passwords, private keys (`id_rsa`, `id_ed25519`), session tokens, or API keys. Always use `~/.zshrc.local` or a password manager CLI.
2. **Idempotency**: All setup scripts and configurations must be safe to execute multiple times.
3. **Prefer XDG Base Directories**: Place configs inside `~/.config/<tool>/` whenever the tool supports it.
4. **Always Test with `chezmoi diff`**: Preview diffs before running `chezmoi apply`.

---

## 2. Adding a New Tool or Config

### Scenario A: Adding a Simple Static Config
If the tool uses standard files without machine-specific variables:
```bash
# Example: Adding a tmux config
chezmoi add ~/.tmux.conf
# or XDG compliant:
chezmoi add ~/.config/tmux/tmux.conf
```
This copies the file into the dotfiles repo with the appropriate `dot_` prefix.

### Scenario B: Adding a Config That Needs Variables or OS Conditionals
If a config requires different paths or settings on macOS vs. Linux:
1. Turn the file into a template:
   ```bash
   chezmoi chattr +template ~/.config/<tool>/config
   ```
2. In the template file (`dot_config/<tool>/config.tmpl`), use Go template logic:
   ```gotemplate
   {{ if eq .chezmoi.os "darwin" }}
   # macOS specific setting
   font_size = 14
   {{ else }}
   # Linux specific setting
   font_size = 12
   {{ end }}
   ```

### Scenario C: Sharing Configs Across Different OS Target Paths (e.g. VS Code)
macOS and Linux often store application files in different target directories:
- **macOS**: `~/Library/Application Support/<App>/`
- **Linux**: `~/.config/<App>/`

To keep them in sync without duplication:
1. Put the canonical content inside `.chezmoitemplates/<app>-config.json`.
2. Create both target templates:
   - `dot_config/<App>/config.json.tmpl`:
     ```gotemplate
     {{ template "<app>-config.json" . }}
     ```
   - `Library/Application Support/<App>/config.json.tmpl`:
     ```gotemplate
     {{ template "<app>-config.json" . }}
     ```
3. Update `.chezmoiignore` so each OS only installs to its native path:
   ```text
   {{ if ne .chezmoi.os "darwin" }}
   Library/**
   {{ end }}

   {{ if ne .chezmoi.os "linux" }}
   .config/<App>/**
   {{ end }}
   ```

---

## 3. Adding or Updating Antigravity (AGY) Customizations

AGY automatically discovers global configurations placed under `~/.gemini/config/`:

* **Global Rules (`dot_gemini/config/rules/<name>.md`)**:
  Add markdown guidelines for coding conventions, test requirements, or pair-programming styles.
  ```markdown
  ---
  description: Guideline summary
  always_on: true
  ---
  # Rule content
  ```
* **Global Skills (`dot_gemini/config/skills/<name>/SKILL.md`)**:
  Add reusable multi-step runbooks and developer workflows.
* **Global MCP Servers (`dot_gemini/config/mcp_config.json.tmpl`)**:
  Add new Model Context Protocol tool integrations.

---

## 4. Verification & Testing Workflow

Before committing changes, run this checklist:

1. **Diff verification**:
   ```bash
   chezmoi diff
   ```
   Ensure only the intended files and lines have changed.

2. **Dry run apply**:
   ```bash
   chezmoi apply --dry-run --verbose
   ```
   Confirm that chezmoi can parse all templates and write targets without errors.

3. **Format & Commit**:
   Follow conventional commits:
   - `feat(tool): add alacritty config`
   - `fix(zsh): correct nvm completion path`
   - `docs: update quickstart instructions`
