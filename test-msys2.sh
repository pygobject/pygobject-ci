#!/bin/bash

set -e

export MSYS2_FC_CACHE_SKIP=1
export PANGOCAIRO_BACKEND=win32


function pacman_ensure_update {
    pacman -Sy --needed --noconfirm "$@"
    pacman -S --needed --noconfirm \
        $(for i in "$@"; do pactree -u $i; done | sort | uniq)
}

pacman_ensure_update \
    mingw-w64-$MSYS2_ARCH-$PYTHON-cairo \
    mingw-w64-$MSYS2_ARCH-$PYTHON \
    mingw-w64-$MSYS2_ARCH-$PYTHON-pip \
    mingw-w64-$MSYS2_ARCH-gobject-introspection \
    mingw-w64-$MSYS2_ARCH-libffi \
    mingw-w64-$MSYS2_ARCH-glib2 \
    mingw-w64-$MSYS2_ARCH-gtk3 \
    git \
    autoconf-archive

git submodule update --init --recursive
(cd pygobject; git checkout master; git pull)
cd pygobject
./autogen.sh --with-python=$PYTHON
make
make check
