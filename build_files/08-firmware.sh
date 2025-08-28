#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

sed -i "s/UseFirmwareBackground=true/UseFirmwareBackground=false/g" /usr/share/plymouth/themes/bgrt/bgrt.plymouth

echo "::endgroup::"
