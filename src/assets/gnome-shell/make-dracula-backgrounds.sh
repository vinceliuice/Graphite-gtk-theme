#! /usr/bin/env bash
# Adds background-Light-dracula and background-Dark-dracula groups to background.svg (from nord layers).

set -euo pipefail
cd "$(dirname "$0")"

SVG="background.svg"

for variant in Light Dark; do
  src_id="background-${variant}-nord"
  dst_id="background-${variant}-dracula"
  if grep -q "id=\"${dst_id}\"" "$SVG"; then
    echo "'${dst_id}' already present."
    continue
  fi
  python3 - "$SVG" "$src_id" "$dst_id" <<'PY'
import re, sys
path, src_id, dst_id = sys.argv[1:4]
text = open(path, encoding='utf-8').read()
m = re.search(rf'<g[^>]*\sid="{re.escape(src_id)}"[^>]*>', text, flags=re.S)
if not m:
    sys.exit(f'missing group {src_id}')
# walk to the balanced closing </g> (groups nest)
depth, i = 0, m.start()
end = -1
while True:
    nm = re.search(r'<g[\s>]|<\/g>', text[i:])
    if not nm:
        sys.exit(f'unbalanced group {src_id}')
    if nm.group(0).startswith('</'):
        depth -= 1
        if depth == 0:
            end = i + nm.end()
            break
    else:
        depth += 1
    i += nm.end()
src_block = text[m.start():end]
block = src_block.replace(src_id, dst_id, 1)
block = block.replace('#2b303b', '#232532')
block = block.replace('#292e38', '#1e1f29')
block = block.replace('#313744', '#282a36')
block = block.replace('#404859', '#44475a')
block = block.replace('#cce0ff', '#bd93f9')
block = block.replace('#f9fafb', '#f8f8f2')
open(path, 'w', encoding='utf-8').write(text[:m.start()] + src_block + '\n' + block + text[end:])
print(f'added {dst_id}')
PY
done

for variant in Light Dark; do
  src="background-${variant}-nord.png"
  dst="background-${variant}-dracula.png"
  if [[ -f "$src" && ! -f "$dst" ]]; then
    cp -f "$src" "$dst"
    echo "copied $src -> $dst (install inkscape to render dracula backgrounds)"
  fi
done
