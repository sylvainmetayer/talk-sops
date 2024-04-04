#!/usr/bin/env bash


curl -sLo code/demo-magic.sh https://raw.githubusercontent.com/paxtonhare/demo-magic/master/demo-magic.sh
git clone https://github.com/hakimel/reveal.js --depth 1 --branch 5.0.5
git clone https://github.com/denehyg/reveal.js-menu --depth 1 --branch 2.1.0 reveal.js/plugin/menu
cd reveal.js && npm ci && npm run build && cd ../
curl -sLo js/hightlight.min.js https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.7.3/highlight.min.js

#qrencode https://app.voxxr.in/events/devoxxfr2024/rate-talk/21890 -o images/openfeedback.svg -t SVG -l H -m 2
# TODO For DevoxxFR, update with tagged version
#qrencode https://sops.talks.sylvain.dev/ -o images/slides_link.svg -t SVG -l H -m 2
