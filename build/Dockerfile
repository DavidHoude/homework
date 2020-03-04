FROM debian:stable-slim

ENV LTCD_VER=0.17.1
EXPOSE 9332 9333 19332 19333 19444


# Note: This Dockerfile is for example only and will result in a larger than expected image due to the multiple RUN commands
#       leaving unused artifacts in various layers. These should be consolidated before building for production to reduce size.

# Credit: Much of this was written based on some of the details found @ https://github.com/uphold/docker-litecoin-core/tree/master/0.17
#         though I started from scratch to remove complexity, remove running as root user with gosu, actually verifying the checksum, etc.


# Update and install required utils, clean up for smaller image layer
RUN apt update -y && apt install gnupg2 wget -y && apt clean && rm -rf /var/lib/apt/lists/*


# Download litecoind tarball & signature/checksums
RUN wget https://download.litecoin.org/litecoin-${LTCD_VER}/linux/litecoin-${LTCD_VER}-x86_64-linux-gnu.tar.gz \
 && wget https://download.litecoin.org/litecoin-${LTCD_VER}/linux/litecoin-${LTCD_VER}-linux-signatures.asc


# Verify signature and checksum. This should download the known LTC pubkey, verify the .asc signature belongs to owner, then check for sha256 hash in .asc file.
# Source: https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt

RUN wget -O - 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xFE3348877809386C' | gpg --import \
 && gpg --fingerprint FE3348877809386C \
 && gpg --verify litecoin-${LTCD_VER}-linux-signatures.asc \
 && grep $(sha256sum litecoin-${LTCD_VER}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LTCD_VER}-linux-signatures.asc \
 && echo "Verified download checksum"


# Extract binaries, move to /usr/local/bin, and cleanup the rest.
RUN tar -zxvf litecoin-${LTCD_VER}-x86_64-linux-gnu.tar.gz \
 && cp -a litecoin-${LTCD_VER}/bin/* /usr/local/bin \
 && rm litecoin-${LTCD_VER}-x86_64-linux-gnu.tar.gz \
 && rm litecoin-${LTCD_VER}-linux-signatures.asc \
 && rm -rf litecoin-${LTCD_VER}


# Add user w/ system account, nologin shell
RUN useradd -r litecoin


# Set up data directory and set ownership
RUN mkdir /usr/local/litecoin-data \
 && chown litecoin:litecoin /usr/local/litecoin-data


# Run as litecoin user instead of root user
USER litecoin


# Default entrypoint to the litecoin daemon without any arguments to keep it simple.
# Additional changes such as datadir and config can be overwritten in the YAML and use a configmap.
ENTRYPOINT ["/usr/local/bin/litecoind", "-datadir=/usr/local/litecoin-data"]
