#!/bin/bash
set -e
echo "Preflight check:"

if ! command -v git > /dev/null; then
   echo "Installing Xcode Tools"
   xcode-select --install
else
   echo -e "\x1B[01;92m Xcode Tools installed \x1B[0m"
fi

if ! command -v brew > /dev/null; then
   echo "Installing brew"
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
   echo -e "\x1B[01;92m Brew installed \x1B[0m"
fi

if ! [ -x /usr/local/bin/python ]; then
   echo "Installing homebrew python"
   brew install python
else
  echo -e "\x1B[01;92m python installed \x1B[0m"
fi

if ! [ -x /usr/local/bin/python ]; then
   echo "Upgrading pip"
   pip install --upgrade pip
else
  echo -e "\x1B[01;92m pip upgraded \x1B[0m"
fi

if ! [ -x /usr/local/bin/ansible ]; then
   echo "Installing ansible"
   pip install ansible
else
  echo -e "\x1B[01;92m ansible installed \x1B[0m"
fi

echo "Initilize launch playbook"
ansible-playbook launch.yml
