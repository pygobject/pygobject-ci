#!/bin/bash

set -e

sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf

pacman --noconfirm --sync --refresh --refresh --sysupgrade --sysupgrade
