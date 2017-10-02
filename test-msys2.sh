#!/bin/bash

set -e

export MSYS2_FC_CACHE_SKIP=1
export PANGOCAIRO_BACKEND=win32

pacman --noconfirm -R $(comm -23 <(pacman -Qq | sort) <((for i in $(pacman -Qqg base base-devel mingw-w64-$MSYS2_ARCH-toolchain); do pactree -ul "$i"; done) | sort -u))

pacman --noconfirm -Suy

pacman --noconfirm -S --needed \
    mingw-w64-$MSYS2_ARCH-$PYTHON-cairo \
    mingw-w64-$MSYS2_ARCH-$PYTHON \
    mingw-w64-$MSYS2_ARCH-$PYTHON-pip \
    mingw-w64-$MSYS2_ARCH-gobject-introspection \
    mingw-w64-$MSYS2_ARCH-libffi \
    mingw-w64-$MSYS2_ARCH-glib2 \
    mingw-w64-$MSYS2_ARCH-gtk3 \
    git \
    autoconf-archive \
    base-devel

git submodule update --init --recursive
(cd pygobject; git checkout master; git pull)
cd pygobject
./autogen.sh --with-python=$PYTHON
make
make check
