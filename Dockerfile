# ─────────────────────────────────────────────────────────────────────────────
# Minimal image for Cursor CLI
# Base: Alpine Linux (~5 MB) — smallest maintained Linux base image
# ─────────────────────────────────────────────────────────────────────────────
FROM alpine:3.20
 
# Install only what the official install script requires:
#   curl  – to fetch the installer
#   bash  – the installer is a bash script (Alpine ships sh, not bash)
#   ca-certificates – TLS verification for cursor.com
#   libstdc++ / libgcc – Node.js runtime deps bundled inside cursor-agent
RUN apk add --no-cache \
        bash \
        curl \
        ca-certificates \
        libstdc++ \
        libgcc \
    # Run the official Cursor CLI installer
    && curl -fsSL https://cursor.com/install | bash \
    # Symlink to a standard PATH location so `cursor` works everywhere
    && ln -sf /root/.local/bin/cursor /usr/local/bin/cursor \
    # Clean up apk cache (already minimal with --no-cache, but be explicit)
    && rm -rf /var/cache/apk/* /tmp/*
 
# Verify the binary is reachable
RUN cursor --version
 
ENTRYPOINT ["cursor"]
