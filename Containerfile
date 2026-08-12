FROM ubuntu:26.04 AS source

ARG PROTONTRICKS_SHA256=0ba7a6417754d9e11d88a6dd6eada2d28d07b000547ede3a23cd018b24f47fe8

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    curl --fail --location --output /tmp/protontricks.whl \
      https://files.pythonhosted.org/packages/68/af/c251ac31a13bfd685cfb7745d8fd96ec59635d330be5f8ef3550a9faa6aa/protontricks-1.14.1-py3-none-any.whl && \
    echo "${PROTONTRICKS_SHA256}  /tmp/protontricks.whl" | sha256sum --check

FROM ghcr.io/containerpak/gtk:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/protontricks"

COPY --from=source /tmp/protontricks.whl /tmp/protontricks.whl
COPY com.github.Matoking.protontricks.desktop /usr/share/applications/com.github.Matoking.protontricks.desktop

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3-pip python3-pil python3-vdf winetricks yad && \
    pip3 install --break-system-packages --no-deps /tmp/protontricks.whl && \
    rm /tmp/protontricks.whl && \
    cpak-clean-junk
