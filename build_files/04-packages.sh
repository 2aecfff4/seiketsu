#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# build list of all packages requested for inclusion
readarray -t INCLUDED_PACKAGES < <(jq -r "[(.all.include | (select(.all != null).all)[]), \
                    (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (select(.all != null).all)[])] \
                    | sort | unique[]" /tmp/packages.json)

# Install Packages
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    dnf5 -y install "${INCLUDED_PACKAGES[@]}"
else
    echo "No packages to install."
fi

# build list of all packages requested for exclusion
readarray -t EXCLUDED_PACKAGES < <(jq -r "[(.all.exclude | (select(.all != null).all)[]), \
                    (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (select(.all != null).all)[])] \
                    | sort | unique[]" /tmp/packages.json)

if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    readarray -t EXCLUDED_PACKAGES < <(rpm -qa --queryformat='%{NAME}\n' "${EXCLUDED_PACKAGES[@]}")
fi

# remove any excluded packages which are still present on image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    dnf5 -y remove "${EXCLUDED_PACKAGES[@]}"
else
    echo "No packages to remove."
fi

if [[ "${BASE_IMAGE_TAG}" =~ main ]]; then
    dnf5 -y install intel-compute-runtime
    dnf5 -y install igt-gpu-tools
    # dnf5 -y install libva-intel-media-driver

    dnf5 -y swap libva-intel-media-driver intel-media-driver --allowerasing
    dnf5 -y install libva-intel-driver
fi

dnf5 -y swap ffmpeg-free ffmpeg --allowerasing


echo "::endgroup::"
