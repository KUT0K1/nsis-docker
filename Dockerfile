ARG BASE_IMAGE_TAG
FROM debian:${BASE_IMAGE_TAG}

ARG NSIS_VER
ARG BASE_IMAGE_TAG
ENV NSIS_VER=${NSIS_VER}
ENV BASE_IMAGE_TAG=${BASE_IMAGE_TAG}

LABEL author="alberto+git@albertowd.dev"
LABEL description="NSIS images to compile installers on Docker/Linux based CI."
LABEL version=${BASE_IMAGE_TAG}-nsis${NSIS_VER}

# Install required libraries to compile NSIS.
RUN apt update && \
    apt upgrade -y && \
    apt install -y bzip2 g++ lib32z1-dev scons wget unzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Downloads the default binaries and extract them to the installation folder.
RUN wget -O /tmp/nsis.zip https://sourceforge.net/projects/nsis/files/NSIS%203/${NSIS_VER}/nsis-${NSIS_VER}.zip && \
    unzip /tmp/nsis.zip -d /usr/local/ && \
    mv /usr/local/nsis-${NSIS_VER}/ /usr/local/nsis/ && \
    rm -rf /tmp/*

# Actually compiles the NSIS compiler for linux.
RUN wget -O /tmp/nsis-src.tar.bz2 https://sourceforge.net/projects/nsis/files/NSIS%203/${NSIS_VER}/nsis-${NSIS_VER}-src.tar.bz2 && \
    tar -C /usr/local/src/ -xf /tmp/nsis-src.tar.bz2 && \
    mv /usr/local/src/nsis-${NSIS_VER}-src /usr/local/src/nsis/ && \
    scons -C /usr/local/src/nsis/ NSIS_CONFIG_CONST_DATA_PATH=no SKIPMISC=all SKIPPLUGINS=all SKIPSTUBS=all SKIPUTILS=all PREFIX=/usr/local/nsis/bin install-compiler && \
    ln -s /usr/local/nsis/bin/makensis /usr/local/bin/makensis && \
    rm -rf /tmp/*

ENTRYPOINT [ "makensis" ]
VOLUME /build/
WORKDIR /build/
