#!/usr/bin/env python

import RPi.GPIO as GPIO
import dht11
import json
import os
import time
from device import receive_data
import logging
from send_event import send_event

MAX_TRIES = 10
TRY_SLEEP_SECONDS = 0.1

heat_sensors = [(22, "apte-livingroom")]
measurement_trigger_channel = 6
liveness_check_channel = 26

host_file = "/tmp/host.txt"

class PeripheralRequestHandler:
	def __init__(self):
		self.request_details = None

	def get_request_details(self):
		if self.request_details == None:
			try:
				with open(host_file, "r") as f:
					unparsed_details = f.read()
					if unparsed_details != "":
						try:
							logging.info(unparsed_details)
							self.request_details = json.loads(unparsed_details)
						except Exception as e:
							logging.error("Failed to parse details from file. {error}".format(error=e))
					else:
						logging.warn("Tried to read new host from host file, file was empty.")
			except Exception as error:
				logging.warn("Failed to read host from host file: {error}".format(error=error))
		return self.request_details

	def send_request(self, microclimate_key, temperature):
		try:
			details = self.get_request_details()
			send_event(
				domain=details['domain'],
				peripheralId=details['peripheralId'],
				deploymentId=details['deploymentId'],
				value=temperature
			)
		except Exception as error:
			logging.warn("Failed to send peripheral event: {error}".format(error=error))

try:
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	GPIO.setup(liveness_check_channel,GPIO.OUT, initial=GPIO.LOW)
	GPIO.setup(measurement_trigger_channel, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

	instances = [(dht11.DHT11(pin = pin), event_name) for (pin, event_name) in heat_sensors]

	request_handler = PeripheralRequestHandler()

	def read_temperature(channel = None):
		for (instance, event_name) in instances:
			result = instance.read()

			tries = 0
			while tries < MAX_TRIES and (not result.is_valid() or (result.is_valid() and result.temperature == 0)):
				logging.warn('Result for %s not valid: %s' % (event_name, result.error_code))
				time.sleep(TRY_SLEEP_SECONDS)
				result = instance.read()
				tries += 1

			if result.is_valid() and result.temperature != 0:
				celcius = result.temperature
				farenheit = (celcius*9/5) + 32
				logging.info('Temp %s: %s F, Humid: %s' % (event_name, farenheit, result.humidity))
				request_handler.send_request(event_name, farenheit)


		GPIO.output(liveness_check_channel,GPIO.HIGH)
		time.sleep(15)
		GPIO.output(liveness_check_channel,GPIO.LOW)

	GPIO.add_event_detect(measurement_trigger_channel, GPIO.RISING, callback=read_temperature)

	while True:
		read_temperature()
		time.sleep(300)
	
finally:
	GPIO.cleanup()
