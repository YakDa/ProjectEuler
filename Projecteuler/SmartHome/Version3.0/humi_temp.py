import RPi.GPIO as GPIO
import threading
import time
import datetime
import os
import LinePlot

DHTPIN = 35

MAX_UNCHANGE_COUNT = 100

STATE_INIT_PULL_DOWN = 1
STATE_INIT_PULL_UP = 2
STATE_DATA_FIRST_PULL_DOWN = 3
STATE_DATA_PULL_UP = 4
STATE_DATA_PULL_DOWN = 5

def read_dht11_dat():
	GPIO.setup(DHTPIN, GPIO.OUT)
	GPIO.output(DHTPIN, GPIO.HIGH)
	time.sleep(0.05)
	GPIO.output(DHTPIN, GPIO.LOW)
	time.sleep(0.02)
	GPIO.setup(DHTPIN, GPIO.IN, GPIO.PUD_UP)

	unchanged_count = 0
	last = -1
	data = []
	while True:
		current = GPIO.input(DHTPIN)
		data.append(current)
		if last != current:
			unchanged_count = 0
			last = current
		else:
			unchanged_count += 1
			if unchanged_count > MAX_UNCHANGE_COUNT:
				break

	state = STATE_INIT_PULL_DOWN

	lengths = []
	current_length = 0

	for current in data:
		current_length += 1

		if state == STATE_INIT_PULL_DOWN:
			if current == GPIO.LOW:
				state = STATE_INIT_PULL_UP
			else:
				continue
		if state == STATE_INIT_PULL_UP:
			if current == GPIO.HIGH:
				state = STATE_DATA_FIRST_PULL_DOWN
			else:
				continue
		if state == STATE_DATA_FIRST_PULL_DOWN:
			if current == GPIO.LOW:
				state = STATE_DATA_PULL_UP
			else:
				continue
		if state == STATE_DATA_PULL_UP:
			if current == GPIO.HIGH:
				current_length = 0
				state = STATE_DATA_PULL_DOWN
			else:
				continue
		if state == STATE_DATA_PULL_DOWN:
			if current == GPIO.LOW:
				lengths.append(current_length)
				state = STATE_DATA_PULL_UP
			else:
				continue
	if len(lengths) != 40:
		#print "Data not good, skip"
		return False

	shortest_pull_up = min(lengths)
	longest_pull_up = max(lengths)
	halfway = (longest_pull_up + shortest_pull_up) / 2
	bits = []
	the_bytes = []
	byte = 0

	for length in lengths:
		bit = 0
		if length > halfway:
			bit = 1
		bits.append(bit)
	#print "bits: %s, length: %d" % (bits, len(bits))
	for i in range(0, len(bits)):
		byte = byte << 1
		if (bits[i]):
			byte = byte | 1
		else:
			byte = byte | 0
		if ((i + 1) % 8 == 0):
			the_bytes.append(byte)
			byte = 0
	#print the_bytes
	checksum = (the_bytes[0] + the_bytes[1] + the_bytes[2] + the_bytes[3]) & 0xFF
	if the_bytes[4] != checksum:
		#print "Data not good, skip"
		return False

	return the_bytes[0], the_bytes[2]

def read_humid_temp():

	result = False
	while (result==False):
		result = read_dht11_dat()
	return result
	

def writelog(sdata):

	filename = "log/" + (str(datetime.datetime.now()))[:-16] + '.csv'
	if os.path.exists(filename):
	    append_write = 'a' # append if already exists
	else:
	    append_write = 'w' # make a new file if not

	logfile = open(filename, append_write)
	if append_write == 'w':
		yersterday = datetime.date.today() - datetime.timedelta(1)
		LinePlot.LinePlot_ht(str(yersterday) + '.csv')
		logfile.write("Time,Humidity(%),Temperature(C)\n")
	logfile.write(sdata)
	logfile.close()

def destroy():
	GPIO.setup(DHTPIN, GPIO.IN)
	#GPIO.cleanup()

####################################################################################
# ht start                   --- start the ht thread
# ht stop                    --- stop the ht thread
# ht -a [action]             --- change the action of ht thread
#        display             --- display the data in console
#        record              --- write data into the log files
#        clean               --- clean all the log files
#        plot                --- draw graph of humidity and temperature of yersterday
# ht -t 1 (only integer)     --- change the interval of retrieve data from sensors
####################################################################################
def interpreter(parameters):

	global ht

	if len(parameters) == 0:
		if not ht.isAlive():
			GPIO.setmode(GPIO.BOARD)
			ht = myThread(2, "HT-Thread", "record")
			ht.start()
		else:
			print("Sir, HT thread has been started, you cannot start another one without stopping the current one\n")
		return

	while len(parameters) != 0:

		if parameters[0] == "start":
			if not ht.isAlive():
				GPIO.setmode(GPIO.BOARD)
				ht = myThread(2, "HT-Thread", "record")
				ht.start()
			else:
				print("Sir, HT thread has been started, you cannot start another one without stopping the current one\n")
			del parameters[0]
		elif parameters[0] == "stop":
			print("HT application has been quited\n")
			ht.stop()
			ht.join()
			del parameters[0]
		elif parameters[0] == "-a":
			ht.action = parameters[1]
			del parameters[0:2] 
		elif parameters[0] == "-t":
			ht.interval = parameters[1]
			del parameters[0:2]
		else:
			print("Sorry Sir, I don't understand your instructions\n")
			break

# thread class, inhereted from threading.Thread class
class myThread(threading.Thread):
	# class constructor of the class
	def __init__(self, threadID, name, action):
		# threading.Thread.__init__ is the system init functions, 
		# it could allocate the resources needed by this thread in OS level
		threading.Thread.__init__(self)
		self.threadID = threadID
		self.name = name
		self.action = action
		self.interval = 1800

        # define a event for thread termination
		self._stop_event = threading.Event()

	def run(self):


		while True:
			if self.stopped():
				destroy()
				break
			if self.action == "display":
				timestamp = (str(datetime.datetime.now()))[:-7]
				humidity, temperature = read_humid_temp()
				print "Time: %s, Humidity: %s %%,  Temperature: %s C`" % (timestamp, humidity, temperature)
			elif self.action == "record":
				timestamp = (str(datetime.datetime.now()))[11:19]
				humidity, temperature = read_humid_temp()
				sdata = timestamp + "," + str(humidity) + "," + str(temperature) + "\n"
				writelog(sdata)
			elif self.action == "clean":
				pass
			elif self.action == "plot":
				yersterday = datetime.date.today() - datetime.timedelta(1)
				LinePlot.LinePlot_ht(str(yersterday) + '.csv')
				self.action = ""
			else:
				# Same as "display" action
				timestamp = (str(datetime.datetime.now()))[:-7]
				humidity, temperature = read_humid_temp()
				print "Time: %s, Humidity: %s %%,  Temperature: %s C`" % (timestamp, humidity, temperature)

			counter = 0
			while ((not self.stopped()) and (counter < int(self.interval))):
				time.sleep(1)
				counter += 1
			



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
ht = myThread(2, "HT-Thread", "record")
