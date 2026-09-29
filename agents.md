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
  a non-functional placeholder: it does not evaluate today for four separate
  reasons. See "Known issues" §1 and §2 before touching anything darwin.
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
| `hosts/macbook/darwin-configuration.nix` | Darwin system config — 1 byte, does not evaluate (see §1b) |
| `home/desktop.nix` | Home-manager config for user `nixos_user` (imports `modules/*`) |
| `home/mbp2015-linux.nix` | Home-manager config for user `nixos_user` on the MBP (imports `modules/*`) |
| `home/laptop.nix` | Home-manager config for darwin user — 0 bytes; not even the file `flake.nix` imports (see §1a, §1b) |
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
  So a green check is **no evidence at all** about darwin — see known issue 2.

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
incomplete in this repo that is deliberately left as-is. They are ordered by
how much they block. None of them affect `desktop-nix`, which is the only
target that both evaluates today and is actually provisioned.

### 1. Darwin has four stacked defects (was: "empty placeholders")

All four must be fixed before `darwinConfigurations.macbook-nix` can
evaluate. Symptom order differs from fix order: 1c aborts evaluation first,
and it masks 1a, 1b and 1d, so you will not see the rest until 1c is
resolved.

**1a. `flake.nix` imports a file that does not exist.**
`flake.nix:90` reads `users.nix_dev = ./home/macbook.nix`, but there is no
`home/macbook.nix` in the repo. The home-manager config for the darwin user
was written to `home/laptop.nix` instead. The mismatch is between the flake's
path and the file's name, so any attempt to evaluate the darwin user fails
with a missing-file error before any option is even checked.

**1b. Both darwin files are syntactically invalid, not merely "empty".**
A Nix file must contain at least one expression, so a zero/tiny file is a
*syntax error*, not an empty config:

- `home/laptop.nix` is **0 bytes**.
- `hosts/macbook/darwin-configuration.nix` is **1 byte** (a single newline).

Verified by importing comparable files: both produce
`error: syntax error, unexpected end of file`. Note this corrects the earlier
wording in this document — these fail loudly rather than "producing empty
configs". Both files need at least a `{ ... }: { }` skeleton (the convention
in every other `home/*.nix` and `hosts/*/configuration.nix`).

**1c. The nix-darwin and nixpkgs release branches do not match.**
`flake.lock` pins nix-darwin at `57a3171f9470`, which is a **26.11** branch,
while `nixpkgs` is on **26.05**. nix-darwin now enforces that the two
releases correspond, so evaluation aborts at `eval-config.nix:25`:

```
error: nix-darwin now uses release branches that correspond to Nixpkgs releases.
The nix-darwin and Nixpkgs branches in use must match, but you are currently
using nix-darwin 26.11 with Nixpkgs 26.05.
```

This error fires *before* 1a and 1b are ever reached, so in practice it is
the first thing you will see. The matching branch for NixOS 26.05 is
`nix-darwin-26.05`. **Do not fix this by hand-editing `flake.lock`**
(Rule 5) — it needs a deliberate input/release decision from the user, and
note this repo mixes release channels (`home-manager` is already on
`release-26.05`).

**1d. `useGlobalpkgs` is misspelled and would be a hard error.**
`flake.nix:88` (darwin only) sets `useGlobalpkgs`, but the home-manager option
is `useGlobalPkgs` — lowercase `p`, capital `P`. home-manager does not use a
freeform type here, so the option genuinely does not exist. Confirmed by
injecting the same typo into the desktop config (which *is* evaluated):

```
error: The option `home-manager.useGlobalpkgs' does not exist.
Did you mean `home-manager.useGlobalPkgs', ...?
```

The two NixOS blocks spell it correctly. This bug is currently masked by 1c.

### 2. A green `nix flake check --no-build` says nothing about darwin

This is the most dangerous item here, because it makes the others *look*
fine. `flake check` prints `checking flake output 'darwinConfigurations'...`
and then never forces the config. Verified by replacing
`hosts/macbook/darwin-configuration.nix` with a bare
`throw "DARWIN WAS EVALUATED"`: the check still printed `all checks passed!`
and exited 0, while `nix eval .#darwinConfigurations.macbook-nix.system`
failed immediately. Even a direct `throw` placed as a sibling inside the
`darwinConfigurations` attribute set went unnoticed.

**Consequence for agents:** you cannot verify darwin work with the sanctioned
command. If a task touches darwin, say so explicitly rather than reporting a
green check as success. `desktop-nix` and `mbp2015-linux` *are* genuinely
evaluated by the check (proven: injecting the 1d typo into `desktop-nix`
failed the check).

### 3. `mbp2015-linux` cannot be checked or rebuilt yet

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

### 4. Unused flake inputs (three, not two)

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

### 5. `packageOverrides` for rocm is legacy but still functional

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

### 6. Housekeeping

- `hosts/desktop/hardware-configuration.nix` and `disk-config.nix` are
  machine-generated/install-time files (Rule 4: **mistakes here brick
  installs**). `disk-config.nix` is used only at install time.
- `flake.nix` mixes release channels: nixpkgs/home-manager on 26.05,
  nix-darwin on 26.11. See 1c.
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
