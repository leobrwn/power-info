<p align="center">
  <img src="./logo.png" alt="power-info logo" width="500">
</p>

<p align="center">
  A simple, colourful battery health &amp; status checker for Linux, built on <code>upower</code>.
</p>

---

## What is this?

`power-info` is a lightweight Bash CLI tool that reads your laptop battery's health and status via `upower` and prints a clean, colour-coded summary straight to your terminal. No dependencies beyond `upower` and `bash` — nothing to compile, nothing to install through a package manager.

Comments in the code are made by me not AI, i made them i do can look back o the code and read it easily 

## Features

- 🔋 **Battery health tracking** — shows long-term wear (current max capacity vs. original design capacity), colour-coded:
  - 🟢 Green: above 80% — healthy
  - 🟡 Yellow: 60–80% — noticeably degraded
  - 🔴 Red: below 60% — worth keeping an eye on
- ⚡ **Live charge percentage**, colour-coded:
  - 🟢 Green: above 75%
  - 🟡 Yellow: 50–75%
  - 🔴 Red: below 50%
- 🔌 **Power supply status** — is the machine currently plugged in?
- 🏷️ **Vendor info**
- 🧰 **`-i` flag** — prints an extended technical info section:
  - Native device path
  - Battery technology (e.g. lithium-ion)
  - Capacity level (Full / Normal / Low / Critical)
  - Voltage (current and minimum design)
  - Energy figures (current full charge vs. original design capacity, in Wh)
  - Charge rate (W)
  - Charge cycle count
- 🖥️ Run summary banner — timestamp, user, and UID for context

## Requirements

- `bash`
- `upower` (most desktop Linux installs already have this; it's what powers battery info in GNOME, KDE, XFCE, etc.)

## Installation

### NixOS

Quick method, for testing:

```bash
chmod +x power-info.sh
mkdir -p ~/.local/bin
cp power-info.sh ~/.local/bin/power-info
```

Check whether `~/.local/bin` is already on your `$PATH`:

```bash
echo $PATH
```

If it's missing, **don't** rely on manually exporting it in `~/.bashrc` — NixOS manages your shell environment declaratively and can regenerate or override that file on rebuild, so a hand-added `export PATH=...` line isn't guaranteed to persist.

Instead, add this to your NixOS system configuration (e.g. `/etc/nixos/configuration.nix`):

```nix
environment.localBinInPath = true;
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

Open a fresh terminal afterward and `~/.local/bin` will be on your `$PATH` permanently.

> For an even more permanent, fully declarative setup, consider packaging this script as a `writeShellScriptBin` derivation and adding it to `environment.systemPackages` instead of copying it into `~/.local/bin` at all.

### Other distros (Fedora, Ubuntu, Debian, Arch, etc.)

```bash
chmod +x power-info.sh
mkdir -p ~/.local/bin
cp power-info.sh ~/.local/bin/power-info
```

`~/.local/bin` is on `$PATH` by default on most modern distros. If not, add:

```bash
export PATH="$HOME/.local/bin:$PATH"
```
to your `~/.bashrc` (or `~/.zshrc`), then `source` it.

**System-wide install** (available to all users):

```bash
sudo cp power-info.sh /usr/local/bin/power-info
sudo chmod +x /usr/local/bin/power-info
```

### For active development

If you're planning to keep editing the script, a symlink is more convenient than a copy — it keeps the installed command in sync with your working file automatically:

```bash
ln -sf /path/to/power-info.sh ~/.local/bin/power-info
```

## Usage

```bash
power-info          # standard overview: vendor, health, power status, charge %
power-info -i       # adds the extended technical info section
```

## Uninstalling

**If installed via `~/.local/bin`:**

```bash
rm ~/.local/bin/power-info
```

**If installed system-wide:**

```bash
sudo rm /usr/local/bin/power-info
```

**If you added a `$PATH` export** you no longer need (and don't use for anything else), remove the line you added to `~/.bashrc` / `~/.zshrc`, then `source` the file again or open a new terminal. On NixOS, remove `environment.localBinInPath = true;` from your config and rebuild.

## Troubleshooting

- **`upower: command not found`** — install `upower` via your distro's package manager, or add it to your NixOS `environment.systemPackages`.
- **Empty output / device not found** — battery device paths aren't always `BAT0`. Run `upower -e` to list actual device paths on your system.
- **Bad interpreter error on NixOS** — NixOS doesn't populate `/bin/bash`. Make sure the shebang is `#!/usr/bin/env bash`, not `#!/bin/bash`.
- **`command not found` after copying to `~/.local/bin`** — `~/.local/bin` isn't on your `$PATH` yet. See the Installation section above for the NixOS-safe fix.

## Roadmap

Planned features:
- `-csv` flag for logging output to a CSV file
- Scheduled logging via a systemd timer (or cron), for tracking battery health over time
- Power profile switching (performance / balanced / power-saver)
