#!/bin/bash -x
apt-get -y install gawk wget git diffstat curl \
  build-essential chrpath screen device-tree-compiler socat python-setuptools texinfo

curl -sSL https://get.docker.com/ | sh
usermod -aG docker vagrant
systemctl enable docker
ufw disable

git clone http://github.com/mininet/mininet ~/mininet
cd ~/mininet
sudo python setup.py install
sudo util/install.sh

sudo -u vagrant /bin/sh -c 'cd && \
  git clone http://git.openswitch.net/openswitch/ops-build ops-build && \
  cd ops-build && \
  make configure genericx86-64 && \
  make && \
  make export_docker_image && \
  make distclean'

cd /home/vagrant
git clone http://git.openswitch.net/openswitch/ops-vsi
cd ops-vsi
python setup.py install
chown -R vagrant: /home/vagrant/ops-vsi

update-rc.d -f apparmor remove
