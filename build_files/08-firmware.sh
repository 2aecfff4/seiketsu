#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail


rpm-ostree kargs --append=hibernate.compressor=lz4


echo "::endgroup::"
