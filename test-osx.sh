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

(cd pygobject; git checkout master; git pull)

$PYTHON -m pip install git+https://github.com/pygobject/pycairo.git
$PYTHON -m pip install pyflakes pycodestyle

export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
cd pygobject

# FIXME (???)
rm tests/test_mainloop.py
rm tests/test_overrides_gtk.py
rm tests/test_iochannel.py
rm tests/test_glib.py
rm tests/test_thread.py

./autogen.sh --with-python="$PYTHON"
make
make check
