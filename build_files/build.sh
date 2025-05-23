#!/usr/bin/bash

set -eoux pipefail

echo "::group:: ===Install dnf5==="
if [ "${FEDORA_MAJOR_VERSION}" -lt 41 ]; then
    rpm-ostree install --idempotent dnf5 dnf5-plugins
fi

# Copy Files to Container
cp /ctx/packages.json /tmp/packages.json

echo "::endgroup::"

# Get COPR Repos
/ctx/build_files/02-install-copr-repos.sh

# Install Additional Packages
/ctx/build_files/04-packages.sh

# Install Overrides and Fetch Install
/ctx/build_files/05-override-install.sh

# Get firmware
/ctx/build_files/08-firmware.sh

# Make HWE changes
/ctx/build_files/09-hwe-additions.sh

## late stage changes

# Systemd and Remove Items
/ctx/build_files/100-cleanup.sh


# Clean Up
echo "::group:: Cleanup"
/ctx/build_files/200-clean-stage.sh
mkdir -p /var/tmp &&
    chmod -R 1777 /var/tmp
ostree container commit
echo "::endgroup::"

###################################


# #!/bin/bash

# set -ouex pipefail

# ### Install packages

# # Packages can be installed from any enabled yum repo on the image.
# # RPMfusion repos are available by default in ublue main images
# # List of rpmfusion packages can be found here:
# # https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# # this installs a package from fedora repos
# dnf5 install -y tmux 

# # Use a COPR Example:
# #
# # dnf5 -y copr enable ublue-os/staging
# # dnf5 -y install package
# # Disable COPRs so they don't end up enabled on the final image:
# # dnf5 -y copr disable ublue-os/staging

# #### Example for enabling a System Unit File

# systemctl enable podman.socket
