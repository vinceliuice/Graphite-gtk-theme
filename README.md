![Graphite](preview.png?raw=true)

## Requirements

- GTK `>=3.20`
- `gnome-themes-extra` (or `gnome-themes-standard`)
- Murrine engine — The package name depends on the distro.
  - `gtk-engine-murrine` on Arch Linux
  - `gtk-murrine-engine` on Fedora
  - `gtk2-engine-murrine` on openSUSE
  - `gtk2-engines-murrine` on Debian, Ubuntu, etc.
- `sassc` — build dependency

- `Icon theme` [Tela-circle-icon-theme](https://github.com/vinceliuice/Tela-circle-icon-theme)

- `Wallpapers` [Graphite Wallpapers](/wallpaper)

## Installation

### Manual Installation

Run the following commands in the terminal:

```sh
./install.sh
```

> Tip: `./install.sh` allows the following options:

```
-d, --dest DIR          Specify destination directory (Default: $HOME/.themes, with sudo: /usr/share/themes)

-n, --name NAME         Specify theme name (Default: Graphite)

-t, --theme VARIANT...  Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|teal|blue|all] (Default: grey)

-c, --color VARIANT...  Specify color variant(s) [standard|light|dark] (Default: All variants)

-s, --size VARIANT...   Specify size variant [standard|compact] (Default: standard variant)

-g, --gdm               Install GDM theme

-l, --libadwaita        Install link to gtk4 config for theming libadwaita

-u, --uninstall
-r, --remove            Uninstall/Remove themes or link for libadwaita

--tweaks                Specify versions for tweaks [nord|black|darker|rimless|normal]
                        (WORRING: 'nord' and 'darker' can not mix use with 'black'!)
                        1. nord:     Nord colorscheme version
                        2. black:    Blackness colorscheme version
                        3. darker:   Darker (default|nord) color version (black option can not be darker)
                        4. rimless:  Remove the 2px outline about windows and menus
                        5. normal:   Normal sidebar style (Nautilus)
                        6. float:    Float gnome-shell panel style
                        7. colorful: Colorful gnome-shell panel style

--round                 Change theme round corner border-radius [Input the px value you want] (Suggested: 2px < value < 16px)
                          1. 3px
                          2. 4px
                          3. 5px
                          ...
                          13. 15px

-h, --help              Show help
```

> For more information, run: `./install.sh --help`

![Tweaks](tweaks.png?raw=true)

### Flatpak Installation

Automatically install your host GTK+ theme as a Flatpak. Use this:

- [pakitheme](https://github.com/refi64/pakitheme)

## Grub2 theme

- [Install from here](other/grub2)

![grub2](other/grub2/preview.svg?raw=true)
