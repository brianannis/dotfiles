#!/bin/zsh
set -e

echo "       __      __  _____ __         ";
echo "  ____/ /___  / /_/ __(_) /__  _____";
echo " / __  / __ \/ __/ /_/ / / _ \/ ___/";
echo "/ /_/ / /_/ / /_/ __/ / /  __(__  ) ";
echo "\__,_/\____/\__/_/ /_/_/\___/____/  ";
echo "                                    ";

echo "Preflight check:"
echo ""

if ! [ -x /opt/homebrew/bin/brew ] && [[ $(uname -m) == 'arm64' ]]; then
   echo -e "\033[0;33m Installing brew (arm64) \033[0m"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
elif ! [ -x /usr/local/bin/brew ] && [[ $(uname -m) == 'x86_64' ]]; then
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
else
   echo -e "\033[0;32m brew installed \033[0m"
fi

if ! [ -x /opt/homebrew/bin/python3 ]; then
   echo -e "\033[0;33m Installing homebrew python \033[0m"
   brew install python@3.11
else
  echo -e "\033[0;32m python installed \033[0m"
fi

if ! [ -x /opt/homebrew/bin/python3 ]; then
   echo -e "\033[0;33m Upgrading pip \033[0m"
   /opt/homebrew/bin/pip3 install --upgrade pip
else
  echo -e "\033[0;32m pip upgraded \033[0m"
fi

if ! [ -x /usr/local/bin/ansible ]; then
   echo -e "\033[0;33m Installing ansible \033[0m"
   pip3 install ansible==8.2.0
else
  echo -e "\033[0;32m ansible installed \033[0m"
fi

echo ""
echo -e "Initialize playbook:\n"
ansible-playbook launch.yml
