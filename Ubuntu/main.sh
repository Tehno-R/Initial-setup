SCRIPT_DIR=$(dirname "$0")
USERNAME=$(whoami)

sudo apt-get update
sudo apt-get install openssh-server

cp "$SCRIPT_DIR/keys/key.pub" ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/authorized_keys
sudo chmod 700 ~/.ssh
sudo chown -R "$USERNAME" ~/.ssh

ssh-keygen -A

/usr/sbin/sshd