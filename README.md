# Robot-Movement
The script uses ROS (Robot Operating System) to publish velocity commands to the robot's motors. The script listens for keyboard input using the pynput library and maps the input to robot movements (forward -> W, backwards -> S, turn left -> A, turn right -> D, and stop -> X). The script then publishes the appropriate velocity commands to the robot's motors using the ROS rospy.Publisher function.

Here's a breakdown of the script:

The script starts by importing the necessary libraries: rospy for using ROS, Int16 from std_msgs.msg for publishing integer messages, and keyboard from pynput for listening to keyboard input.

The script defines some constants for the robot movements: MOVE_FORWARD, MOVE_BACK, TURN_LEFT, TURN_RIGHT, STOP, and CLOSE. These are used to map keyboard input to robot movements.

The script initializes the ROS node and sets up a publisher to the topic /arduino/motor_vel with a message type of Int16. It also sets the rate of the publisher to 10 Hz.

The send_message function is defined to publish the velocity commands to the robot's motors. The function takes two arguments, vel_left and vel_right, which are the velocities for the left and right motors, respectively. The function logs the data sent to the console using rospy.loginfo and publishes the velocities to the /arduino/motor_vel topic using pub.publish. Finally, the function sleeps for the duration specified by the rate object.

The set_movement function is defined to set the velocities for the left and right motors based on the robot_move variable. If robot_move is MOVE_FORWARD, the velocities for both motors are set to 255 (maximum speed). If robot_move is MOVE_BACK, the velocities are set to -255 (maximum reverse speed). If robot_move is TURN_LEFT, the velocity for the right motor is set to 255 (turning left). If robot_move is TURN_RIGHT, the velocity for the left motor is set to 255 (turning right). Finally, the send_message function is called with the appropriate velocities.

The init_key_listener function is defined to listen for keyboard input using the pynput library. It creates a keyboard.Listener object with a callback function on_press, starts the listener on a separate thread, and waits for the listener to join.

The on_press function is the callback function for the keyboard.Listener. It takes a key argument and maps the keyboard input to robot_move. If the key is keyboard.Key.esc or the char of the key is CLOSE, the function returns False to stop the listener. Otherwise, the char or name of the key is assigned to robot_move, and the set_movement function is called.

Finally, the script is wrapped in a try-except block to catch rospy.ROSInterruptException and pass it silently.

