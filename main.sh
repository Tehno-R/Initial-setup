SCRIPT_DIR=$(dirname "$0")
USERNAME=$(whoami)
HOSTINFO=$(cat /etc/os-release)

HOST_ARCH="Arch Linux"
HOST_UBUNTU="Ubuntu"
HOST_FEDORA="Fedora Linux"
HOST_CENTOS="CentOS Stream"


if [[ ! -z $(echo "$HOSTINFO" | grep "NAME=\"$HOST_ARCH\"") ]]; then
    sudo pacman -Suy --noconfirm
    sudo pacman -S --noconfirm openssh
elif [[ ! -z $(echo "$HOSTINFO" | grep "NAME=\"$HOST_UBUNTU\"") ]]; then
    sudo apt-get update
    sudo apt-get install openssh-server
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
sudo chmod 600 ~/.ssh/authorized_keys

sudo ssh-keygen -A

sudo /usr/sbin/sshd