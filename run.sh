#!/usr/bin/env bash

# sudo dnf install inotify-tools
# https://github.com/asciidoctor/asciidoctor-reveal.js/issues/248#issuecomment-629611778
# https://github.com/asciidoctor/asciidoctor-reveal.js/issues/248#issuecomment-579277817
while inotifywait -e close_write index.adoc slides js images diagrams css index-docinfo-footer.html; do
  echo -n "Detected changes, rebuild presentation... "
  docker container run --rm -v "$(pwd)":/documents -w /documents asciidoctor/docker-asciidoctor:1.67 asciidoctor-revealjs -r asciidoctor-diagram index.adoc
  echo "Done !"
done
