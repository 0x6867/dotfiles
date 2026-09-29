# Legacy config backup — 2026-09-29

Snapshot of the pre-migration shell/editor config files that used to live at the
top level of `config/`, taken before `config/` was reduced to the directories
that are symlinked into the home directory by home-manager
(`config/nvim`, `config/zsh`, `config/wezterm`).

Nothing here is imported by any Nix module. This directory is inert with respect
to the build; it exists only for provenance.

## Why these files

The top-level files were superseded by the per-tool directories:

| Old path | Superseded by |
|---|---|
| `config/.zshrc` | `config/zsh/.zshrc` |
| `config/.zshenv` | `config/zsh/.zshenv` |
| `config/.gitignore` | `config/zsh/.gitignore` |

The `.zshrc`/`.zshenv`/`.gitignore` pairs were byte-identical duplicates at the
time of the move, verified with `diff`. The duplicates are kept rather than
deleted so the pre-migration state is recoverable without relying on git
history alone.

## Contents

- `.zshrc`, `.zshenv`, `.gitignore` — the legacy top-level duplicates.
- `.zshrc.omz-uninstalled-2026-08-10_22-20-23` — oh-my-zsh uninstall artifact.
- `.zshrc~` (top level and `zsh/`) — editor backups.
- `.init.lua.un~` (top level and `nvim/`) — Vim undo-file droppings.
- `wezterm/.wezterm.lua.un~` — Vim undo-file dropping.
- `wezterm/wezterm.lua~` — empty (0 bytes) editor backup.