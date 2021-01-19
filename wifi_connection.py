import re
import subprocess
import time

def process_output(completed_process):
	if completed_process.returncode == 0 and completed_process.stderr == '':
		return completed_process.stdout
	else:
		raise Exception(completed_process.stderr)

def run(commands):
	return process_output(subprocess.run(commands, capture_output=True, text=True))

def generate_new_profile(ssid, pw):
	return run(['wpa_passphrase', ssid, pw])

def overwrite_with_profile(profile_string):
	escaped_profile = re.sub(r'"', '\\"', profile_string)
	formatted_profile = '"' + escaped_profile + '"'
	return run(['bash', '-c', f'echo {formatted_profile} > /etc/wpa_supplicant/wpa_supplicant.conf'])

def start_all_if():
	run(['ifup', '-a'])
	run(['ifup', 'wlan0'])

	time.sleep(2)
	

def update_profile(ssid, pw):
	profile = generate_new_profile(ssid, pw)
	overwrite_with_profile(profile)
	start_all_if()

