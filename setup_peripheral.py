#!/usr/bin/env python

import json
import logging
import os
import subprocess
import time
import RPi.GPIO as GPIO
from device import receive_data

logging.basicConfig(level=logging.DEBUG)
pairing_trigger_channel = 19

try:
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	GPIO.setup(pairing_trigger_channel, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

	def enable_limited_discoverability(channel):
		logging.info("Spawning pairing session")
		subprocess.Popen(['./pair.sh'])
		logging.info("Waiting for peripheral setup information")
		setup_details = receive_data()

		if setup_details != None:
			logging.info("Received setup details: {setup_details}. Exporting for use".format(setup_details=setup_details))

			#parsed_details = json.loads(setup_details)
			#host = parsed_details['host']
			host = "ec2-35-161-83-246.us-west-2.compute.amazonaws.com"
			with open("/tmp/host.txt", "w") as f:
				f.write(host)
		else:
			logging.warn("Setup details was empty: {setup_details}".format(setup_details=setup_details))

	GPIO.add_event_detect(pairing_trigger_channel, GPIO.RISING, callback=enable_limited_discoverability)

	while True:
		logging.info("she's alive")
		time.sleep(2)
finally:
	GPIO.cleanup()
