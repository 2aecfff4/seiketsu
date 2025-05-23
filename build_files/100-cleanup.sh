#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

# Disable uupd from updating distroboxes
sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

set -eoux pipefail

# Setup Systemd
systemctl enable rpm-ostree-countme.service
systemctl enable tailscaled.service
systemctl enable dconf-update.service
systemctl enable rpm-ostreed-automatic.timer
systemctl enable usr-share-sddm-themes.mount

#Add the Flathub Flatpak remote and remove the Fedora Flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service

# Disable all COPRs and RPM Fusion Repos and terra
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo

# Disable coprs
dnf5 -y copr disable ublue-os/staging
dnf5 -y copr disable ublue-os/packages
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons

# NOTE: we won't use dnf5 copr plugin for ublue-os/akmods until our upstream provides the COPR standard naming
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
for i in /etc/yum.repos.d/rpmfusion-*; do
    sed -i 's@enabled=1@enabled=0@g' "$i"
done

if [ -f /etc/yum.repos.d/fedora-coreos-pool.repo ]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-coreos-pool.repo
fi

echo "::endgroup::"