#!/bin/bash

sudo apt-get update

checkPythonVersion() {
	if [ ! $(which python3.5) ]
	then
		echo "Installing python 3.5
		echo "https://gist.github.com/BMeu/af107b1f3d7cf1a2507c9c6429367a3b"

		sudo apt-get install build-essential tk-dev libncurses5-dev \
		libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev \
		libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev

		wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
		tar zxvf Python-3.5.2.tgz
		cd Python-3.5.2
		./configure --prefix=/usr/local/opt/python-3.5.2
		make
		export LC_ALL=C
		sudo make install

		sudo ln -s /usr/local/opt/python-3.5.2/bin/pydoc3.5 /usr/bin/pydoc3.5
		sudo ln -s /usr/local/opt/python-3.5.2/bin/python3.5 /usr/bin/python3.5
		sudo ln -s /usr/local/opt/python-3.5.2/bin/python3.5m /usr/bin/python3.5m
		sudo ln -s /usr/local/opt/python-3.5.2/bin/pyvenv-3.5 /usr/bin/pyvenv-3.5
		sudo ln -s /usr/local/opt/python-3.5.2/bin/pip3.5 /usr/bin/pip3.5
	fi

	if [ ! $(which python3.5) ]
	then
		echo "Failed to install python 3.5"
	fi
}

installBluezDependencies() {
	sdp_exists=$(which sdptool)

	if [ "$sdp_exists" == "" ]
	then
		apt update
		apt install libbluetooth-dev

	fi
	if [ "$sdp_exists" == "" ]
	then
		echo "Failed to install bluez. sdptool does not exist"
		exit 1
	fi

}

checkForhci0Device()
{
	echo "Looking for hci0 device"
	device=$(hcitool dev | grep "hci0")
	if [ "$device" == "" ]
	then
		echo "Couldn't find an hci0 device"
		exit 1
	fi
	echo "Found hci0 device"
}

modifyDbusPath() {
	if [ "$(cat dbusmodified.txt)" == "" ]
	then
		echo "Modifying $DBUS_PATH to enable 1. compatibilty mode for bluetoothd, 2. pointing to sdptool"

		DBUS_PATH="/etc/systemd/system/dbus-org.bluez.service"

		echo "Deleting all exec starts"

		sed -i "/^ExecStart/d" $DBUS_PATH

		echo "Adding the correct ExecStart lines to $DBUS_PATH"

		sed -i "s/\[Service\]/\[Service\]\\nExecStart=\/usr\/lib\/bluetooth\/bluetoothd -C\\nExecStartPost=\/usr\/bin\/sdptool add SP/g" $DBUS_PATH

		echo "Done modifying $DBUS_PATH"

		echo "done" > dbusmodified.txt

		echo "Restarting this raspberry pi"

		shutdown -r
	fi
}

installPythonDeps()
{
	python3.5 -m pip install -r requirements.txt
}

checkPythonVersion
installBluezDependencies
checkForhci0Device
modifyDbusPath
installPythonDeps
