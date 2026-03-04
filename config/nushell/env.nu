use std "path add"

# path add /run/current-system/sw/bin
# path add /home/fitsum/.config/bin

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu

$env.STARSHIP_CONFIG = /home/fitsum/.config/starship/starship.toml
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
