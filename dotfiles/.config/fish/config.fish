
set -gx theme_color_scheme dracula

# Rust
set -gx RUSTUP_HOME $HOME/.rustup
set -gx CARGO_HOME $HOME/.cargo
fish_add_path $CARGO_HOME/.cargo/bin

# Bun
set -gx BUN_HOME $HOME/.bun
fish_add_path $BUN_HOME/bin

# Starship
if status is-interactive
    starship init fish | source
end

# Zellij
if status is-interactive
    eval (zellij setup --generate-auto-start fish | string collect)
end
