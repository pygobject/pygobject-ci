#!/bin/bash

set -e

virtualenv --python=/usr/bin/$1 /tmp/venv
source /tmp/venv/bin/activate
pip install git+https://github.com/pygobject/pycairo.git
pip install pyflakes pycodestyle
export PKG_CONFIG_PATH=/tmp/venv/share/pkgconfig

for repo in pygobject-master pygobject-3-26;
do
    cd "${repo}"
    ./autogen.sh --with-python=python
    make
    xvfb-run -a make check
    LANG=C xvfb-run -a make check
    make check.quality
    cd ..
done
