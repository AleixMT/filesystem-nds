FROM debian:bookworm-slim AS dependencies

LABEL maintainer="AleixMT"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends sudo ca-certificates pkg-config curl wget bzip2 xz-utils make libarchive-tools doxygen gnupg && \
    apt-get install -y --no-install-recommends git git-restore-mtime && \
    apt-get install -y --no-install-recommends rsync && \
    apt-get install -y --no-install-recommends cmake zip unzip ninja-build && \
    apt-get install -y --no-install-recommends python3 python-is-python3 python3-lz4 && \
    apt-get install -y --no-install-recommends locales && \
    apt-get install -y --no-install-recommends patch && \
    apt-get install -y --no-install-recommends dumb-init bash && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo -n "UTC" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get -y purge locales-all && \
    dpkg-reconfigure -f noninteractive locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" > /etc/default/locale && \
    locale-gen en_US.UTF-8 && \
    update-locale

RUN ln -s /proc/mounts /etc/mtab && \
    wget https://apt.devkitpro.org/install-devkitpro-pacman && \
    chmod +x ./install-devkitpro-pacman && \
    ./install-devkitpro-pacman && \
    rm ./install-devkitpro-pacman && \
    dkp-pacman -Syyu --noconfirm && \
    dkp-pacman -S --needed --noconfirm dkp-toolchain-vars dkp-meson-scripts && \
    yes | dkp-pacman -Scc

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

RUN dkp-pacman -Syyu --noconfirm && \
    dkp-pacman -S --needed --noconfirm nds-dev && \
    dkp-pacman -S --needed --noconfirm nds-portlibs && \
    yes | dkp-pacman -Scc

ENV DEVKITARM=${DEVKITPRO}/devkitARM

ENTRYPOINT ["dumb-init", "--"]
CMD ["/bin/bash"]



