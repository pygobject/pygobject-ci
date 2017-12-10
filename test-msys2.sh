#!/bin/bash

set -e

export MSYS2_FC_CACHE_SKIP=1
export PANGOCAIRO_BACKEND=win32

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
    autoconf-archive

pacman -Sc --noconfirm

git clone --depth 1 https://git.gnome.org/browse/pygobject pygobject-master
git clone -b pygobject-3-26 --depth 1 https://git.gnome.org/browse/pygobject pygobject-3-26

for repo in pygobject-master pygobject-3-26;
do
    cd "${repo}"

    if [[ "${repo}" == "pygobject-master" ]]; then
        "$PYTHON" setup.py distcheck
    fi

    ./autogen.sh --with-python=$PYTHON
    make
    make check
    if [[ "$PYTHON" == "python3" ]]; then
        PYTHONLEGACYWINDOWSFSENCODING=1 make check
    fi;
    cd ..
done
