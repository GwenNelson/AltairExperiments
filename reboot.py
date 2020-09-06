import serial
import sys
import time
import os

ser = serial.Serial('/dev/ttyACM0',1200,timeout=1)
ser.dtr=False
ser.close()

time.sleep(1)

#os.system('bossac -b -R')

time.sleep(1)
