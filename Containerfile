# Allow build scripts to be referenced without being copied into the final image
ARG BASE_IMAGE_NAME="kinoite"
ARG BASE_IMAGE_TAG="main"
ARG FEDORA_MAJOR_VERSION="42"
ARG SOURCE_IMAGE="${BASE_IMAGE_NAME}-${BASE_IMAGE_TAG}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"

FROM scratch AS ctx
COPY / /

## aurora image section
# FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS base
FROM quay.io/fedora-ostree-desktops/kinoite:rawhide AS base

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

ARG BASE_IMAGE_TAG
ARG FEDORA_MAJOR_VERSION

ENV BASE_IMAGE_TAG=${BASE_IMAGE_TAG}
ENV FEDORA_MAJOR_VERSION=${FEDORA_MAJOR_VERSION}

RUN echo "FEDORA_MAJOR_VERSION: ${FEDORA_MAJOR_VERSION}"
RUN echo "BASE_IMAGE_TAG: ${BASE_IMAGE_TAG}"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build.sh 
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
