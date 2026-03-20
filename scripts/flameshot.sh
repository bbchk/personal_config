#!/bin/sh
export QT_QPA_PLATFORM=wayland
/usr/bin/flameshot gui --raw "$@" | /usr/bin/wl-copy --type image/png
