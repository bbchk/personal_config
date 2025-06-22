#!/usr/bin/env bash

# echo your_password | sudo -S true

source ./ellipsis.sh

user: "{{ ansible_env.USER }}"

# include_tasks: lifecycle/setup.yml

sudo apt-get -y update
sudo apt-get upgrade -y

# Ansible dependency

packages=("python")

for p in "${packages[@]}"; do
 echo -n "Installing package: $p "

  # Run apt-get in background
  sudo apt-get -y install "$p" > /dev/null 2>&1 &
  pid=$!

  wait $pid
  status=$?

  if [ $status -eq 0 ]; then
    echo -e "\rInstalling package: $p ... done"
  else
    echo -e "\rInstalling package: $p ... failed"
  fi
done

# =========================================
# =========================================
# =========================================




  sudo -S true

  p="paru"

  sudo pacman -S "$p" > /dev/null 2>&1 &
  pid=$!

  ./ellipsis.sh $pid $p

  wait $pid
  status=$?

