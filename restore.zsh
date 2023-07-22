#!/bin/zsh
# ./restore.zsh any-password

# mount disk
printf '%s' $1 | hdiutil attach -stdinpass $HOME/transfer.dmg

# copy dotfiles
cp -r /Volumes/transfer/{.aws,.kube,.ssh,.docker/config.json,.vault*,.zprofile,.zshrc,Documents,Desktop,Downloads} $HOME/

# write ccMenu config
defaults import net.sourceforge.cruisecontrol.CCMenu ccmenu.plist

# unmount
hdiutil detach /Volumes/transfer
