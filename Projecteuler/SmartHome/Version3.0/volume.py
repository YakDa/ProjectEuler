#!volume.py

import PCF8591 as ADC
import time
from subprocess import call
import threading

exitFlag = 0
# set up PCB = 0x48
ADC.setup(0x48)

def volume_control(threadName):

	volume_array = [0, 0, 0, 0, 0]
	prev = 0
	while True:

		if exitFlag:
			break
		# To smoothe the data
		volume_array[0] = map(ADC.read(1), 0, 170, 0, 100)
		volume_array[1] = map(ADC.read(1), 0, 170, 0, 100)
		volume_array[2] = map(ADC.read(1), 0, 170, 0, 100)
		volume_array[3] = map(ADC.read(1), 0, 170, 0, 100)
		volume_array[4] = map(ADC.read(1), 0, 170, 0, 100)

		volume = (volume_array[0] + volume_array[1] + volume_array[2] + volume_array[3] + volume_array[4]) / 5
		volume = int(volume)

		# only if the volume change more than 2%, then call amixer
		if ((volume - prev) > 1) or ((volume - prev) < -1) :
			call(["amixer", "set", "PCM", str(volume)+"%"])

		time.sleep(0.1)
		prev = volume

def map(x, in_min, in_max, out_min, out_max):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

# volume thead class, inhereted from threading.Thread class
class myThread (threading.Thread):
	def __init__(self, threadID, name):
		threading.Thread.__init__(self)
		self.threadID = threadID
		self.name = name

	def run(self):
		volume_control(self.name)
		