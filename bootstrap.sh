#!/usr/bin/env bash
set -euo pipefail

### CONFIG ###############################################################

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
BOOTSTRAP_BREWFILE="${BOOTSTRAP_BREWFILE:-/tmp/bootstrap-Brewfile}"
ITERM2_SETTINGS_URL="https://github.com/ammmir/dot-files/raw/refs/heads/master/iterm2/com.googlecode.iterm2.plist"

### HELPERS ##############################################################

ensure_permissions() {
  # trigger Full Disk Access
  ls -al ~/Documents ~/Downloads ~/Library/Photos > /dev/null 2>&1
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_FullDiskAccess"
}

ensure_xcode_cli() {
  if ! xcode-select -p >/dev/null 2>&1; then
    echo ">>> Installing Xcode Command Line Tools..."
    xcode-select --install || true
    echo ">>> If this is the first time, rerun bootstrap.sh after Xcode CLI finishes."
  fi
}

ensure_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo ">>> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Shell env for both Intel (/usr/local) and Apple Silicon (/opt/homebrew)
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    zstyle ':omz:update' mode disabled
  fi
}

apply_brewfile() {
  echo ">>> Ensuring homebrew/bundle is available..."
  brew tap homebrew/bundle >/dev/null 2>&1 || true

  echo ">>> Writing embedded Brewfile to $BOOTSTRAP_BREWFILE..."

  cat > "$BOOTSTRAP_BREWFILE" <<'EOF'
tap "oven-sh/bun"

brew "fzf"
brew "ripgrep"
brew "htop"
brew "tree"
brew "dockutil"
brew "bun"
brew "starship"
brew "zsh-autosuggestions"

cask "iterm2"
cask "cursor"
cask "font-jetbrains-mono-nerd-font"
cask "font-meslo-lg-nerd-font"
EOF

  echo ">>> Applying Brewfile with brew bundle..."
  brew bundle --file="$BOOTSTRAP_BREWFILE"
}

apply_macos_defaults() {
  echo ">>> Applying macOS defaults..."

  # Ensure directories exist
  mkdir -p "$SCREENSHOTS_DIR"
  mkdir -p "$HOME/Downloads"

  # Show the ~/Library folder
  chflags nohidden ~/Library

  ########################################################################
  # Dock
  ########################################################################

  defaults write com.apple.dock autohide -bool false
  defaults write com.apple.dock tilesize -int 48
  defaults write com.apple.dock mru-spaces -bool false
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock "slow-motion-allowed" -bool true
  defaults write com.apple.dock magnification -bool true

  # Disable Quick Note (bottom-right hot corner)
  defaults write com.apple.dock wvous-br-corner -int 1
  defaults write com.apple.dock wvous-br-modifier -int 0

  # Dock persistent apps & folders via dockutil
  if command -v dockutil >/dev/null 2>&1; then
    echo ">>> Configuring Dock items via dockutil..."
    dockutil --remove all --no-restart || true
    dockutil --add "/System/Applications/Launchpad.app" --no-restart
    dockutil --add "/Applications/Safari.app" --no-restart
    dockutil --add "/Applications/iTerm.app" --no-restart

    dockutil --add "$SCREENSHOTS_DIR" --view grid --display stack --sort dateadded --no-restart
    dockutil --add "$HOME/Downloads" --view grid --display stack --sort dateadded --no-restart
  else
    echo ">>> dockutil not found; skipping Dock persistent items."
  fi

  ########################################################################
  # Finder
  ########################################################################

  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write com.apple.finder AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowStatusBar -bool false
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  defaults write com.apple.finder _FXSortFoldersFirst -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool false
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  ########################################################################
  # Global (NSGlobalDomain)
  ########################################################################

  defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
  defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
  defaults write -g AppleShowAllFiles -bool true
  defaults write -g AppleShowAllExtensions -bool true
  defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true
  defaults write -g AppleSpacesSwitchOnActivate -bool false
  defaults write -g NSTextShowsControlCharacters -bool true
  defaults write -g InitialKeyRepeat -int 25
  defaults write -g KeyRepeat -int 2
  defaults write -g AppleMeasurementUnits -string "Centimeters"
  defaults write -g AppleMetricUnits -bool true
  defaults write -g AppleTemperatureUnit -string "Celsius"
  defaults write -g AppleICUForce24HourTime -bool true

  # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  ########################################################################
  # Function key behavior (HIToolbox)
  ########################################################################

  defaults write com.apple.HIToolbox AppleFnUsageType -string "Do Nothing"

  ########################################################################
  # Login window (system-wide, requires sudo)
  ########################################################################

  echo ">>> Some loginwindow settings require sudo..."
  sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

  CURRENT_TEXT="$(defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null || true)"

  if [ -z "$CURRENT_TEXT" ]; then
    sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
"If lost and found, please contact:
🇯🇵 TODO
🇺🇸 TODO"
  fi

  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

  ########################################################################
  # Screenshot / screensaver
  ########################################################################

  defaults write com.apple.screencapture location "$SCREENSHOTS_DIR"
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 10

  ########################################################################
  # Control Center
  ########################################################################

  defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -int 1

  ########################################################################
  # Safari
  ########################################################################

  defaults write com.apple.Safari HomePage -string "about:blank"
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
  defaults write com.apple.Safari WebKitDeveloperExtras -bool true
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
  defaults write com.apple.Safari AutoFillFromAddressBook -bool false
  defaults write com.apple.Safari AutoFillPasswords -bool false
  defaults write com.apple.Safari AutoFillCreditCardData -bool false
  defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

  ########################################################################
  # Desktop services (.DS_Store behavior)
  ########################################################################

  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  ########################################################################
  # Advertising / privacy
  ########################################################################

  defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false

  ########################################################################
  # Image Capture
  ########################################################################

  defaults write com.apple.ImageCapture disableHotPlug -bool true

  ########################################################################
  # Time Machine
  ########################################################################

  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  ########################################################################
  # Spaces / Mission Control
  ########################################################################

  defaults write com.apple.spaces "spans-displays" -int 0

  ########################################################################
  # Siri / assistant data sharing
  ########################################################################

  defaults write com.apple.assistant.support "Search Queries Data Sharing Status" -int 2

  ########################################################################
  # iTerm2 user prefs
  ########################################################################

  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM2_SETTINGS_URL"

  ########################################################################
  # Restart affected services
  ########################################################################

  echo ">>> Restarting Dock, Finder, SystemUIServer..."
  killall Dock Finder SystemUIServer cfprefsd 2>/dev/null || true

  echo ">>> macOS defaults applied."
}

apply_zsh() {
  mkdir -p ~/.config

  grep -qxF 'eval "$(starship init zsh)"' ~/.zshrc || echo 'eval "$(starship init zsh)"' >> ~/.zshrc

  if [ ! -f "$HOME/.config/starship.toml" ]; then
    starship preset catppuccin-powerline -o ~/.config/starship.toml
  fi
}

main() {
  echo ">>> Starting macOS bootstrap..."

  ensure_permissions
  ensure_xcode_cli
  ensure_homebrew
  ensure_zsh

  apply_brewfile
  apply_macos_defaults
  apply_zsh

  echo ">>> Bootstrap complete. Some settings may need a logout/reboot to fully apply."
}

main "$@"
