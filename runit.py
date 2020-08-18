import serial
import sys
import time

fd = open(sys.argv[1],'r')
data = fd.read()
fd.close()

ser = serial.Serial('/dev/ttyACM0',115200,timeout=1)
ser.write('!\n')
time.sleep(1)
ser.write('H\n')
time.sleep(1)
ser.write(data)
time.sleep(1)
ser.write('R\n')
time.sleep(1)
ser.write('r\n')
ser.close()
