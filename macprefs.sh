#!/bin/sh

# die .DS_Store die
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores true

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
