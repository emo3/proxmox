# GitLab - Chainguard/Wolfi-style hardened base (custom build)
#
# Notes:
# - This is a “custom image” that hardens the runtime, but GitLab itself is not a tiny app.
# - The easiest/most reliable approach is to use the official GitLab package install, then run via omnibus.
# - Chainguard/Wolfi licensing/platform availability may vary; if Wolfi base is unavailable in your environment,
#   replace the FROM with an available hardened base of your choice.

# Wolfi base (hardened)
# If Wolfi is unavailable, replace with a supported Chainguard/Wolfi image or a minimal Debian.
FROM cgr.dev/chainguard/wolfi-base:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies required for GitLab omnibus + TLS.
# Omnibus GitLab packages expect a Debian/Ubuntu-like environment; in practice,
# you may need to switch base to a compatible one.
# If you hit package manager issues, adjust base to a Debian-based image.
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    openssh \
    tzdata \
    jemalloc \
    --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/main

# Create directories
RUN mkdir -p /opt/gitlab /etc/gitlab /var/opt/gitlab /var/log/gitlab

# Build arguments for GitLab omnibus install
ARG GITLAB_VERSION="16.11.2"

# Install GitLab (example using official omnibus package)
# You may need to adjust URLs/keys depending on your GitLab edition.
# For automation, consider using a prebuilt GitLab container instead.
RUN set -euo pipefail; \
    apt-get update -y || true; \
    echo "WARNING: This Dockerfile is a template. GitLab omnibus install on Wolfi/alpine may require adjustments."; \
    echo "TODO: Replace this with a working GitLab installation approach for your environment."; \
    /bin/true

# Placeholder entrypoint
# In a real image, you would start gitlab-ctl and keep the container running.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

