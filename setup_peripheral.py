#!/usr/bin/env python3.7

import json
import logging
import os
import subprocess
import time
import RPi.GPIO as GPIO
from device import receive_data

logger = logging.getLogger('blt_server')
logger.setLevel(logging.INFO)

pairing_trigger_channel = 19

class SetupDetailsReceiver:
	def __init__(self):
		self.pairing_process = None
	
	def enable_limited_discoverability(channel):
		logger.debug("Spawning pairing session")

		if self.pairing_process != None:
			self.pairing_process.kill()
			self.pairing_process = None

		self.pairing_process = subprocess.Popen(['./pair.sh'])

		logger.debug("Waiting for peripheral setup information")

		setup_details = receive_data()

		logger.info("Received setup details. Exporting for use".format(setup_details=setup_details))

		if setup_details != None:
			decoded_details = setup_details.decode("utf-8")
			with open("/tmp/host.txt", "w") as f:
				f.write(decoded_details)
		else:
			logger.error("Setup details was empty".format(setup_details=setup_details))

try:
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	GPIO.setup(pairing_trigger_channel, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

	receiver = SetupDetailsReceiver()

	GPIO.add_event_detect(pairing_trigger_channel, GPIO.RISING, callback=receiver.enable_limited_discoverability)

	while True:
		logger.debug("she's alive")
		time.sleep(2)
finally:
	GPIO.cleanup()
