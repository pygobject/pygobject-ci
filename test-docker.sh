#!/bin/bash

set -e

virtualenv --python=/usr/bin/$1 /tmp/venv
source /tmp/venv/bin/activate
pip install git+https://github.com/pygobject/pycairo.git
pip install pyflakes pycodestyle
export PKG_CONFIG_PATH=/tmp/venv/share/pkgconfig

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

for repo in pygobject-master pygobject-3-26;
do
    cd "${repo}"

    if [[ "${repo}" == "pygobject-master" ]]; then
        python setup.py distcheck
    fi

    ./autogen.sh --with-python=python
    make
    xvfb-run -a make check
    if [[ "${repo}" == "pygobject-master" ]]; then
        LANG=C xvfb-run -a make check
    fi;
    make check.quality
    cd ..
done
