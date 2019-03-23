#!/bin/bash

set -e

export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

brew update
brew remove --ignore-dependencies gdal numpy postgis
for package in python libffi glib cairo meson ninja; do
    brew install "$package" || brew upgrade "$package";
done

export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

git clone --depth 1 https://gitlab.gnome.org/GNOME/gobject-introspection.git
cd gobject-introspection

meson _build
cd _build
ninja
meson test
