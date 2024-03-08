#!/usr/bin/env bash

git clone git@github.com:hakimel/reveal.js --depth 1 --branch 5.0.5
git clone git@github.com:denehyg/reveal.js-menu --depth 1 --branch 2.1.0 reveal.js/plugin/menu
cd reveal.js && npm ci && npm run build && cd ../
curl -sL 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css' -o css/font-awesome.css
curl -sLo js/hightlight.min.js https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.3/highlight.min.js
