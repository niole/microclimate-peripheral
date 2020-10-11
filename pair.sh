#!/usr/bin/expect

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
