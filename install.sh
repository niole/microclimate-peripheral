#!/bin/bash

apt-get update

installPython() {
	./install_python37.sh
}

installPip()
{
	if [[ "$(which pip)" == "" ]] && [[ "$(cat get-pip.py)" == "" ]]
	then
		echo "Installing pip for python 3.7"
		curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
		python3.7 get-pip.py
	fi
}

installBluezDependencies() {
	apt install libbluetooth-dev
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
	fi
}

installPythonDeps()
{
	python3.7 -m pip install -r requirements.txt
}

installWifiDependencies()
{
	sudo apt-get install wpasupplicant
}

oneTimeSetup()
{
	./one_time_setup.sh
}

restartRaspberrypi()
{
	echo "Restarting this raspberry pi"
	shutdown -r now
}

installPython
installPip
installWifiDependencies
installBluezDependencies
checkForhci0Device
modifyDbusPath
installPythonDeps

oneTimeSetup

restartRaspberrypi
