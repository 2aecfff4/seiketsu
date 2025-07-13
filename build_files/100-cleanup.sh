#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Setup Systemd
systemctl enable tailscaled.service
systemctl enable rpm-ostreed-automatic.timer

#Add the Flathub Flatpak remote and remove the Fedora Flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service

systemctl --global disable flatpak-user-update.timer
systemctl disable flatpak-system-update.timer 

# Disable all COPRs and RPM Fusion Repos and terra
# sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
# sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo

# Disable coprs
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons
dnf5 -y copr disable zeno/scrcpy
dnf5 -y copr disable kylegospo/obs-vkcapture
dnf5 -y copr disable che/nerd-fonts


# NOTE: we won't use dnf5 copr plugin for ublue-os/akmods until our upstream provides the COPR standard naming
if [ -f /etc/yum.repos.d/_copr_ublue-os-akmods.repo ]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
fi 

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
for i in /etc/yum.repos.d/rpmfusion-*; do
    sed -i 's@enabled=1@enabled=0@g' "$i"
done

if [ -f /etc/yum.repos.d/fedora-coreos-pool.repo ]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-coreos-pool.repo
fi


# https://bugzilla.redhat.com/show_bug.cgi?id=2185410
modules=$(ls -lha /usr/lib/modules)
echo "modules: $modules"

echo "::endgroup::"
