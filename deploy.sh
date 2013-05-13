#!/bin/bash

if [ "$1" == "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage $0 [--help|<service scripts dir>]"
        exit 0
fi

exit 0

echo "Installing dependencies - you may need to enter your password for sudo"
sudo yum -y groupinstall "Development tools"
sudo yum -y install python-virtualenv git openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel bzip2-devel libzip-devel libzip sqlite-devel python-devel mysql-devel mysql-client

INSTALL_DIR = pwd

echo "Building python in /usr/share/python-buildout"
cd ~
mkdir .python
cd .python/
virtualenv --no-site-packages build_python
cd ~
mkdir bin
echo "export PATH=\$PATH:~/bin" > /etc/profile.d/home_bin.sh
source /etc/profile
ln -s ~/.python/build_python/bin/pip ~/bin/python_pip
python_pip install setuptools --upgrade zc.buildout==1.4.4

ln -s ~/.python/build_python/bin/buildout ~/bin/python_buildout

sudo mkdir /usr/share/python-buildout
cd /usr/share/python-buildout
sudo git clone https://github.com/collective/buildout.python.git
cd buildout.python/
sudo sed -i "s@prefix = /opt/local@prefix = /usr/share/python-buildout@g" buildout.cfg
sudo python_buildout
sudo ./bin/install-links

# Return to the installation directory.
cd $INSTALL_DIR

echo "Cloning the deployment repository from github."
git clone https://github.com/jcu-eresearch/EnMaSSe-Deployment.git ./

echo "Installing the EnMaSSe application."
cd $INSTALL_DIR
virtualenv-2.7 --no-site-packages venv
venv/bin/easy_install zc.buildout distribute uwsgi

echo "Copying lxml egg before calling buildout (lxml has problems)."
mkdir ./eggs
cp -r lxml-binaries/lxml ./eggs/
cp lxml-binaries/linux/lxml-3.1.0-py2.7.egg-info ./eggs/

echo "Running the buildout installer."
venv/bin/buildout

echo "Setting up the provisioning interface as a service."
sudo cp $1/enmasse_provisioning /etc/init.d
chkconfig enmasse_provisioning on
service enmasse_provisioning start

echo "Setting up the ingester platform as a service."
cp $1/enmasse_ingester_platform /etc/init.d
chkconfig enmasse_ingester_platform on
service enmasse_ingester_platform start

echo "You now need to update the following configuration files:/n/tsrc/jcu.dc24.ingesterplatform/dc24_ingester_platform.tac/n/tsrc/jcu.dc24.provisioning/production.ini/n/tsrc/jcu.dc24.provisioning/development.ini"


