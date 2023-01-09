#! /usr/bin/env bash

RENDER_SVG="$(command -v rendersvg)" || true
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

for theme in '' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-teal' '-blue'; do
  for type in '' '-nord'; do
    case "$theme" in
      '')
        theme_color_dark='#333333'
        theme_color_light='#e0e0e0'
        ;;
      -purple)
        theme_color_dark='#AB47BC'
        theme_color_light='#BA68C8'
        ;;
      -pink)
        theme_color_dark='#EC407A'
        theme_color_light='#F06292'
        ;;
      -red)
        theme_color_dark='#E53935'
        theme_color_light='#F44336'
        ;;
      -orange)
        theme_color_dark='#F57C00'
        theme_color_light='#FB8C00'
        ;;
      -yellow)
        theme_color_dark='#FBC02D'
        theme_color_light='#FFD600'
        ;;
      -green)
        theme_color_dark='#4CAF50'
        theme_color_light='#66BB6A'
        ;;
      -teal)
        theme_color_dark='#009688'
        theme_color_light='#4DB6AC'
        ;;
      -blue)
        theme_color_dark='#1A73E8'
        theme_color_light='#3281EA'
        ;;
    esac

    if [[ "$type" == '-nord' ]]; then
      case "$theme" in
        '')
          theme_color_dark='#434c5e'
          theme_color_light='#dbdee5'
          ;;
        -purple)
          theme_color_dark='#b57daa'
          theme_color_light='#c89dbf'
          ;;
        -pink)
          theme_color_dark='#cd7092'
          theme_color_light='#dc98b1'
          ;;
        -red)
          theme_color_dark='#c35b65'
          theme_color_light='#d4878f'
          ;;
        -orange)
          theme_color_dark='#d0846c'
          theme_color_light='#dca493'
          ;;
        -yellow)
          theme_color_dark='#e4b558'
          theme_color_light='#eac985'
          ;;
        -green)
          theme_color_dark='#82ac5d'
          theme_color_light='#a0c082'
          ;;
        -teal)
          theme_color_dark='#63a6a5'
          theme_color_light='#83b9b8'
          ;;
        -blue)
          theme_color_dark='#5e81ac'
          theme_color_light='#89a3c2'
          ;;
      esac
    fi

    if [[ "$type" != '' ]]; then
      rm -rf "theme${theme}${type}"
      cp -rf "theme" "theme${theme}${type}"
      sed -i "s/#333333/${theme_color_dark}/g" "theme${theme}${type}"/*.svg
      sed -i "s/#e0e0e0/${theme_color_light}/g" "theme${theme}${type}"/*.svg
      sed -i "s/#2c2c2c/#313744/g" "theme${theme}"/*.svg
    elif [[ "$theme" != '' ]]; then
      rm -rf "theme${theme}"
      cp -rf "theme" "theme${theme}"
      sed -i "s/#333333/${theme_color_dark}/g" "theme${theme}"/*.svg
      sed -i "s/#e0e0e0/${theme_color_light}/g" "theme${theme}"/*.svg
      
    fi
  done
done

for color in '-Light' '-Dark'; do
  for type in '' '-nord'; do
    echo "Rendering 'background pictures ...'"

    if [[ -n "${RENDER_SVG}" ]]; then
      "$RENDER_SVG" --export-id "background${color}${type}" \
                    --dpi 192 \
                    --zoom 2 \
                    background.svg "background${color}${type}.png"
    else
      "$INKSCAPE" --export-id="background${color}${type}" \
                  --export-id-only \
                  --export-dpi=192 \
                  --export-filename="background${color}${type}.png" background.svg >/dev/null
    fi
    if [[ -n "${OPTIPNG}" ]]; then
      "$OPTIPNG" -o7 --quiet "background${color}${type}.png"
    fi
  done
done

echo -e "DONE!"
