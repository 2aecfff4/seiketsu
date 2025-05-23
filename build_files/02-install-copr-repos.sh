#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail



# Enable repo for scx-scheds
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons

# Enable scrcpy repo
dnf5 -y copr enable zeno/scrcpy

# Enable obs-vkcapture repo
dnf5 -y copr enable kylegospo/obs-vkcapture

# Enable nerd-fonts repo
dnf5 -y copr enable che/nerd-fonts



echo "::endgroup::"
