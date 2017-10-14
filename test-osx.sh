#!/bin/bash

set -e

brew update
if [ "$PYTHON" == "python2" ]; then
    brew install python || brew upgrade python
else
    brew install python3 || brew upgrade python3
fi
brew outdated "pkg-config" || brew upgrade "pkg-config"
brew install libffi glib gobject-introspection cairo autoconf-archive gtk+3

export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

git clone https://git.gnome.org/browse/pygobject pygobject-master
git clone -b pygobject-3-26 https://git.gnome.org/browse/pygobject pygobject-3-26

$PYTHON -m pip install git+https://github.com/pygobject/pycairo.git
$PYTHON -m pip install pyflakes pycodestyle

for repo in pygobject-master pygobject-3-26;
do
    cd "${repo}"
    # FIXME (???)
    rm tests/test_mainloop.py
    rm tests/test_overrides_gtk.py
    rm tests/test_iochannel.py
    rm tests/test_glib.py
    rm tests/test_thread.py

    ./autogen.sh --with-python="$PYTHON"
    make
    make check
    cd ..
done
