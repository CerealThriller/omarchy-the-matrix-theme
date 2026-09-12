# TheMatrix Theme for Omarchy

Phosphor-green digital rain on void black — a terminal-hacker take on
[the 1999 film](https://en.wikipedia.org/wiki/The_Matrix) for
[Omarchy](https://omarchy.org).

![Theme Preview](preview.png)

## Installation

```bash
omarchy theme install https://github.com/CerealThriller/omarchy-the-matrix-theme
```

Or from the Omarchy menu (`Super + Space`): _Install > Style > Theme_, then
paste the repository URL.

Once installed, pick "TheMatrix" under _Style > Theme_.

## What's Included

- **Palette** (`colors.toml`) — terminals, Hyprland, the Omarchy shell, btop,
  Neovim, VS Code, and the rest are generated from it.
- **Backgrounds**:
  1. **Digital rain** — the classic falling-code look
  2. **Cityscape** — a green-on-black skyline
  3. **Hallway** — three figures standing in a lit doorway at the end of a
     corridor, built entirely out of code density/brightness rather than a
     photo (no reference pixels are reused, only its composition/luminance)
- **Lock screen** (`unlock.png`)
- **Icons** (`icons.theme`)

## Fan / Motherboard RGB (OpenRGB)

If you have OpenRGB-compatible hardware (ARGB motherboard headers, Corsair
Lighting Node Pro, etc.), you can sync it to this theme's accent color with a
small hook. Save this as `~/.config/omarchy/hooks/theme-set.d/openrgb-accent`
and make it executable:

```bash
#!/bin/bash
RGB_FILE="$HOME/.local/state/omarchy/current/theme/keyboard.rgb"
if command -v openrgb >/dev/null 2>&1 && [[ -f $RGB_FILE ]]; then
  hex=$(cat "$RGB_FILE")
  hex="${hex#\#}"
  if [[ $hex =~ ^[0-9A-Fa-f]{6}$ ]]; then
    openrgb --noautoconnect --mode static --color "$hex" >/dev/null 2>&1 &
  fi
fi
```

It reads the theme's `keyboard.rgb` (already `00FF00` here) and pushes it to
every OpenRGB-detected device on every theme change. Note: some ARGB LEDs
render pure green (`00FF00`) with a slight cyan cast — that's the hardware,
not the theme.

## License

MIT
