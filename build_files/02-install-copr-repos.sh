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
dnf5 -y copr enable che/nerd-fonts fedora-42-x86_64


if [[ "${BASE_IMAGE_TAG}" =~ main ]]; then
    echo "adding coprs for main image..."
    # dnf5 -y install kernel-*-6.14.3    

    # dnf5 -y update --refresh
    # dnf config-manager addrepo --from-repofile=https://dl.fedoraproject.org/pub/alt/rawhide-kernel-nodebug/fedora-rawhide-kernel-nodebug.repo
    # dnf install -y --enablerepo=rawhide python3 
    # dnf install -y fedora-repos-rawhide
    # dnf upgrade -y
    
    # dnf5 -y copr enable @kernel-vanilla/next
    
    # dnf5 -y update --refresh
    # sudo dnf upgrade 'kernel*'
    # dnf5 -y remove $(dnf rq --installonly --latest-limit=-1)
    # dnf -y remove --oldinstallonly
    
    # dnf5 -y copr enable @kernel-vanilla/next
    # dnf5 -y copr enable danayer/mesa-git

    rpm -qa | grep ^kernel | xargs -r dnf5 -y remove
    dnf5 -y install dnf-plugin-versionlock 
    dnf5 -y versionlock add kernel-6.14.11-300.fc42.x86_64 
    dnf5 -y install kernel-6.14.11-300.fc42.x86_64 \
                    kernel-*-6.14.11-300.fc42.x86_64 \
                    --exclude=*-debug
fi


echo "::endgroup::"
