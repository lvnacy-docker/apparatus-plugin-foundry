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

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

# Switch to non-root user for Volta installation
USER $USERNAME
WORKDIR /home/$USERNAME

# Set up Volta environment
ENV VOLTA_HOME=/home/$USERNAME/.volta
ENV PATH=$VOLTA_HOME/bin:$PATH

# Install Volta as the vscode user
RUN curl https://get.volta.sh | bash

# Add Volta to bash profile
RUN echo 'export VOLTA_HOME="/home/vscode/.volta"' >> /home/$USERNAME/.bashrc \
    && echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> /home/$USERNAME/.bashrc

# Install Node.js using Volta (latest stable)
RUN volta install node

# Install TypeScript globally (useful for any project)
RUN npm install -g typescript npm@latest

# ============================================
# Stage 2: Runtime - Minimal final image
# ============================================
FROM debian:12-slim AS runtime

# Install only essential runtime dependencies
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /var/cache/apt/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /usr/share/locale/* \
    && rm -rf /tmp/* /var/tmp/* \
    # Remove apt binaries and configs (leave dpkg database intact)
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
    # Disable root account - remove password and shell
    && passwd -l root \
    && usermod -s /usr/sbin/nologin root

# Copy Volta installation from builder stage
COPY --from=builder --chown=$USERNAME:$USERNAME /home/$USERNAME/.volta /home/$USERNAME/.volta
COPY --from=builder --chown=$USERNAME:$USERNAME /home/$USERNAME/.bashrc /home/$USERNAME/.bashrc

# Set up environment for the vscode user
ENV VOLTA_HOME=/home/$USERNAME/.volta
ENV PATH=$VOLTA_HOME/bin:$PATH

# Switch to non-root user
USER $USERNAME

# Set the working directory for the project
WORKDIR /workspace

# Keep container running
CMD ["/bin/bash"]