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
  **out of scope placeholder, do not touch.** This laptop will become a NixOS
  (t2linux) host, so the darwin scaffolding will be replaced rather than
  repaired. See "Scope" below.
- **home-manager** (release-26.05) user environments for both hosts.

All inputs follow `nixpkgs` (branch `nixos-26.05`). Flakes
experimental features are required by every command below.

## Scope: ignore darwin and this MacBook

**Agent work targets the two NixOS machines only:**

| Target | Home config | Host config |
|---|---|---|
| `nixosConfigurations.desktop-nix` | `home/desktop.nix` | `hosts/desktop/` |
| `nixosConfigurations.mbp2015-linux` | `home/mbp2015-linux.nix` | `hosts/mbp2015-linux/` |

Everything darwin-related is a **throwaway placeholder** and must be left
alone:

- the `darwinConfigurations.macbook-nix` output and the `darwin` flake input
  in `flake.nix`
- `hosts/macbook/darwin-configuration.nix`
- `home/macbook.nix` (currently 0 bytes — this is expected, not a bug to fix)

This machine will eventually run **NixOS (t2linux), not nix-darwin**, so the
existing darwin scaffolding will be rewritten from scratch rather than
repaired. Do not fix, extend, tidy, migrate or debug it.

Two consequences worth stating explicitly:

- **Do not "repair" the darwin target.** Its known defects (empty config
  files, a nix-darwin/nixpkgs release-branch mismatch, a `useGlobalpkgs`
  typo) are all going to be deleted along with it. Leave them.
- **A passing `nix flake check --no-build` says nothing about darwin** — the
  check lists `darwinConfigurations` but never evaluates it. That is not a
  gap to be closed; darwin isn't a supported target.

**Rule of thumb:** if a task appears to require touching `home/macbook.nix`,
`hosts/macbook/`, or the `darwinConfigurations` output, stop and ask. The
answer is almost always "not now — placeholder for the future t2linux host."

## Layout

| Path | Purpose |
|---|---|
| `flake.nix` | Top-level entry: inputs, `nixosConfigurations.desktop-nix`, `darwinConfigurations.macbook-nix` |
| `flake.lock` | Locked inputs — never edit by hand; use `nix flake update` |
| `hosts/desktop/configuration.nix` | NixOS system config: kernel, bootloader, users, packages, COSMIC, unfree policy |
| `hosts/desktop/disk-config.nix` | Disko declarative partitioning (used only at install time) |
| `hosts/desktop/hardware-configuration.nix` | Machine-generated; do not hand-edit except via `nixos-generate-config` |
| `hosts/mbp2015-linux/configuration.nix` | NixOS config for the 2015 MacBook Pro (systemd-boot, wifi firmware, Intel iGPU) |
| `hosts/macbook/darwin-configuration.nix` | Darwin system config — 1 byte; out of scope placeholder (see "Scope") |
| `home/desktop.nix` | Home-manager config for user `nixos_user` (imports `modules/*`) |
| `home/mbp2015-linux.nix` | Home-manager config for user `nixos_user` on the MBP (imports `modules/*`) |
| `home/macbook.nix` | Home-manager config for darwin user — 0 bytes; out of scope placeholder (see "Scope") |
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
  `home/macbook.nix` → user `nix_dev` under
  `darwinConfigurations.macbook-nix`; `modules/*` are imported from
  `home/*.nix` and affect whichever host imports them.
- State this explicitly before editing:
  `Target config: <name>. Validation host: <machine/OS>. Planned verification: <command>.`

## Always validate with flake check

- After every change, run exactly one verification command:

  ```bash
  nix flake check --no-build
  ```

- Do not run other `nix` commands (no `nix build`, no `nixos-rebuild`, no
  ad-hoc `nix eval`). `nix flake check --no-build` evaluates every target's
  module system, so it surfaces option errors, type errors and failed
  assertions.
- Report the raw result. Two known, expected outcomes:
  - `desktop-nix`: must pass clean.
  - `mbp2015-linux`: expected to fail with
    `The 'fileSystems' option does not specify your root file system.`
    because `hardware-configuration.nix` is not committed. Any *other*
    error is a real regression.
- `--no-build` does not compile derivations. A clean check does not prove
  that packages build or that runtime path/symlink targets are correct.
- **`darwinConfigurations` is listed but never evaluated.** The command
  prints `checking flake output 'darwinConfigurations'...` and then stops —
  it does not force the configuration. Verified by replacing
  `hosts/macbook/darwin-configuration.nix` with a bare
  `throw "DARWIN WAS EVALUATED"`: the check still reported
  `all checks passed!` with exit 0, while
  `nix eval .#darwinConfigurations.macbook-nix.system` failed instantly.
  So a green check is **no evidence at all** about darwin — see "Scope".

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

Each entry below is a **pending issue**: something currently wrong or
incomplete in this repo that is deliberately left as-is. Item 1 is out of
scope and needs no action; the rest affect the NixOS hosts.

### 1. Darwin / macbook — out of scope, deliberately not fixed

Not a bug to chase. This laptop becomes a NixOS (t2linux) host, so the whole
darwin target is throwaway and will be replaced wholesale (see "Scope"). Its
defects — an empty `home/macbook.nix`, a 1-byte
`hosts/macbook/darwin-configuration.nix`, a nix-darwin 26.11 vs nixpkgs 26.05
release-branch mismatch, and a `useGlobalpkgs` typo at `flake.nix:87` — are
left exactly as they are. `nix flake check` never evaluates
`darwinConfigurations`, so a green check says nothing about it.

### 2. `mbp2015-linux` cannot be checked or rebuilt yet

`hosts/mbp2015-linux/configuration.nix:10` keeps
`# ./hardware-configuration.nix` commented out, and that file does not exist
in the working tree or in git (unlike the desktop's, which is committed). It
is produced by `nixos-generate-config` on the machine at install time.

This is the sole cause of the one expected failure in the sanctioned check:
`The 'fileSystems' option does not specify your root file system.` That
assertion is correct — with no hardware config, nothing declares a root
filesystem. **Any other error from that target is a real regression**, which
is what makes this a useful baseline.

The MBP is otherwise fully wired: its home-manager config imports the same
modules as the desktop (minus `mangohud`, which is desktop-only) and its host
config imports all four `modules/system/*` modules.

### 3. Unused flake inputs

`flake.nix` declares inputs that no code references, inside or outside that
file:

- `nixpkgs_mac` — a duplicate of `nixpkgs` for the darwin side, unused.
- `sopsnix` — note the input is named `sopsnix` (not `sops-nix`), pointing at
  `github:mic92/sops-nix`; reserved for future secrets, currently unused.
- `nix-index-database` — also declared and unreferenced. This one is easy to
  miss because it is not mentioned anywhere else in this document.

Each still costs evaluation and lockfile weight. Removing them is safe but is
a user decision, so leave them unless asked. If secrets are ever added,
**never commit them in plaintext** — use the sops path (Rule 5).

### 4. `packageOverrides` for rocm is legacy but still functional

`hosts/desktop/configuration.nix:106` uses the deprecated
`nixpkgs.config.packageOverrides` to rebuild btop with `rocmSupport = true`:

```nix
nixpkgs.config.packageOverrides = pkgs: { btop = pkgs.btop.override { rocmSupport = true; }; };
```

It still *works* — nixpkgs' btop 1.4.7 accepts `rocmSupport`
(`rocmSupport ? config.rocmSupport`), the override resolves to
`btop-1.4.7`, and the desktop check is green. The issue is mechanism, not
breakage: `packageOverrides` is a whole-set override superseded by overlays,
and the line's own trailing comment (`#no idea what this is for`) shows it is
no longer understood. Relates to the rocm packages in
`hardware.graphics.extraPackages` directly above it.

**Do not extend it** — if this needs changing, ask first; the right fix is
probably an overlay or dropping it if rocm btop support is unwanted. Also note
`modules/cli_tools.nix` now sets btop's *theme* through home-manager; the
rocm override is a separate, system-level concern and the two do not conflict.

### 5. Housekeeping

- `hosts/desktop/hardware-configuration.nix` and `disk-config.nix` are
  machine-generated/install-time files (Rule 4: **mistakes here brick
  installs**). `disk-config.nix` is used only at install time.
- `flake.nix` mixes release channels: nixpkgs/home-manager on 26.05,
  nix-darwin on 26.11 (out of scope — see "Scope").
- The sanctioned verification is `--no-build`, so a clean check never proves
  packages *compile*, nor that runtime path targets resolve. Two live
  examples: the `~/.config/{nvim,zsh,wezterm}` out-of-store symlinks assume
  the repo is checked out at exactly `/home/nixos_user/dotfiles` (from
  `dotfiles.root`), and `xdg.configFile` targets are not created by the
  check. Both are only proven by an actual `nixos-rebuild switch` on the host.

## Rules for agents

1. Run `nix flake check --no-build` (see "Always validate with flake check")
   after every change and report the raw result.
2. Prefer editing an existing module over adding a new import; if you add a
   module, add the import to the relevant `home/*.nix` in the same change.
3. Do not silently change user names, stateVersion, or the unfree policy —
   these are user decisions.
4. If a change touches partitioning (`disk-config.nix`) or bootloader config,
   flag it: mistakes brick installs, not just builds.
5. Never modify `flake.lock` directly and never add secrets to the repo.
6. Keep work scoped to `desktop-nix` and `mbp2015-linux`. Never modify the
   darwin/macbook placeholders (see "Scope"). Do not remove them either.
