#!/usr/bin/env bash

# ./generate.sh devops/kubernetes-user reveal live

docker container run --rm -v "$(pwd)":/documents -w /documents asciidoctor/docker-asciidoctor:1.67 asciidoctor-revealjs -r asciidoctor-diagram index.adoc