# ============================================
# Stage 1: Builder - Install all tooling
# ============================================
FROM debian:12-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user for development
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG WITH_PNPM_STORE=false
ARG WITH_PLAYWRIGHT_BROWSERS=false

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

# Switch to non-root user for Volta installation
USER $USERNAME
WORKDIR /home/$USERNAME

# Set up Volta environment
ENV VOLTA_HOME=/home/$USERNAME/.volta
ENV PNPM_HOME=/home/$USERNAME/.local/share/pnpm
ENV PATH=$VOLTA_HOME/bin:$PNPM_HOME:$PATH

# Install Volta as the vscode user
RUN curl https://get.volta.sh | bash

# Add Volta to bash profile
RUN echo 'export VOLTA_HOME="/home/vscode/.volta"' >> /home/$USERNAME/.bashrc \
    && echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> /home/$USERNAME/.bashrc

# Install Node.js using Volta
RUN volta install node@22

# Install global tools
RUN volta install pnpm \
        typescript \
        elsint \
        obsidian \
        obsidian-dev-utils

# Ensure pnpm store and Playwright cache directories exist
RUN mkdir -p /home/$USERNAME/.local/share/pnpm \
    /home/$USERNAME/.cache/ms-playwright

# Pre-populate pnpm cache with Storybook ecosystem
RUN mkdir -p /home/$USERNAME/storybook-cache
WORKDIR /home/$USERNAME/storybook-cache

RUN if [ "$WITH_PNPM_STORE" = "true" ]; then \
        pnpm init && \
        pnpm install \
        storybook@latest \
        @storybook/preact@latest \
        @storybook/preact-vite@latest \
        @storybook/addon-a11y@latest \
        @storybook/addon-vitest@latest \
        vitest@latest \
        @vitest/browser@latest \
        @vitest/browser-playwright@latest \
        @vitest/coverage-v8@latest \
        playwright@latest \
        preact@latest \
        vite@latest; \
    fi

RUN if [ "$WITH_PLAYWRIGHT_BROWSERS" = "true" ]; then \
        pnpm dlx playwright install chromium; \
    fi


# ============================================
# Stage 2: Runtime - Minimal final image
# ============================================
FROM debian:12-slim AS runtime

# Install Playwright system dependencies (required for Chromium to run)
# These must be installed before we remove apt
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    git \
    libstdc++6 \
    # Playwright Chromium dependencies
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libglib2.0-0 \
    libxkbcommon0 \
    libatspi2.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxext6 \
    libxshmfence1 \
    fonts-liberation \
    libappindicator3-1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /var/cache/apt/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /usr/share/locale/* \
    && rm -rf /tmp/* /var/tmp/* \
    # Remove apt binaries and configs
    && rm -f /usr/bin/apt* \
    && rm -f /usr/bin/dpkg* \
    && rm -rf /etc/apt \
    && rm -rf /var/lib/{apt,cache,log}

# Set up the same non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    # Disable root account
    && passwd -l root \
    && usermod -s /usr/sbin/nologin root

# Copy Volta, pnpm cache, and Playwright browsers from builder stage
COPY --from=builder --chown=$USERNAME:$USERNAME /home/$USERNAME/.volta /home/$USERNAME/.volta
COPY --from=builder --chown=$USERNAME:$USERNAME /home/$USERNAME/.bashrc /home/$USERNAME/.bashrc
COPY --from=builder --chown=$USERNAME:$USERNAME /home/$USERNAME/.local/share/pnpm /home/$USERNAME/.local/share/pnpm
COPY --from=builder --chown=$USERNAME:$USERNAME /home/$USERNAME/.cache/ms-playwright /home/$USERNAME/.cache/ms-playwright

# Set up environment for the vscode user
ENV VOLTA_HOME=/home/$USERNAME/.volta
ENV PNPM_HOME=/home/$USERNAME/.local/share/pnpm
ENV PATH=$VOLTA_HOME/bin:$PNPM_HOME:$PATH

# Switch to non-root user
USER $USERNAME

# Set the working directory for the project
WORKDIR /workspace

# Keep container running
CMD ["/bin/bash"]