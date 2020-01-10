#!/bin/bash

set -e

export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

brew update
brew remove --ignore-dependencies gdal numpy postgis

if [ "$PYTHON" == "python2" ]; then
    brew unlink python || true;
    brew install "python@2" || brew upgrade "python@2";
    export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"
else
    brew unlink python@2 || true;
    brew install "python" || brew upgrade "python";
    export PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

for package in libffi glib cairo gobject-introspection gtk+3; do
    brew install "$package" || brew upgrade "$package";
done

export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

# https://bugzilla.gnome.org/show_bug.cgi?id=780238#c4
export ARCHFLAGS="-arch x86_64"

$PYTHON --version
$PYTHON -m pip install git+https://github.com/pygobject/pycairo.git
$PYTHON -m pip install flake8 pytest pytest-faulthandler

git clone --depth 1 https://gitlab.gnome.org/GNOME/pygobject.git
cd pygobject

"$PYTHON" setup.py distcheck
