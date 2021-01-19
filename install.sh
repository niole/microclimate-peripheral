#!/bin/bash

sudo apt-get update

installPython() {
	./install_python37.sh
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

installWifiDependencies()
{
	sudo apt-get install wpasupplicant
}

installPython
installWifiDependencies
installBluezDependencies
checkForhci0Device
modifyDbusPath
installPythonDeps
