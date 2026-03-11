#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
USERNAME=$(whoami)
HOSTINFO=$(cat /etc/os-release)
ETC_DIR="/etc/ssh/"

HOST_ARCH="Arch Linux"
HOST_UBUNTU="Ubuntu"
HOST_FEDORA="Fedora Linux"
HOST_CENTOS="CentOS Stream"


if [[ ! -z $(echo "$HOSTINFO" | grep "NAME=\"$HOST_ARCH\"") ]]; then
    sudo pacman -Suy --noconfirm
    sudo pacman -S --noconfirm openssh
elif [[ ! -z $(echo "$HOSTINFO" | grep "NAME=\"$HOST_UBUNTU\"") ]]; then
    sudo apt-get update -y
    sudo apt-get install -y openssh-server
elif [[ ! -z $(echo "$HOSTINFO" | grep "NAME=\"$HOST_FEDORA\"") ]]; then
    sudo dnf upgrade -y --refresh
    sudo dnf install -y openssh-server
elif [[ ! -z $(echo "$HOSTINFO" | grep "NAME=\"$HOST_CENTOS\"") ]]; then
    sudo yum update -y
    sudo yum install -y openssh-server
else
    echo "This system is not support"
    return
fi

if [[ -d "~/.ssh" ]]; then
    mkdir ~/.ssh
fi

cp "$SCRIPT_DIR/keys/key.pub" ~/.ssh/authorized_keys
sudo chown -R "$USERNAME":"$USERNAME" ~/.ssh
sudo chmod 700 ~/.ssh
sudo chmod 400 ~/.ssh/authorized_keys

sudo cp -f "$SCRIPT_DIR/sshd_config" "$ETC_DIR"

sudo ssh-keygen -A

sudo systemctl start ssh
sudo /usr/sbin/sshd