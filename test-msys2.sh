#!/bin/bash

set -e

export MSYS2_FC_CACHE_SKIP=1
export PANGOCAIRO_BACKEND=win32

pacman --noconfirm -Suy

pacman --noconfirm -S --needed \
    mingw-w64-$MSYS2_ARCH-$PYTHON-cairo \
    mingw-w64-$MSYS2_ARCH-$PYTHON \
    mingw-w64-$MSYS2_ARCH-$PYTHON-pip \
    mingw-w64-$MSYS2_ARCH-$PYTHON-pytest \
    mingw-w64-$MSYS2_ARCH-gobject-introspection \
    mingw-w64-$MSYS2_ARCH-libffi \
    mingw-w64-$MSYS2_ARCH-glib2 \
    mingw-w64-$MSYS2_ARCH-gtk3 \
    git \
    autoconf-archive

for branch in master;
do
    git clone -b "${branch}" --depth 1 https://gitlab.gnome.org/GNOME/pygobject.git "${branch}"
    cd "${branch}"

    "$PYTHON" setup.py distcheck

    ./autogen.sh --with-python="$PYTHON"
    make -j8
    make check
    if [[ "$PYTHON" == "python3" ]]; then
        PYTHONLEGACYWINDOWSFSENCODING=1 make check
    fi;
    cd ..
done
