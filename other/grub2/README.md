# Graphite Grub2 theme

![preview](preview.svg?raw=true)

## Installation

RUN:

```sh
sudo ./install.sh
```

### Installation Usage

Usage:  `sudo ./install.sh [OPTIONS...]`

|  Options:              | Description: |
|:-----------------------|:-------------|
| -b, --boot             | Install grub theme into `/boot/grub/themes` |
| -s, --screen           | screen display variant(s) [1080p/2k/4k] (default is 1080p) |
| -r, --remove           | Uninstall theme |
| -h, --help             | Show this help |

## [Issues] Correcting display resolution
 - On the grub screen, press `c` to enter the command line
 - Enter `vbeinfo` or `videoinfo` to check available resolutions
 - Open `/etc/default/grub`, and edit `GRUB_GFXMODE=[height]x[width]x32` to match your resolution
 - Finally, run `grub-mkconfig -o /boot/grub/grub.cfg` to update your grub config

## Documents
[Grub2 theme reference](http://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)
[Grub2 theme tutorial](http://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)

