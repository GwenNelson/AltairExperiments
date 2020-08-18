#!/bin/bash
echo "Raise stop on the altair, configure sense switches and hit enter"
read -n 1
echo "Sending $1..."
sleep 1
echo 'H' >/dev/ttyACM0
sleep 1
cat $1 >/dev/ttyACM0
sleep 1
echo '>' >/dev/ttyACM0
sleep 1
echo '0' >/dev/ttyACM0
echo "Program should now be running!"
