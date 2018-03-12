#!/bin/bash

set -e

brew update
if [ "$PYTHON" == "python2" ]; then
    brew install python@2 || brew upgrade python@2 || true
    export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"
else
    brew install python || brew upgrade python || true
fi
brew outdated "pkg-config" || brew upgrade "pkg-config"
brew install libffi glib gobject-introspection cairo autoconf-archive gtk+3

export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

$PYTHON --version
$PYTHON -m pip install git+https://github.com/pygobject/pycairo.git
$PYTHON -m pip install flake8 pytest pytest-faulthandler

for branch in master;
do
    git clone -b "${branch}" --depth 1 https://gitlab.gnome.org/GNOME/pygobject.git"${branch}"
    cd "${branch}"

    "$PYTHON" setup.py distcheck

    ./autogen.sh --with-python="$PYTHON"
    make -j8
    make check
    cd ..
done
