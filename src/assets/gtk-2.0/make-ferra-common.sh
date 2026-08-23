#! /usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

cp -f assets-common-Dark.svg assets-common-Dark-ferra.svg
cp -f assets-common.svg assets-common-ferra.svg

sed -i 's/#212121/#2b292d/g; s/#2C2C2C/#383539/g; s/#2c2c2c/#383539/g' assets-common-Dark-ferra.svg
sed -i 's/#f9fafb/#faf6f2/g; s/#292e38/#2b292d/g; s/#313744/#4d424b/g' assets-common-ferra.svg 2>/dev/null || \
  sed -i 's/#FFFFFF/#faf6f2/g; s/#FAFAFA/#f5f0eb/g' assets-common-ferra.svg

echo "GTK2 common Ferra SVG sources ready."
