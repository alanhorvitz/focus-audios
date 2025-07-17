# Focus Audios for Hyprland

Ambient rain and brown noise audio toggles for focus, with easy Hyprland integration.

## Features
- Toggle rain or brown noise audio with a keybinding (pause/resume, not restart)
- Toggle both volumes between 60% and your previous setting
- All scripts are IPC-based and robust

## Installation

### 1. One-liner (recommended)
```sh
bash <(curl -fsSL https://raw.githubusercontent.com/alanhorvitz/focus-audios/main/setup.sh)
```

### 2. Manual
```sh
git clone https://github.com/alanhorvitz/focus-audios.git
cd focus-audios
bash setup.sh
```

## What it does
- Installs scripts to `~/scripts/` (if not present)
- Installs audios to `~/Music/focusAudios/` (if `~/Music` exists)
- Does not overwrite existing files

## Keybinding Setup (Hyprland)
Add these lines to your `keybindings.conf`:
```ini
bindd = SUPER Control, R, exec, ~/scripts/toggle_rain.sh
bindd = SUPER Control, B, exec, ~/scripts/toggle_brown_noise.sh
bindd = SUPER Control, equal, exec, ~/scripts/toggle_ambient_volume.sh
```

## Requirements
- Hyprland
- mpv
- socat
- jq

Install on Arch:
```sh
sudo pacman -S mpv socat jq
```

## Usage
- **SUPER+CTRL+R**: Toggle rain audio (pause/resume)
- **SUPER+CTRL+B**: Toggle brown noise audio (pause/resume)
- **SUPER+CTRL+=**: Toggle both volumes between 60% and your previous setting

## Credits
- Scripts and packaging by [alanhorvitz](https://github.com/alanhorvitz)

Enjoy your focused workspace! 