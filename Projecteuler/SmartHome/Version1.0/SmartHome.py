#!SmartHome.py
# Import Modules
import rgb_led as led
import temperature
import volume
import time
import random
import thread
import interpreter


# The main function where to start everything
def main():

	try:

		while True:
			error = 0
			cmd_input = raw_input("What is your command, Sir?\n")
			cmd_input_split = cmd_input.split()
			# just for debugging
			#print(cmd_input_split)
			#print(len(cmd_input_split))

			if cmd_input_split[0] == "led":
				del cmd_input_split[0]
				led.interpreter(cmd_input_split)
				

			elif cmd_input_split[0] == "exit":
				print("Goodbye Sir!\n")
				break
			#if temperature.read() != None:
			#	print "Current temperature : %0.3f C" % temperature.read()
			#volume.volume_control()
			time.sleep(0.1)

	except KeyboardInterrupt:
		volume.exitFlag = 1


if __name__ == '__main__':
	main()