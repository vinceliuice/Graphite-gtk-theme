#! /usr/bin/env bash
# Adds background-Light-ferra and background-Dark-ferra groups to background.svg (from nord layers).

set -euo pipefail
cd "$(dirname "$0")"

SVG="background.svg"

for variant in Light Dark; do
  src_id="background-${variant}-nord"
  dst_id="background-${variant}-ferra"
  if grep -q "id=\"${dst_id}\"" "$SVG"; then
    echo "'${dst_id}' already present."
    continue
  fi
  python3 - "$SVG" "$src_id" "$dst_id" <<'PY'
import re, sys
path, src_id, dst_id = sys.argv[1:4]
text = open(path, encoding='utf-8').read()
pattern = rf'(<g[^>]*\sid="{re.escape(src_id)}"[^>]*>.*?</g>)'
m = re.search(pattern, text, flags=re.S)
if not m:
    sys.exit(f'missing group {src_id}')
block = m.group(1)
block = block.replace(src_id, dst_id, 1)
block = block.replace('#2b303b', '#383539')
block = block.replace('#292e38', '#2b292d')
block = block.replace('#313744', '#4d424b')
block = block.replace('#404859', '#6f5d63')
block = block.replace('#cce0ff', '#fecdb2')
block = block.replace('#f9fafb', '#faf6f2')
open(path, 'w', encoding='utf-8').write(text.replace(m.group(0), m.group(0) + '\n' + block))
print(f'added {dst_id}')
PY
done

for variant in Light Dark; do
  src="background-${variant}-nord.png"
  dst="background-${variant}-ferra.png"
  if [[ -f "$src" && ! -f "$dst" ]]; then
    cp -f "$src" "$dst"
    echo "copied $src -> $dst (install inkscape to render warm backgrounds)"
  fi
done
