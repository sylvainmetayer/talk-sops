#!/usr/bin/env bash

curl -sLo code/demo-magic.sh https://raw.githubusercontent.com/paxtonhare/demo-magic/master/demo-magic.sh
git clone https://github.com/hakimel/reveal.js --depth 1 --branch 5.0.5
git clone https://github.com/denehyg/reveal.js-menu --depth 1 --branch 2.1.0 reveal.js/plugin/menu
cd reveal.js && npm ci && npm run build && cd ../
git clone https://github.com/highlightjs/highlight.js --depth=1 -b 11.9.0
cd highlight.js && npm ci && npm run build-cdn && cp -r build/highlight.min.js build/styles build/languages build/es ../js/highlight
