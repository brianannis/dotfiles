#!/bin/zsh
# ./restore.zsh any-password

# mount disk
echo -e "attempting to mount disk"
printf '%s' $1 | hdiutil attach -stdinpass $HOME/transfer.dmg

# copy dotfiles
echo -e "copying files to $HOME"
cp -r /Volumes/transfer/{.aws,.kube,.ssh,.docker/config.json,.vault*,.zprofile,.zshrc,Documents,Desktop,Downloads} $HOME/

# write ccMenu config
echo -e "writing ccMenu config"
defaults import net.sourceforge.cruisecontrol.CCMenu /Volumes/transfer/ccmenu.plist

# unmount
echo -e "detach transfer volume"
hdiutil detach /Volumes/transfer
