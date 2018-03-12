#!/bin/bash

set -e

brew update
brew install python || brew upgrade python
brew install python@2 || brew upgrade python@2
export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"

brew outdated "pkg-config" || brew upgrade "pkg-config"
brew install libffi glib gobject-introspection cairo autoconf-archive gtk+3

# https://bugzilla.gnome.org/show_bug.cgi?id=780238#c4
export ARCHFLAGS="-arch x86_64"

export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

$PYTHON --version
$PYTHON -m pip install git+https://github.com/pygobject/pycairo.git
$PYTHON -m pip install flake8 pytest pytest-faulthandler

for branch in master;
do
    git clone -b "${branch}" --depth 1 https://gitlab.gnome.org/GNOME/pygobject.git "${branch}"
    cd "${branch}"

    "$PYTHON" setup.py distcheck

    ./autogen.sh --with-python="$PYTHON"
    make -j8
    make check
    cd ..
done
