#!/bin/bash

set -e

pwd
ls -l
cd pygobject
pwd
ls -l
#~ virtualenv --python=/usr/bin/$1 /tmp/venv
#~ source /tmp/venv/bin/activate
#~ pip install git+https://github.com/pygobject/pycairo.git
#~ pip install pyflakes pycodestyle
#~ export PKG_CONFIG_PATH=/tmp/venv/lib/pkgconfig
#~ cd pygobject
#~ ./autogen.sh --with-python=python
#~ make
#~ xvfb-run -a make check
#~ make check.quality
