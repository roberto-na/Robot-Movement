#!/usr/bin/env python 
import rospy 
from std_msgs.msg import Int16
from pynput import keyboard

MOVE_FORWARD = "w"
MOVE_BACK = "s"
TURN_LEFT = "a"
TURN_RIGHT = "d"
STOP = "x"
CLOSE = "c"

robot_move = STOP
pub = None
rate = None

def init_nodes():
	global pub
	global rate
	# specify the node /arduino/motor_vel with message kind std_msg/Int
	pub = rospy.Publisher('/arduino/motor_vel', Int16, queue_size=10)
	# gives the name of cmd_vel_publisher
	rospy.init_node('robot_controller_team', anonymous=True)
	# init rate
	rate = rospy.Rate(10) # 10hz
	rospy.loginfo('Node created \"robot_controller_team\"')

def send_message(vel_left, vel_right):	
	global pub
	global rate
	# message to be sent
	rospy.loginfo('data sent: left is ' + str(vel_left) + ' and right is ' + str(vel_right))
	#publish data
	pub.publish(vel_left)
	pub.publish(vel_right)
	rate.sleep()

def set_movement():
	global MOVE_FORWARD, MOVE_BACK, TURN_LEFT, TURN_RIGHT
	global robot_move
	vel_right = 0
	vel_left = 0
	if (robot_move == MOVE_FORWARD):
		vel_right = 255
		vel_left = 255
	if (robot_move == MOVE_BACK):
		vel_right = -255
		vel_left = -255
	if (robot_move == TURN_LEFT):		
		vel_right = 255
	if (robot_move == TURN_RIGHT):
		vel_left = 255	
	send_message(vel_left, vel_right)

def init_key_listener():	
	listener = keyboard.Listener(on_press=on_press)
	listener.start()  # start to listen on a separate thread
	listener.join()  # remove if main thread is polling self.keys

def on_press(key):
	global CLOSE
	global robot_move
	if (key == keyboard.Key.esc or key.char == CLOSE):
		return False  # stop listener
	try:
		k = key.char  # single-char keys
	except:
		k = key.name  # other keys
	robot_move = k 
	set_movement()

if __name__ == '__main__':
	try:
		init_nodes()
		rospy.loginfo('info (movement: key): \n\nMove forward: w\nMove back: s\nTurn left: a\nTurn right: d\nStop: x\nClose: c\n')
		init_key_listener()
	except rospy.ROSInterruptException:
		passg
