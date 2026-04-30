#!/bin/bash
# Conversion + redimensionnement des assets sources en WebP multi-tailles avec noms SEO
set -e

SRC="/Users/jean-sebastiengomez/Raphaëlle GOMEZ Dropbox/CLIENTS RJS/CLIENTS PORTE7/Zen en conscience/assets"
DST="/Users/jean-sebastiengomez/Raphaëlle GOMEZ Dropbox/CLIENTS RJS/CLIENTS PORTE7/Zen en conscience/maquettes/v2/img"

mkdir -p "$DST"

# Tableau associatif : nom source → nom SEO
declare -a MAP=(
  "Ambiance contemplation coucher de soleil.jpg|ambiance-coucher-soleil-meditation"
  "Ambiance meditation vue.jpg|ambiance-meditation-vue"
  "Aroma therapie fleur blanche.jpg|aromatherapie-fleur-blanche"
  "Aromatherapie fleur jaune.jpg|aromatherapie-fleur-jaune"
  "Deco plantes vertes.jpg|deco-plantes-vertes"
  "Deco sommets et nuages blancs.jpg|deco-sommets-nuages"
  "Deco zoom interieur plante verte grasse.jpg|deco-plante-grasse"
  "Reflexologie-2.jpg|reflexologie-pieds-zen"
  "ambiance - meditation .jpg|ambiance-meditation-bougie"
  "ambiance Contemplation meditation.jpg|ambiance-contemplation-meditation"
  "ambiance serviette roulée et bougie.jpg|ambiance-serviette-bougie"
  "amma-assis.jpg|amma-assis-shiatsu-chaise"
  "aromatherapie - pachouli.jpg|aromatherapie-patchouli"
  "aromatherapie preparation flacon.jpg|aromatherapie-preparation-flacon"
  "aromatherapie-2.jpg|aromatherapie-huiles-essentielles"
  "aromatherapie-citron.jpg|aromatherapie-citron"
  "aromatherapie.jpg|aromatherapie-synergie"
  "deco bougie.jpg|deco-bougie-zen"
  "deco fleur de lotus 2.jpg|deco-fleur-lotus-pierre"
  "deco fleur de lotus.jpg|deco-fleur-lotus-eau"
  "deco gros plan herbe rosée du matin.jpg|deco-herbe-rosee-matin"
  "deco reflets dans l'eau.jpg|deco-reflets-eau"
  "deco-ondes sur l eau.jpg|deco-ondes-eau"
  "reflexologie main 2.jpg|reflexologie-main-detail"
  "reflexologie main.jpg|reflexologie-main"
  "reflexologie.jpg|reflexologie-pieds-massage"
  "shiatsu massage visage.jpg|shiatsu-massage-visage"
  "shiatsu-2.jpg|shiatsu-pression-meridiens"
  "shiatsu.jpg|shiatsu-therapeutique"
  "scott-webb-hDyO6rr3kqk-unsplash.jpg|deco-pierres-zen"
)

TOTAL_BEFORE=0
TOTAL_AFTER=0

for entry in "${MAP[@]}"; do
  SRC_NAME="${entry%%|*}"
  DST_NAME="${entry##*|}"
  SRC_PATH="$SRC/$SRC_NAME"

  if [[ ! -f "$SRC_PATH" ]]; then
    echo "SKIP (introuvable): $SRC_NAME"
    continue
  fi

  SIZE_BEFORE=$(stat -f%z "$SRC_PATH")
  TOTAL_BEFORE=$((TOTAL_BEFORE + SIZE_BEFORE))

  echo "→ $SRC_NAME"
  echo "    nom SEO: $DST_NAME"

  # 3 tailles : 400w (mobile thumb), 800w (mobile/tablette), 1600w (desktop)
  for W in 1600 800 400; do
    OUT="$DST/${DST_NAME}-${W}w.webp"
    cwebp -quiet -q 80 -m 6 -resize "$W" 0 "$SRC_PATH" -o "$OUT" 2>/dev/null || {
      echo "    ⚠ erreur cwebp pour ${W}w"
      continue
    }
    SIZE_AFTER=$(stat -f%z "$OUT")
    TOTAL_AFTER=$((TOTAL_AFTER + SIZE_AFTER))
    echo "    ${W}w → $((SIZE_AFTER/1024))Kb"
  done
done

echo ""
echo "=========================================="
echo "AVANT : $((TOTAL_BEFORE/1024/1024)) MB sources"
echo "APRÈS : $((TOTAL_AFTER/1024/1024)) MB (3 tailles webp)"
echo "Gain  : $(( 100 - (TOTAL_AFTER * 100 / TOTAL_BEFORE) ))%"
echo "=========================================="
