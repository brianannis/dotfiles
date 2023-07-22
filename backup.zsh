#!/bin/zsh
# ./backup.zsh any-password

# create encrypted store
printf '%s' $1 | hdiutil create -encryption AES-128 -stdinpass -size 10g -fs APFS -volname transfer $HOME/transfer.dmg

# mount disk
printf '%s' $1 | hdiutil attach -stdinpass $HOME/transfer.dmg

# copy dotfiles
cp -r $HOME/{.aws,.kube,.ssh,.docker/config.json,.vault*,.zprofile,.zshrc,Documents,Desktop,Downloads} /Volumes/transfer

# copy ccMenu config
defaults export -app CCMenu /Volumes/transfer/ccmenu.plist

# unmount
hdiutil detach /Volumes/transfer
