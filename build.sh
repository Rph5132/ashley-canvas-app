#!/bin/bash
#
# Build script for Weekly Reset Planner
# Generates 6 HTML variants: 3 color themes x 2 page sizes
# Output: /dist folder with ready-to-print HTML files
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/index.html"
DIST="$SCRIPT_DIR/dist"

# Clean and create dist folder
rm -rf "$DIST"
mkdir -p "$DIST"

THEMES=("pink" "sage" "beige")
THEME_LABELS=("Pink" "Sage" "Beige")
SIZES=("letter" "a4")
SIZE_LABELS=("Letter" "A4")

for t in "${!THEMES[@]}"; do
  theme="${THEMES[$t]}"
  theme_label="${THEME_LABELS[$t]}"

  for s in "${!SIZES[@]}"; do
    size="${SIZES[$s]}"
    size_label="${SIZE_LABELS[$s]}"

    filename="WeeklyResetPlanner-${theme_label}-${size_label}.html"
    echo "Generating $filename ..."

    cp "$SRC" "$DIST/$filename"

    # Set the data-theme attribute
    sed -i '' "s/data-theme=\"pink\"/data-theme=\"${theme}\"/" "$DIST/$filename"

    # For A4: add .a4 class to every page div
    if [ "$size" = "a4" ]; then
      # Replace class="page" with class="page a4" (handles all variations)
      sed -i '' 's/class="page /class="page a4 /g' "$DIST/$filename"
      # Handle pages that only have class="page" with no additional classes
      sed -i '' 's/class="page"/class="page a4"/g' "$DIST/$filename"
    fi

    echo "  -> $DIST/$filename"
  done
done

echo ""
echo "Build complete! Generated 6 files in $DIST/"
echo ""
echo "To create PDFs:"
echo "  1. Open each HTML file in Chrome"
echo "  2. File > Print > Save as PDF"
echo "  3. Settings: Margins: None, Background graphics: On"
ls -la "$DIST/"
