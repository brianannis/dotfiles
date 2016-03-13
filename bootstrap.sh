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
   echo "Installing xcode tools"
   xcode-select --install
else
   echo -e "\033[0;32m xcode tools installed \x1B[0m"
fi

if ! [ -x /usr/local/bin/brew ]; then
   echo "Installing brew"
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
   echo -e "\033[0;32m brew installed \x1B[0m"
fi

if ! [ -x /usr/local/bin/python ]; then
   echo "Installing homebrew python"
   brew install python
else
  echo -e "\033[0;32m python installed \x1B[0m"
fi

if ! [ -x /usr/local/bin/python ]; then
   echo "Upgrading pip"
   pip install --upgrade pip
else
  echo -e "\033[0;32m pip upgraded \x1B[0m"
fi

if ! [ -x /usr/local/bin/ansible ]; then
   echo "Installing ansible"
   pip install ansible
else
  echo -e "\033[0;32m ansible installed \x1B[0m"
fi
echo ""
echo -e "Initilize playbook:\n"
ansible-playbook launch.yml
