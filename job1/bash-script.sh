#!/bin/bash
repositories=$(grep -Erh ^deb /etc/apt/sources.list* | grep "backports")

if [[ -z $repositories ]]; then
  echo "Repository isn't set"
  echo 'deb http://deb.debian.org/debian jessie-backports main contrib non-free' >> /etc/apt/sources.list
  echo 'deb http://deb.debian.org/debian jessie-backports-sloppy main contrib non-free' >> /etc/apt/sources.list
else echo "Repository is set"
fi

apt update

if [[ -z $(apt-cache show apache2 | grep "No packages found") ]]; then
  echo "Apache2 will be installed"
  apt install -y apache2
  /etc/init.d/apache2 start
else echo "Apache2 hasn't found in repositories"
fi

if [[ -z $(apt-cache show python3 | grep "No packages found") ]]; then
  echo "Python will be installed"
  apt install -y python3
else echo "Python hasn't found in repositories"
fi

apt install -y openssh-server
apt install -y openssh-client
systemctl start sshd

if [[ -z $(cat /etc/ssh/sshd_config | grep "Port 24") ]]; then
  echo "Port 24"  >> /etc/ssh/sshd_config
  systemctl restart sshd
fi

echo "Copying tar.gz to /mnt"
cp $1 /mnt

base_name=$(basename $1)
tar -xf /mnt/$base_name

adduser ssh_auth_user

if [[ -z $(cat /etc/ssh/sshd_config | grep "^PubkeyAuthentication yes") ]]; then
  echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
  sudo -u ssh_auth_user ssh-keygen
  cd /home/ssh_auth_user/.ssh
  cat ./id_rsa.pub >> autorized_keys
  systemctl restart sshd
  chown ssh_auth_user autorized_keys
  chgrp ssh_auth_user autorized_keys
  chmod ug+rw autorized_keys
  chmod o-w autorized_keys
fi
