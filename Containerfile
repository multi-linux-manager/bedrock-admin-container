# Containerfile to build a container everything required to work with bedrock-admin
# Copyright (C) 2025 SUSE LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://gnu.org>.

FROM registry.opensuse.org/opensuse/tumbleweed
MAINTAINER Julio Gonzalez Gil <jgonzalez@suse.com>

# bedrock-toolkit release tag (e.g. v1.2.0), or "latest" for the latest release
ARG BEDROCK_VERSION=latest
LABEL io.suse.bedrock-toolkit.version=$BEDROCK_VERSION

USER root

# pipefail so a failed download fails the build instead of piping nothing to the installer
RUN set -o pipefail && \
    zypper -q ref && zypper -q dup -y && zypper -q install -y gawk curl vim unzip less && \
    curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash -s -- --system && \
    bedrock_tag=${BEDROCK_VERSION#latest} && \
    curl -fsSL https://raw.githubusercontent.com/SUSE/bedrock-toolkit/${bedrock_tag:-main}/install.sh | VERSION=$bedrock_tag sh -s -- bedrock-admin && \
    zypper -q -n remove gawk curl unzip && \
    zypper -q clean

RUN useradd -m -s /bin/bash bedrock

COPY files/bashrc /home/bedrock/.bashrc

VOLUME /home/bedrock/.aws

WORKDIR /home/bedrock/bedrock-configs

USER bedrock

CMD ["/bin/bash"]
