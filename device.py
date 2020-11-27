#!/usr/bin/env python4

import bluetooth
import json
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def receive_data(timeout_seconds = 30):
        s = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
        s.settimeout(timeout_seconds)

        s.bind(("", 0))
        s.listen(1)

        conn, addr = s.accept()

        message = conn.recv(1024)

        conn.close()
        s.close()

        return message
