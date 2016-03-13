#!/bin/bash
set -e

echo "       __      __  _____ __         ";
echo "  ____/ /___  / /_/ __(_) /__  _____";
echo " / __  / __ \/ __/ /_/ / / _ \/ ___/";
echo "/ /_/ / /_/ / /_/ __/ / /  __(__  ) ";
echo "\__,_/\____/\__/_/ /_/_/\___/____/  ";
echo "                                    ";

echo "Preflight check:"
echo ""
if ! [ -x /usr/bin/git ]; then
   echo -e "\033[0;33m Installing xcode tools \033[0m"
   xcode-select --install
else
   echo -e "\033[0;32m xcode tools installed \033[0m"
fi

if ! [ -x /usr/local/bin/brew ]; then
   echo -e "\033[0;33m Installing brew \033[0m"
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
   echo -e "\033[0;32m brew installed \033[0m"
fi

if ! [ -x /usr/local/bin/python ]; then
   echo -e "\033[0;33m Installing homebrew python \033[0m"
   brew install python
else
  echo -e "\033[0;32m python installed \033[0m"
fi

if ! [ -x /usr/local/bin/python ]; then
   echo -e "\033[0;33m Upgrading pip \033[0m"
   pip install --upgrade pip
else
  echo -e "\033[0;32m pip upgraded \033[0m"
fi

if ! [ -x /usr/local/bin/ansible ]; then
   echo -e "\033[0;33m Installing ansible \033[0m"
   pip install ansible
else
  echo -e "\033[0;32m ansible installed \033[0m"
fi

# As an alternative to cask + symlinking
# Can drop in your own macapps.link script
echo ""
echo -e "Initilize apps:\n"
./apps.sh

echo ""
echo -e "Initilize playbook:\n"
ansible-playbook launch.yml
