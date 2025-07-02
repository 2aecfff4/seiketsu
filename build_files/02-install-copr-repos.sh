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

if [[ "${BASE_IMAGE_TAG}" =~ main ]]; then
    echo "adding coprs for main image..."
    # dnf5 -y copr enable @kernel-vanilla/next
    
    # dnf5 -y update --refresh
    # sudo dnf upgrade 'kernel*'
    dnf5 -y install kernel-*-6.14.3
    # dnf5 -y remove $(dnf rq --installonly --latest-limit=-1)
    # dnf -y remove --oldinstallonly
    
    # dnf5 -y copr enable @kernel-vanilla/next
    # dnf5 -y copr enable danayer/mesa-git
fi


echo "::endgroup::"
