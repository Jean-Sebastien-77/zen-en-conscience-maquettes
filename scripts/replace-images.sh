#!/bin/bash
# Remplace les URLs Unsplash par les nouveaux WebP optimisés
# Garde la photo Sophie (1573497019418) intacte
set -e

V2="/Users/jean-sebastiengomez/Raphaëlle GOMEZ Dropbox/CLIENTS RJS/CLIENTS PORTE7/Zen en conscience/maquettes/v2"

# Mapping URL_unsplash_id → nom_seo
declare -a SUBS=(
  "1620916566398-39f1143ab7be|shiatsu-therapeutique"
  "1544161515-4ab6ce6db874|shiatsu-therapeutique"
  "1519824145371-296894a0daa9|reflexologie-pieds-massage"
  "1600334089648-b0d9d3028eb2|aromatherapie-huiles-essentielles"
  "1506126613408-eca07ce68773|ambiance-meditation-vue"
  "1545389336-cf090694435e|deco-fleur-lotus-eau"
  "1518609878373-06d740f60d8b|ambiance-meditation-bougie"
  "1542596594-649edbc13630|ambiance-contemplation-meditation"
  "1559056199-641a0ac8b55e|shiatsu-massage-visage"
  "1600334129128-685c5582fd35|deco-plante-grasse"
  "1545205597-3d9d02c29597|deco-plantes-vertes"
  "1469307670224-ee2e30bbe9b9|ambiance-coucher-soleil-meditation"
  "1528722828814-77b9b83aafb2|deco-fleur-lotus-pierre"
  "1509223197845-458d87318791|deco-plantes-vertes"
  "1466692476868-aef1dfb1e735|deco-herbe-rosee-matin"
  "1518495973542-4542c06a5843|ambiance-coucher-soleil-meditation"
)

for f in "$V2"/*.html; do
  [[ ! -f "$f" ]] && continue
  echo "→ $(basename "$f")"
  for sub in "${SUBS[@]}"; do
    OLD="${sub%%|*}"
    NEW="${sub##*|}"
    # Remplace toute URL Unsplash contenant cet ID par le webp local 1600w
    perl -i -pe "s|https://images\.unsplash\.com/photo-${OLD}[^\"']*|img/${NEW}-1600w.webp|g" "$f"
  done
done
echo "Done."
