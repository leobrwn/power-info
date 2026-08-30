<p align="center">
  <img src="./assets/logo.png" alt="power-info logo" width="500">
</p>

<p align="center">
  A simple, colorful battery health &amp; status checker for Linux, built on <code>upower</code>.
</p>

---

## What is this?

`power-info` is a lightweight Bash CLI tool that reads your laptop battery's health and status via `upower` and prints a clean, color-coded summary straight to your terminal. No dependencies beyond `upower` and `bash` — nothing to compile, nothing to install through a package manager.

## Features

- 🔋 **Battery health tracking** — shows long-term wear (current max capacity vs. original design capacity), color-coded:
  - 🟢 Green: above 80% — healthy
  - 🟡 Yellow: 60–80% — noticeably degraded
  - 🔴 Red: below 60% — worth keeping an eye on
- ⚡ **Live charge percentage**, color-coded:
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
chmod +x bat.sh
mkdir -p ~/.local/bin
cp bat.sh ~/.local/bin/power-info
```

Make sure `~/.local/bin` is on your `$PATH`:

```bash
echo $PATH
```

If it's missing, add this to your shell config (or `home.sessionPath` if you use Home Manager):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload your shell:

```bash
source ~/.bashrc
```

> For a more permanent, declarative setup that fits the NixOS way of doing things, consider packaging this as a `writeShellScriptBin` derivation and adding it to `environment.systemPackages` in your system configuration instead of copying it into `~/.local/bin`.

### Other distros (Fedora, Ubuntu, Debian, Arch, etc.)

```bash
chmod +x bat.sh
mkdir -p ~/.local/bin
cp bat.sh ~/.local/bin/power-info
```

`~/.local/bin` is on `$PATH` by default on most modern distros. If not, add:

```bash
export PATH="$HOME/.local/bin:$PATH"
```
to your `~/.bashrc` (or `~/.zshrc`), then `source` it.

**System-wide install** (available to all users):

```bash
sudo cp bat.sh /usr/local/bin/power-info
sudo chmod +x /usr/local/bin/power-info
```

### For active development

If you're planning to keep editing the script, a symlink is more convenient than a copy — it keeps the installed command in sync with your working file automatically:

```bash
ln -sf /path/to/bat.sh ~/.local/bin/power-info
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

**If you added a `$PATH` export** you no longer need (and don't use for anything else), remove the line you added to `~/.bashrc` / `~/.zshrc`, then `source` the file again or open a new terminal.

## Troubleshooting

- **`upower: command not found`** — install `upower` via your distro's package manager, or add it to your NixOS `environment.systemPackages`.
- **Empty output / device not found** — battery device paths aren't always `BAT0`. Run `upower -e` to list actual device paths on your system.
- **Bad interpreter error on NixOS** — NixOS doesn't populate `/bin/bash`. Make sure the shebang is `#!/usr/bin/env bash`, not `#!/bin/bash`.

## Roadmap

Planned features:
- `-csv` flag for logging output to a CSV file
- Scheduled logging via a systemd timer (or cron), for tracking battery health over time
- Power profile switching (performance / balanced / power-saver)

## License

Add your license of choice here.
