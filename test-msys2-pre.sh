#!/bin/bash

set -e

sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf

pacman --noconfirm -Rdd catgets || true
pacman --noconfirm -Rdd libcatgets || true
pacman --noconfirm --sync --refresh --refresh --sysupgrade --sysupgrade
