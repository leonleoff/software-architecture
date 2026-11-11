#!/bin/sh
# Compiles every LaTeX document in exercise-*/ (each .tex containing
# \documentclass) into <exercise>/build/ and copies the resulting PDFs to
# dist/<exercise>-<name>.pdf. Used by CI; also runs in the dev container:
#   sh build.sh
set -eu
cd "$(dirname "$0")"

rm -rf dist
mkdir -p dist

count=0
for tex in exercise-*/*.tex; do
  [ -f "$tex" ] || continue
  grep -q '\\documentclass' "$tex" || continue
  dir=$(dirname "$tex")
  name=$(basename "$tex" .tex)
  echo "==> $tex"
  latexmk -cd -pdf -interaction=nonstopmode -halt-on-error -file-line-error \
    -outdir=build "$tex"
  cp "$dir/build/$name.pdf" "dist/$dir-$name.pdf"
  count=$((count + 1))
done

echo "Built $count PDF(s) into dist/"
