# Add CMake only for the exploratory PPSSPP configure probe.
# The upstream OpenOrbis image is intentionally kept unchanged.
FROM openorbisofficial/toolchain:latest
USER root
RUN apt-get update && apt-get install -y --no-install-recommends cmake make binutils && rm -rf /var/lib/apt/lists/*
USER orbis
