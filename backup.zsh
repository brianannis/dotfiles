#!/bin/zsh
# ./backup.zsh any-password

# create encrypted store
echo -e "--- creating encrypted volume"
printf '%s' $1 | hdiutil create -encryption AES-128 -stdinpass -size 10g -fs APFS -volname transfer $HOME/transfer.dmg

# mount disk
echo -e "--- mounting encrypted volume"
printf '%s' $1 | hdiutil attach -stdinpass $HOME/transfer.dmg -quiet

# copy dotfiles
echo -e "--- copying files to encrypted volume"
cp -r $HOME/{.aws,.kube,.ssh,.vault*,.zprofile,.zshrc,Documents,Desktop,Downloads} /Volumes/transfer
mkdir -p /Volumes/transfer/.docker
cp -r $HOME/.docker/config.json /Volumes/transfer/.docker/config.json

# copy ccMenu config
echo -e "--- copy ccMenu config"
defaults export -app CCMenu /Volumes/transfer/ccmenu.plist

# unmount
# hdiutil detach /Volumes/transfer
