# agents.md — AI agent guide for this repo

Guidance for AI coding agents (and humans) working in this repository.
Read this before making changes. Nix errors are hard to read; understand the
layout first, then make small, validated changes.

## What this repo is

A flake-based personal dotfiles/Nix config managing:

- **NixOS** (desktop, `x86_64-linux`, hostname `desktop-nix`) — COSMIC DE,
  systemd-boot, amdgpu graphics, NetworkManager.
- **NixOS** (mbp2015-linux, `x86_64-linux`, hostname `mbp2015-linux`) — a
  2015 Intel MacBook Pro: systemd-boot, Intel iGPU (no amdgpu/COSMIC),
  Broadcom wifi firmware enabled.
- **nix-darwin** (macbook, `x86_64-darwin`, hostname `macbook-nix`) —
  currently an empty placeholder module; build targets exist but are not
  provisioned yet.
- **home-manager** (release-26.05) user environments for both hosts.

All inputs follow `nixpkgs` (branch `nixos-26.05`). Flakes
experimental features are required by every command below.

## Layout

| Path | Purpose |
|---|---|
| `flake.nix` | Top-level entry: inputs, `nixosConfigurations.desktop-nix`, `darwinConfigurations.macbook-nix` |
| `flake.lock` | Locked inputs — never edit by hand; use `nix flake update` |
| `hosts/desktop/configuration.nix` | NixOS system config: kernel, bootloader, users, packages, COSMIC, unfree policy |
| `hosts/desktop/disk-config.nix` | Disko declarative partitioning (used only at install time) |
| `hosts/desktop/hardware-configuration.nix` | Machine-generated; do not hand-edit except via `nixos-generate-config` |
| `hosts/mbp2015-linux/configuration.nix` | NixOS config for the 2015 MacBook Pro (systemd-boot, wifi firmware, Intel iGPU) |
| `hosts/macbook/darwin-configuration.nix` | Darwin system config (empty placeholder) |
| `home/desktop.nix` | Home-manager config for user `nixos_user` (imports `modules/*`) |
| `home/mbp2015-linux.nix` | Home-manager config for user `nixos_user` on the MBP (imports `modules/*`) |
| `home/laptop.nix` | Home-manager config for darwin user (empty placeholder) |
| `modules/` | Shared, importable home-manager modules (one per app/tool) |
| `README.md` | Disk-install (disko) quickstart |

## Commands

Relevant targets: `desktop-nix` and `mbp2015-linux` (NixOS), `macbook-nix`
(darwin, placeholder). The home-manager users inside each target are
`nixos_user` (desktop, MBP) and `nix_dev` (macbook).

```bash
# Validate the whole flake before proposing or after making any change
nix flake check

# Rebuild & switch the NixOS desktop (safe, imperative, on the host)
sudo nixos-rebuild switch --flake .#desktop-nix

# Rebuild & switch the NixOS MacBook Pro
sudo nixos-rebuild switch --flake .#mbp2015-linux

# Rebuild & switch darwin (on the macbook)
darwin-rebuild switch --flake .#macbook-nix

# Update inputs
nix flake update [input-name]
```

## Verify the target first

- Before making changes, identify the exact target config and the machine/OS
  required to validate it. This repo has three targets: `desktop-nix` and
  `mbp2015-linux` (NixOS, validated on their respective machines) and
  `macbook-nix` (darwin, placeholder, validated on the macbook).
- Do not assume the edited path name matches the flake output. Examples:
  `home/desktop.nix` / `home/mbp2015-linux.nix` → user `nixos_user` under
  `nixosConfigurations.desktop-nix` / `nixosConfigurations.mbp2015-linux`;
  `home/laptop.nix` → user `nix_dev` under
  `darwinConfigurations.macbook-nix`; `modules/*` are imported from
  `home/*.nix` and affect whichever host imports them.
- State this explicitly before editing:
  `Target config: <name>. Validation host: <machine/OS>. Planned verification: <command>.`

## Always validate with eval

- After every Nix change, run a matching `nix eval` against the exact target
  output before claiming success.
- Preferred eval targets for this repo:
  - NixOS: `nix eval .#nixosConfigurations.desktop-nix.config.system.build.toplevel.drvPath`
    and `nix eval .#nixosConfigurations.mbp2015-linux.config.system.build.toplevel.drvPath`
  - Darwin: `nix eval .#darwinConfigurations.macbook-nix.config.system.build.toplevel.drvPath`
    (once the darwin config is filled in — it is currently an empty placeholder)
  - Home Manager (wired inside the host configs, not a top-level
    `homeConfigurations` output):
    `nix eval .#nixosConfigurations.desktop-nix.config.home-manager.users.nixos_user.home.activationPackage.drvPath`
- When practical, follow eval with the matching dry-run/build command
  (`nixos-rebuild build --flake .#desktop-nix`, `darwin-rebuild build` once
  darwin exists, or `nix flake check`). Eval is the minimum bar, not the
  whole test plan.

## Conventions

- **Modules**: one file per tool in `modules/`, Nix module signature
  `{ pkgs, ... }: { ... }`, imported via relative path from `home/*.nix`.
- **Users**: desktop user is `nixos_user`; darwin user is `nix_dev`.
  If you rename users, update **all** of: `home/*.nix`, `users.users.*`
  in `hosts/`, and the `home-manager.users.*` wiring in `flake.nix`.
- **stateVersion** is pinned to `26.05` everywhere — only bump with an
  explicit user request.
- **Unfree**: `nixpkgs.config.allowUnfree = true` globally (desktop). Don't
  reintroduce a per-package allowlist without asking; it was removed on purpose.
- Leave `hardware-configuration.nix` and `flake.lock` out of agent edits.

## Known issues / gotchas

- `home/desktop.nix` imports `../modules/cli_tools.nix`, which does not
  exist in the repo — the import is currently commented state (verify
  before adding it back or deleting the line).
- `flake.nix` sets `users.nix_dev = ./home/macbook.nix`, but the file is
  actually `home/laptop.nix`. Resolve this inconsistency if touching darwin.
- `hosts/macbook/darwin-configuration.nix` and `home/laptop.nix` are empty
  placeholders — darwin builds will fail or produce empty configs until filled.
- `hosts/mbp2015-linux/configuration.nix` keeps its `hardware-configuration.nix`
  import commented — that file is generated on the machine at install time and
  isn't committed yet. `home/mbp2015-linux.nix` also skips the missing
  `modules/cli_tools.nix` (same situation as the desktop).
- Inputs `nixpkgs_mac` and `sops-nix` are declared but unused; `sops-nix` is
  reserved for future secrets management. **Never commit secrets** — prefer
  sops if secrets are added.
- `nixpkgs.config.packageOverrides` (btop/rocm) is a legacy mechanism; avoid
  extending it unless asked.

## Rules for agents

1. Run the matching `nix eval` (see "Always validate with eval") after every
   change, and run `nix flake check` when practical — report both results.
2. Prefer editing an existing module over adding a new import; if you add a
   module, add the import to the relevant `home/*.nix` in the same change.
3. Do not silently change user names, stateVersion, or the unfree policy —
   these are user decisions.
4. If a change touches partitioning (`disk-config.nix`) or bootloader config,
   flag it: mistakes brick installs, not just builds.
5. Never modify `flake.lock` directly and never add secrets to the repo.