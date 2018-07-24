extends Area2D

const MOTION_SPEED=150

var motion = Vector2(0, 0)

#synchronize position and speed to the other peers
slave func set_pos_and_motion(p_pos, p_motion):
	position = p_pos
	motion = p_motion

func set_name(name):
	self.name = name
	$name.text = name

func _process(delta):
	#is the master of the paddle
	if is_network_master():
		motion = Vector2(0, 0)
		if Input.is_action_pressed("move_up"):
			motion.y -= 1
		elif Input.is_action_pressed("move_down"):
			motion.y += 1
		if Input.is_action_pressed("move_left"):
			motion.x -= 1
		elif Input.is_action_pressed("move_right"):
			motion.x += 1

		motion *= MOTION_SPEED

		#using unreliable to make sure position is updated as fast as possible, even if one of the calls is dropped
		rpc_unreliable("set_pos_and_motion", position, motion)

		translate(motion * delta)
