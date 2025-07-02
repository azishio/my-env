FROM fedora:42

ENV HOME=/opt/distrobox_home

# Import Microsoft GPG key and add VSCode repo
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
COPY vscode.repo /etc/yum.repos.d/vscode.repo

# Enable COPR repositories and install tools (grouped by category)
RUN dnf5 copr enable varlad/zellij -y && \
    dnf5 copr enable atim/bandwhich -y && \
    dnf5 update -y
RUN dnf5 install -y \
      # File and directory operations
      fd-find bat lsd duf \
      # Search and comparison tools
      ripgrep  fzf difftastic delta \
      # Resource and process monitors
      procs \
      # CLI utilities
      tealdeer zoxide httpie tokei bandwhich hyperfine \
      # Editors and development tools
      mold neovim code git \
      # Terminal and shell
      alacritty fish \
      # TUI multiplexer
      zellij \
      # Other build and dev dependencies
      util-linux dnf-plugins-core unzip wayland-devel wayland-protocols-devel podman podman-compose

# Set up fish shell and fisher plugins
RUN fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher' && \
    fish -c ' \
      fisher install \
        oh-my-fish/theme-bobthefish \
        0rax/fish-bd \
        edc/bass \
        oh-my-fish/plugin-expand \
        oh-my-fish/plugin-extract \
        oh-my-fish/plugin-peco \
        spin \
        z \
        fzf'

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN ~/.cargo/bin/cargo install cargo-binstall
RUN ~/.cargo/bin/cargo binstall \
        cargo-run-bin \
        # File and directory operations
        eza du-dust \
        # Terminal and shell \
        starship \
        # CLI utilities
        xplr \
        gping \
        # Resource and process monitors
        bottom

# Install Bun.js
RUN curl -fsSL https://bun.sh/install | bash

# Install Nerd Fonts
RUN mkdir -p /usr/share/fonts/distrobox_nerd && \
    curl -fsSL -o /tmp/nfont.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip && \
    unzip /tmp/nfont.zip -d /usr/share/fonts/nerd && \
    rm /tmp/nfont.zip && \
    fc-cache -fv

# Install JetBrains Toolbox
RUN mkdir -p /opt/jetbrains-toolbox && \
    curl -fsSL "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.0.18144.tar.gz" | tar -xzC /opt/jetbrains-toolbox --strip-components=1

# Install AstroNvim
RUN git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim