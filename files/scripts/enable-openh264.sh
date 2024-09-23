#!/usr/bin/env bash
set -euo pipefail
sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-cisco-openh264.repo