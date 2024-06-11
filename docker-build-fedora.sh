#!/bin/sh -x

cd "$(readlink -f "$(dirname "$0")")"
docker run -ti -v .:/work:z -w /work fedora:latest ./build-fedora.sh
