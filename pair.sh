#!/usr/bin/expect

# this works by opening a limited time session with bluetoothctl,
# assuming that a connect request comes in immediately after
# and then replies a bunch of times over ther course of 30 seconds
# which is the default timeout for the bluetooth server

set prompt "#"
spawn sudo bluetoothctl -a

send -- "power on\n"
send -- "discoverable on\n"
send -- "pairable on\n"
sleep 1
expect -re $prompt
sleep 1
send "agent NoInputNoOutput\r"
sleep 2
expect "Agent registered"
send "default-agent\r"
expect "Default agent request successful"
expect  "Request confirmation"
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
sleep 3
send "yes\r"
send "quit\r"
expect eof
