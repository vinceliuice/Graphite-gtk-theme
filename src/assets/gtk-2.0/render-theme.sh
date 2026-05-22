#! /usr/bin/env bash

for theme in '' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-teal' '-blue'; do
for color in '' '-Dark'; do
for type in '' '-nord' '-ferra'; do
  if [[ "$theme" == '' ]]; then
    base_svg="assets.svg"
  else
    base_svg="assets${theme}.svg"
  fi

  if [[ ! -f "$base_svg" ]]; then
    continue
  fi

  if [[ "$color" == '' ]]; then
    case "$theme" in
      -purple)
        theme_color='#AB47BC'
        ;;
      -pink)
        theme_color='#EC407A'
        ;;
      -red)
        theme_color='#E53935'
        ;;
      -orange)
        theme_color='#F57C00'
        ;;
      -yellow)
        theme_color='#FBC02D'
        ;;
      -green)
        theme_color='#4CAF50'
        ;;
      -teal)
        theme_color='#009688'
        ;;
      -blue)
        theme_color='#3684dd'
        ;;
      *)
        theme_color='#333333'
        ;;
    esac
  else
    case "$theme" in
      -purple)
        theme_color='#BA68C8'
        ;;
      -pink)
        theme_color='#F06292'
        ;;
      -red)
        theme_color='#F44336'
        ;;
      -orange)
        theme_color='#FB8C00'
        ;;
      -yellow)
        theme_color='#FFD600'
        ;;
      -green)
        theme_color='#66BB6A'
        ;;
      -teal)
        theme_color='#4DB6AC'
        ;;
      -blue)
        theme_color='#5294e2'
        ;;
      *)
        theme_color='#E0E0E0'
        ;;
    esac
  fi

  if [[ "$type" == '-nord' ]]; then
    case "$theme" in
      -purple)
        theme_color='#b57daa'
        ;;
      -pink)
        theme_color='#cd7092'
        ;;
      -red)
        theme_color='#c35b65'
        ;;
      -orange)
        theme_color='#d0846c'
        ;;
      -yellow)
        theme_color='#e4b558'
        ;;
      -green)
        theme_color='#82ac5d'
        ;;
      -teal)
        theme_color='#83b9b8'
        ;;
      -blue)
        theme_color='#5e81ac'
        ;;
      *)
        if [[ "$color" == '' ]]; then
          theme_color='#434c5e'
        else
          theme_color='#dbdee5'
        fi
        ;;
    esac
  fi

  if [[ "$type" == '-ferra' ]]; then
    case "$theme" in
      -purple)
        theme_color='#c9b8c4'
        ;;
      -pink)
        theme_color='#f6b6c9'
        ;;
      -red)
        theme_color='#e06b75'
        ;;
      -orange)
        theme_color='#ffa07a'
        ;;
      -yellow)
        theme_color='#f5d76e'
        ;;
      -green)
        theme_color='#b1b695'
        ;;
      -teal)
        theme_color='#bfbfcf'
        ;;
      -blue)
        theme_color='#d1d1e0'
        ;;
      *)
        if [[ "$color" == '' ]]; then
          theme_color='#6f5d63'
        else
          theme_color='#d1d1e0'
        fi
        ;;
    esac
  fi

  if [[ -z "$type" && -z "$color" ]]; then
    continue
  fi

  out_svg="assets${theme}${color}${type}.svg"
  if [[ "$out_svg" == "$base_svg" ]]; then
    continue
  fi

  cp -rf "$base_svg" "$out_svg"

  if [[ "$color" == '' ]]; then
    sed -i "s/#333333/${theme_color}/g" "$out_svg"
  else
    sed -i "s/#E0E0E0/${theme_color}/g; s/#e0e0e0/${theme_color}/g" "$out_svg"
  fi

done
done
done

echo -e "DONE!"
