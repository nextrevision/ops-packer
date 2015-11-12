#!/bin/bash -x
apt-get -y install gawk wget git diffstat curl \
  build-essential chrpath screen device-tree-compiler socat python-setuptools texinfo

curl -sSL https://get.docker.com/ | sh
usermod -aG docker vagrant
systemctl enable docker
ufw disable

git clone http://github.com/mininet/mininet ~/mininet
cd ~/mininet; sudo python setup.py install

sudo -u vagrant /bin/sh -c 'cd && \
  git clone http://git.openswitch.net/openswitch/ops-build ops-build && \
  cd ops-build && \
  make configure genericx86-64 && \
  make && \
  make export_docker_image'

rm -Rf /home/vagrant/ops-build
