import threading

a = [1, 2, 3, 4, 5]
del a[1]
print a



# LED thread class, inhereted from threading.Thread class
class myThread(threading.Thread):
	def __init__(self, threadID, name, color, interval):
		threading.Thread.__init__(self)

		self.threadID = threadID
		self.name = name
		self.color = color
		self.interval = interval

		self._stop_event = threading.Event()

	def run(self):


		while True:
			if self.stopped():
				print "LED thread quite\n.."
				break
			
			

	def stop(self):
		self._stop_event.set()

	def stopped(self):
		return self._stop_event.is_set()

while True:
	cmd_input = raw_input("What is your command, Sir?\n")

	test = myThread(1, "test", "", 1)

	cmd_input = raw_input("What is your command, Sir?\n")

	test.start()

	cmd_input = raw_input("What is your command, Sir?\n")
	test.stop()
