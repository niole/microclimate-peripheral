#!/bin/bash

if [ $(which python3.7) ]
then
	echo "Python 3.7 already exists. exiting"
	exit 0
fi

echo -e "\nInstalling global dependencies"
sudo apt-get install build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

echo -e "\nBuilding openssl 1.0.2 and libssl"

cd /usr/src
sudo curl https://www.openssl.org/source/openssl-1.0.2o.tar.gz | tar xz
cd openssl-1.0.2o
sudo ./config shared --prefix=/usr/local/
sudo make
sudo make install
mkdir lib
cp ./*.{so,so.1.0.0,a,pc} ./lib

echo -e "\nBuilding python 3.7. This could take ~15 minutes"

cd /usr/src
sudo wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
sudo tar xzf Python-3.7.0.tgz
cd Python-3.7.0
sudo ./configure --with-openssl=/usr/src/openssl-1.0.2o --enable-optimizations
sudo LD_RUN_PATH=/usr/src/openssl-1.0.2o make
sudo make altinstall

echo -e "\nChecking python version"

python3.7 -V

echo -e "\nRemoving Python-3.7.0.tgz"
cd /usr/src
sudo rm Python-3.7.0.tgz
