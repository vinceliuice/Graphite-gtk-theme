#! /usr/bin/env bash
# Seed GTK2 Ferra PNG dirs from Nord (run render-assets.sh after for full regen).

set -euo pipefail
cd "$(dirname "$0")"

for color in '' '-Dark'; do
  src="assets-common${color}-nord"
  dst="assets-common${color}-ferra"
  if [[ -d "$src" && ! -d "$dst" ]]; then
    cp -a "$src" "$dst"
    echo "copied $src -> $dst"
  fi
done

for theme in '' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-teal' '-blue'; do
  for color in '' '-Dark'; do
    src="assets${theme}${color}-nord"
    dst="assets${theme}${color}-ferra"
    if [[ -d "$src" && ! -d "$dst" ]]; then
      cp -a "$src" "$dst"
      echo "copied $src -> $dst"
    fi
  done
done

echo "GTK2 Ferra PNG bootstrap done."
