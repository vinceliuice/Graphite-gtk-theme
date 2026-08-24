#! /usr/bin/env bash
# Generate Dracula-colored GTK3/4 asset PNGs from theme SVGs.

set -euo pipefail
cd "$(dirname "$0")"

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true
INDEX="assets.txt"

dracula_default_accent='#f8f8f2:#44475a'

dracula_colors() {
  local theme="$1"
  case "$theme" in
    -purple) echo '#bd93f9:#9d6cf9' ;;
    -pink)   echo '#ff79c6:#e85aaa' ;;
    -red)    echo '#ff5555:#e83333' ;;
    -orange) echo '#ffb86c:#e8943c' ;;
    -yellow) echo '#f1fa8c:#c5cf60' ;;
    -green)  echo '#50fa7b:#2dd154' ;;
    -teal)   echo '#8be9fd:#5fc8dd' ;;
    -blue)   echo '#6272a4:#3f4d7a' ;;
  esac
}

for theme in '' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-blue' '-teal'; do
  if [[ "$theme" == '' ]]; then
    src="assets.svg"
    dst="assets-dracula.svg"
    IFS=':' read -r dark light <<< "$dracula_default_accent"
  else
    src="assets${theme}.svg"
    dst="assets${theme}-dracula.svg"
    [[ -f "$src" ]] || continue

    IFS=':' read -r dark light <<< "$(dracula_colors "$theme")"
  fi
  cp -f "$src" "$dst"
  sed -i "s/#333333/${dark}/g; s/#E0E0E0/${light}/g; s/#e0e0e0/${light}/g" "$dst"
  sed -i "s/#F57C00/${dark}/g; s/#FB8C00/${light}/g" "$dst"
  sed -i "s/#AB47BC/${dark}/g; s/#BA68C8/${light}/g" "$dst"
  sed -i "s/#EC407A/${dark}/g; s/#F06292/${light}/g" "$dst"
  sed -i "s/#E53935/${dark}/g; s/#F44336/${light}/g" "$dst"
  sed -i "s/#FBC02D/${dark}/g; s/#FFD600/${light}/g" "$dst"
  sed -i "s/#4CAF50/${dark}/g; s/#66BB6A/${light}/g" "$dst"
  sed -i "s/#009688/${dark}/g; s/#4DB6AC/${light}/g" "$dst"
  sed -i "s/#3684dd/${dark}/g; s/#5294e2/${light}/g" "$dst"

  ASSETS_DIR="assets${theme}-dracula"
  rm -rf "$ASSETS_DIR"
  mkdir -p "$ASSETS_DIR"

  for i in $(cat "$INDEX"); do
    for scale in '' '@2'; do
      out="$ASSETS_DIR/${i}${scale}.png"
      echo "Rendering $out"
      if [[ -n "${RENDER_SVG}" ]]; then
        if [[ -n "$scale" ]]; then
          "$RENDER_SVG" --export-id "$i" --dpi 192 --zoom 2 "$dst" "$out"
        else
          "$RENDER_SVG" --export-id "$i" "$dst" "$out"
        fi
      elif [[ -n "${INKSCAPE}" ]]; then
        if [[ -n "$scale" ]]; then
          "$INKSCAPE" --export-id="$i" --export-id-only --export-dpi=192 \
            --export-filename="$out" "$dst" >/dev/null
        else
          "$INKSCAPE" --export-id="$i" --export-id-only \
            --export-filename="$out" "$dst" >/dev/null
        fi
      else
        cp -f "assets${theme}/${i}${scale}.png" "$out" 2>/dev/null || true
      fi
      [[ -n "${OPTIPNG}" && -f "$out" ]] && "$OPTIPNG" -o7 --quiet "$out"
    done
  done
done

echo "GTK Dracula assets done."
