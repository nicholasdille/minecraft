#syntax:docker/dockerfile:1.6

FROM ubuntu:22.04 AS base
RUN <<EOF
apt-get update
apt-get -y install --no-install-recommends \
    curl \
    ca-certificates
EOF

FROM base AS multiverse-core
# renovate: datasource=github-releases depName=Multiverse/Multiverse-Core
ARG MULTI_VERSE_CORE_VERSION="4.3.12"
RUN <<EOF
curl --silent --show-error --location --fail --output multiverse-core.jar \
    "https://github.com/Multiverse/Multiverse-Core/releases/download/${MULTI_VERSE_CORE_VERSION}/multiverse-core-${MULTI_VERSE_CORE_VERSION}.jar"
EOF

FROM base AS multiverse-portals
# renovate: datasource=github-releases depName=Multiverse/Multiverse-Portals
ARG MULTIVERSE_PORTALS_VERSION="4.2.3"
RUN <<EOF
curl --silent --show-error --location --fail --output multiverse-portals.jar \
    "https://github.com/Multiverse/Multiverse-Portals/releases/download/${MULTIVERSE_PORTALS_VERSION}/multiverse-portals-${MULTIVERSE_PORTALS_VERSION}.jar"
EOF

FROM base AS multiverse-netherportals
# renovate: datasource=github-releases depName=Multiverse/Multiverse-NetherPortals
ARG MULTIVERSE_NETHERPORTALS_VERSION="4.2.3"
RUN <<EOF
curl --silent --show-error --location --fail --output multiverse-netherportals.jar \
    "https://github.com/Multiverse/Multiverse-NetherPortals/releases/download/${MULTIVERSE_NETHERPORTALS_VERSION}/multiverse-netherportals-${MULTIVERSE_NETHERPORTALS_VERSION}.jar"
EOF

FROM base AS multiverse-inventories
# renovate: datasource=github-releases depName=Multiverse/Multiverse-Inventories
ARG MULTIVERSE_INVENTORIES_VERSION="4.2.6"
RUN <<EOF
curl --silent --show-error --location --fail --output multiverse-inventories.jar \
    "https://github.com/Multiverse/Multiverse-Inventories/releases/download/${MULTIVERSE_INVENTORIES_VERSION}/multiverse-inventories-${MULTIVERSE_INVENTORIES_VERSION}.jar"
EOF

FROM base AS luckperms
# @TODO: Build from source
# renovate: datasource=docker depName=ghcr.io/luckperms/luckperms extractVersion=^v(?<version>.+)$
ARG LUCKPERMS_VERSION="5.4.116"
RUN <<EOF
curl --silent --show-error --location --fail --output luckperms.jar \
    "https://download.luckperms.net/1529/bukkit/loader/LuckPerms-Bukkit-${LUCKPERMS_VERSION}.jar"
EOF

FROM base AS voidworld
# @TODO: Build from master (no tags)
RUN <<EOF
curl --silent --show-error --location --fail --output voidworld.jar \
    "https://dev.bukkit.org/projects/voidworld/files/780026/download"
EOF

FROM base AS cleanroomgenerator
# @TODO: Build from source
# renovate: datasource=github-tags depName=nvx/CleanroomGenerator extractVersion=^v(?<version>.+)$
ARG CLEANROOMGENERATOR_VERSION="1.2.1"
RUN <<EOF
curl --silent --show-error --location --fail --output cleanroomgenerator.jar \
    "https://dev.bukkit.org/projects/cleanroomgenerator/files/3596715/download"
EOF

FROM base AS worldedit
# @TODO: Build from source
# renovate: datasource=github-tags depName=EngineHub/WorldEdit
ARG WORLDEDIT_VERSION="7.2.17"
RUN <<EOF
curl --silent --show-error --location --fail --output worldedit.jar \
    "https://dev.bukkit.org/projects/worldedit/files/4954406/download"
EOF

FROM gradle:8.5.0-jdk17 AS dynmap
# renovate: datasource=github-tags depName=webbukkit/dynmap versioning=loose
ARG DYNMAP_VERSION="3.7-beta-4"
WORKDIR /tmp/dynmap
RUN git clone -q --config advice.detachedHead=false --depth 1 --branch "v${DYNMAP_VERSION}" https://github.com/webbukkit/dynmap .
COPY dynmap-settings.gradle settings.gradle
RUN <<EOF
./gradlew :forge-1.20.2:build
cp ./target/Dynmap-3.7-beta-4-forge-1.20.2.jar /Dynmap.jar
cp ./target/DynmapCore-3.7-beta-4.jar /DynmapCore.jar
cp ./target/DynmapCoreAPI-3.7-beta-4.jar /DynmapCoreAPI.jar
EOF

FROM ghcr.io/nicholasdille/papermc:latest
USER root
COPY --from=multiverse-core /multiverse-core.jar /opt/minecraft-plugins/
COPY --from=multiverse-portals /multiverse-portals.jar /opt/minecraft-plugins/
COPY --from=multiverse-netherportals /multiverse-netherportals.jar /opt/minecraft-plugins/
COPY --from=multiverse-inventories /multiverse-inventories.jar /opt/minecraft-plugins/
COPY --from=luckperms /luckperms.jar /opt/minecraft-plugins/
COPY --from=dynmap /*.jar /opt/minecraft-plugins/
USER minecraft
