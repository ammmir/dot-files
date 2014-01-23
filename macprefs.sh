#!/bin/sh

# die .DS_Store die
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# show battery time as percentage only
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

# expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# display full path in Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# show Debug menu in Safari
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# disable Ping in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true
defaults write com.apple.iTunes disablePing -bool true

# more goodies at https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# enable noatime on root file system
cat <<_EOF > /tmp/net.unoc.noatime.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>net.unoc.noatime</string>
        <key>ProgramArguments</key>
        <array>
                <string>mount</string>
                <string>-vuwo</string>
                <string>noatime</string>
                <string>/</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
</dict>
</plist>
_EOF

sudo mv /tmp/net.unoc.noatime.plist /Library/LaunchDaemons/net.unoc.noatime.plist
sudo chown root:wheel /Library/LaunchDaemons/net.unoc.noatime.plist

# enable noatime immediately
sudo mount -vuwo noatime /

# don't create /var/vm/sleepimage on every sleep (revert to classic sleep)
sudo pmset -a hibernatemode 0

# wipe FileVault key prior to suspending (unsure if this is used with above)
sudo pmset -a destroyfvkeyonstandby 1

# lock keychain on sleep (portables only) and set timeout to 2 hours
if [[ `sysctl -b hw.model` == *MacBook* ]]
then
  security set-keychain-settings -lut 7200
else
  security set-keychain-settings -ut 7200
fi

# new Finder windows should open with home directory
defaults write com.apple.Finder NewWindowTargetPath -string "file://${HOME}/"

# don't clutter up the Desktop with screenshots
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots/

# Xcode color scheme
defaults write com.apple.dt.Xcode DVTFontAndColorCurrentTheme "Tomorrow Night.dvtcolortheme"
