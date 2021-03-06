extends KinematicBody

########################################## Variables
##################### vector
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

##################### gamepad
var ver_l = 0;
var hor_l = 0;

var ver_r = 0;
var hor_r = 0;

##################### var
var sens = 4.5
var speed = 12;
var jump = 4;
var jetpack = 5;
var gravity = 12;
var jump_variants = 0 # 0 = jump; 1 = jetpack

##################### obj
onready var head = $head


########################################## Functions
func _ready():
	gravity /= 9;
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	hor_l = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	ver_l = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	
	hor_r = Input.get_action_strength("cam_right") - Input.get_action_strength("cam_left")
	ver_r = Input.get_action_strength("cam_up") - Input.get_action_strength("cam_down")
	
	##################### input keyboard
	### exit
	if Input.is_action_just_pressed("key_start"):
		get_tree().quit()
	### jump pressed
	if Input.is_action_just_pressed("key_y"):
		match jump_variants:
			0:
				jump_variants = 1
				print("Use jetpack")
			1:
				jump_variants = 0
				print("Use Jump")
		
	### restart
	if Input.is_action_just_pressed("key_select"):
		get_tree().change_scene("res://assets/main.tscn")


func _physics_process(delta):
	##################### camera
	rotate_y(deg2rad(hor_r * sens * -1)) 
	head.rotate_x(deg2rad(ver_r * sens)) 
	head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	
	##################### input move
	direction = Vector3()
	move_and_slide(fall, Vector3.UP)

	if not is_on_floor():
		fall.y -= gravity

	if ver_l < 0:
		direction -= transform.basis.z * ver_l
	elif ver_l > 0:
		direction += transform.basis.z * ver_l * -1
		
	if hor_l < 0:
		direction -= transform.basis.x * hor_l * -1
	elif hor_l > 0:
		direction += transform.basis.x * hor_l
	
#	jump()
		
	velocity = velocity.linear_interpolate(direction * speed, 10 * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 

func jump():
	match jump_variants:
		0:
			if Input.is_action_just_pressed("key_a") and is_on_floor():
				fall.y = jump
		1:
			if Input.is_action_pressed("key_a"):
				fall.y = jetpack
	
#	if Input.is_action_pressed("key_a"):
#		fall.y = jump
