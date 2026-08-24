#! /usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

cp -f assets-common-Dark.svg assets-common-Dark-dracula.svg
cp -f assets-common.svg assets-common-dracula.svg

sed -i 's/#212121/#1e1f29/g; s/#2C2C2C/#282a36/g; s/#2c2c2c/#282a36/g; s/#333333/#44475a/g; s/#474747/#44475a/g; s/#ffffff/#f8f8f2/g; s/#FFFFFF/#f8f8f2/g' assets-common-Dark-dracula.svg
sed -i 's/#000000/#15161b/g; s/#FFFFFF/#f8f8f2/g; s/#ffffff/#f8f8f2/g; s/#FAFAFA/#f0f0eb/g; s/#F2F2F2/#e8e8e0/g; s/#f2f2f2/#e8e8e0/g' assets-common-dracula.svg

echo "GTK2 common Dracula SVG sources ready."
