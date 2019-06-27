#!/usr/bin/env python
import RPi.GPIO as GPIO
import threading
import time
import random


# pin connections
R = 11
G = 12
B = 13


#---------------------------------------
# setup
#   input: Rpin -- pin for red light
#          Gpin -- pin for green light
#          Bpin -- pin for blue light
#---------------------------------------
def setup():
	global pins
	global p_R, p_G, p_B
	pins = {'pin_R': R, 'pin_G': G, 'pin_B': B}
	GPIO.setwarnings(False)
	GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
	for i in pins:
		GPIO.setup(pins[i], GPIO.OUT)   # Set pins' mode is output
		GPIO.output(pins[i], GPIO.LOW) # Set pins to high(+3.3V) to off led
	
	p_R = GPIO.PWM(pins['pin_R'], 2000)  # set Frequece to 2KHz
	p_G = GPIO.PWM(pins['pin_G'], 2000)
	p_B = GPIO.PWM(pins['pin_B'], 2000)
	
	p_R.start(0)      # Initial duty Cycle = 0(leds off)
	p_G.start(0)
	p_B.start(0)

def map(x, in_min, in_max, out_min, out_max):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

def off():
	for i in pins:
		GPIO.output(pins[i], GPIO.LOW)    # Turn off all leds


#---------------------------------------
# seColor
#   input: Rcol -- color value for red
#          Gcol -- color value for green
#          Bcol -- color value for blue
#---------------------------------------
def setColor(Rcol, Gcol, Bcol):   # For example : col = 0x112233
	R_val = Rcol
	G_val = Gcol
	B_val = Bcol

	R_val = map(R_val, 0, 255, 0, 100)
	G_val = map(G_val, 0, 255, 0, 100)
	B_val = map(B_val, 0, 255, 0, 100)
	
	p_R.ChangeDutyCycle(R_val)     # Change duty cycle
	p_G.ChangeDutyCycle(G_val)
	p_B.ChangeDutyCycle(B_val)


def destroy():
	p_R.stop()
	p_G.stop()
	p_B.stop()
	off()
	#GPIO.cleanup()

#######################################################################
# led start                  --- start the LED thread
# led stop                   --- stop the LED thread
# led -c red (green, blue)   --- change color (red, blue, green)
# led -s 11 22 33            --- change color with specific value
# led -t 0.5 (seconds)       --- change the interval of color change
# led                        --- no paramter means same as led start
#######################################################################
def interpreter(parameters):

	global rgbLED

	if len(parameters) == 0:
		if not rgbLED.isAlive():
			rgbLED = myThread(1, "LED-Thread", "", 1.0)
			rgbLED.start()
		else:
			print("Sir, rgbLED thread has been started, you cannot start another one without stopping the current one\n")
		return

	while len(parameters) != 0:

		if parameters[0] == "start":
			if not rgbLED.isAlive():
				rgbLED = myThread(1, "LED-Thread", "", 1.0)
				rgbLED.start()
			else:
				print("Sir, rgbLED thread has been started, you cannot start another one without stopping the current one\n")
			del parameters[0]
		elif parameters[0] == "stop":
			print("rgbLED application has been quited\n")
			rgbLED.stop()
			rgbLED.join()
			del parameters[0]
		elif parameters[0] == "-c":
			rgbLED.color = parameters[1]
			# delete elements from index 0 to 1
			del parameters[0:2] 
		elif parameters[0] == "-s":
			rgbLED.color = [int(parameters[1]), int(parameters[2]), int(parameters[3])]
			del parameters[0:4]
		elif parameters[0] == "-t":
			rgbLED.interval = parameters[1]
			del parameters[0:2]
		else:
			print("Sorry Sir, I don't understand your instructions\n")
			break



# LED thread class, inhereted from threading.Thread class
class myThread(threading.Thread):
	# class constructor of the class
	def __init__(self, threadID, name, color, interval):
		# threading.Thread.__init__ is the system init functions, 
		# it could allocate the resources needed by this thread in OS level
		threading.Thread.__init__(self)
		self.threadID = threadID
		self.name = name
		self.color = color
		self.interval = interval

        # define a event for thread termination
		self._stop_event = threading.Event()

	def run(self):


		while True:
			if self.stopped():
				destroy()
				break
			if self.color == "":
				setColor(0, 0, 0) 
			elif self.color == "red":
				setColor(255, 0, 0)
			elif self.color == "green":
				setColor(0, 255, 0)
			elif self.color == "blue":
				setColor(0, 0, 255)
			elif len(self.color) == 3:
				setColor(self.color[0], self.color[1], self.color[2])
			else:
				setColor(random.randint(1, 255), random.randint(1,255), random.randint(1,255))
			
			time.sleep(float(self.interval))


    #-------------------------------------------------------------
    # to set the stop flag
    #-------------------------------------------------------------
	def stop(self):
		self._stop_event.set()

	#-------------------------------------------------------------
	# to check the stop flag if the thread should be terminated
	#-------------------------------------------------------------
	def stopped(self):
		return self._stop_event.is_set()

# executed when import
# setup pin for LEDs
setup()
rgbLED = myThread(1, "LED-Thread", "", 1.0)



