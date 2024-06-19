extends RigidBody3D



@export var speed_curve:Curve
@export var Ui_data:Resource
@export var speed = 5000
@export var zero_gravity_speed = 100
@onready var _speed_variable
@onready var _curent_gravity:Vector3 = gravity_vector_ref

@export var normal_gravity_jump_velocity = 10
@export var zero_gravity_jump_velocity = 30

var air_movment_velocity
var gravity_vector_ref = Vector3(0,-9.8,0)
var max_normal_velocity =   10
var grounded = false
signal _velocity_canceled
var cancel_velocity = false
#var _speed_curve_output
var velocity
# state machine
#does not work with out onready
@onready var states:Array = [ normal_gravity_state, zero_gravity_state]

enum STATE_REF{
	
	CHECK_STATE, 
	ENTER_STATE, 
	CALL_EVERY_PHYSICS_FRAME_STATE, 
	EXIT_STATE,
	JUMP,
	MOVE,
	INTEGRATED_FORCES,
	}


@onready var _curent_state = normal_gravity_state

# state variables


# normal_gravity_state
var normal_gravity_state:Array = [
	check_normal_gravity_state,
	enter_normal_gravity_state,
	call_every_physics_frame_normal_gravity_state,
	exit_normal_gravity_state,
	#jump_normal_gravity_state
	jump_zero_gravity_state,
	move_normal_gravity_state,
	integrated_forces_normal_gravity_state,
	]




# zero_gravity_state
var zero_gravity_state:Array[Callable] = [
	check_zero_gravity_state,
	enter_zero_gravity_state,
	call_every_physics_frame_zero_gravity_state,
	exit_zero_gravity_state,
	jump_zero_gravity_state,
	move_zero_gravity_state,
	integrated_forces_zero_gravity_state,
	]




#camera varieble
var mouse_sensitivity_x: float = 0.05
var mouse_sensitivity_y: float = 0.05


var min_yaw: float = -180 
var max_yaw: float = 180

var min_pitch: float = -60
var max_pitch: float = 80


#input
var input_jump : String = "jump"
var input_left : String = "move_left"
var input_right : String = "move_right"
var input_forward : String = "move_forward"
var input_backwards : String = "move_backwards"


@onready var jump_timer = $JumpTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	speed = speed * mass
	zero_gravity_speed = zero_gravity_speed * mass
	_speed_variable = speed


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var x_axis = %HeadPitchAxis.rotation_degrees.x
		var y_axis = %HeadYawAxis.rotation_degrees.y
		x_axis -= event.relative.y * mouse_sensitivity_x
		x_axis = clampf(x_axis, min_pitch, max_pitch)
		y_axis -= event.relative.x * mouse_sensitivity_y
		y_axis = wrapf(y_axis, min_yaw, max_yaw)
		
		%HeadYawAxis.rotation_degrees.y = y_axis
		%HeadPitchAxis.rotation_degrees.x = x_axis
		
		temp_x_axis = deg_to_rad(x_axis)
		temp_y_axis = y_axis
	
	#if Input.is_action_pressed(input_jump):
		#_jump()
	#
	#if Input.is_action_pressed(input_left):
		#_move_left()
	#
	#if Input.is_action_pressed(input_right):
		#_move_right()
	#
	#if Input.is_action_pressed(input_forward):
		#_move_forward()
	#
	#if Input.is_action_pressed(input_backwards):
		#_move_backwards()

var temp_x_axis = 1
var temp_y_axis 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	velocity = linear_velocity.length()#abs(linear_velocity.x) + abs(linear_velocity.y) + abs(linear_velocity.z)
	
	
	Ui_data.player_velocity = velocity
	
	_curent_state[STATE_REF.CALL_EVERY_PHYSICS_FRAME_STATE].call()
	
	
	
	
	
	
	_curent_state[STATE_REF.MOVE].call(delta)


func _integrate_forces(state: PhysicsDirectBodyState3D ):
	
	_curent_gravity = state.total_gravity
	
	
	_curent_state[STATE_REF.INTEGRATED_FORCES].call(state)
	
	
	Ui_data.player_grounded = grounded
	
	#if temp_y_axis != null:
		#angular_velocity.y = temp_y_axis
		#
		#temp_y_axis = null
		#
	#else: angular_velocity.y = 0
	
	if Input.is_action_pressed(input_jump):
		if jump_timer.is_stopped():
			if grounded == true:
				
				jump_timer.start()
				_curent_state[STATE_REF.JUMP].call(state)
	
	#if cancel_velocity == true:
		#
		#state.linear_velocity = Vector3( 0, 0, 0)
		#
		#
		#cancel_velocity == false
		#emit_signal(str(_velocity_canceled))

func state_machine():
	#var last_curent_state = curent_state
	
	for n in states:
		
		
		if (n[STATE_REF.CHECK_STATE].call()) == true:
			
			_curent_state = n
			n[STATE_REF.ENTER_STATE].call()
			return




func check_normal_gravity_state():
	if _curent_gravity == gravity_vector_ref:
		return true


func check_zero_gravity_state():
	if _curent_gravity != gravity_vector_ref:
		return true




func enter_normal_gravity_state():
	_speed_variable = speed
	print(str(_curent_state))
	physics_material_override.friction = 0
	
	
	

func enter_zero_gravity_state():
	_speed_variable = zero_gravity_speed
	print(str(_curent_state))
	physics_material_override.friction = 1
	
	linear_damp = 0



func call_every_physics_frame_normal_gravity_state():
	if check_normal_gravity_state() == true:
		
		if grounded == true:
			_speed_variable = speed_curve.sample(velocity / max_normal_velocity) * speed
		else:
			_speed_variable = (speed_curve.sample(velocity / max_normal_velocity) * speed) * 0.2
	else:
		_curent_state[STATE_REF.EXIT_STATE].call()
	
	
	
	if grounded == true:
		linear_damp = 2
	else:
		linear_damp = 0



func call_every_physics_frame_zero_gravity_state():
	if check_zero_gravity_state():
		_speed_variable = speed_curve.sample(velocity / max_normal_velocity) * zero_gravity_speed
	
	else:
		_curent_state[STATE_REF.EXIT_STATE].call()




func exit_normal_gravity_state():
	print( str(_curent_state), "exit")
	
	state_machine()


func exit_zero_gravity_state():
	print( str(_curent_state), "exit")
	
	state_machine()




func jump_normal_gravity_state(state):
	var jump_force = (normal_gravity_jump_velocity * mass)
	var direction = ((self.global_basis) * Vector3(0, 1, 0)).normalized()
	self.apply_central_impulse(Vector3( direction.x * jump_force, direction.y  * jump_force, direction.z  * jump_force))


func jump_zero_gravity_state(state):
	var store_velocity = linear_velocity.length()
	state.linear_velocity = Vector3( 0, 0, 0)
	
	var jump_force = (zero_gravity_jump_velocity + (store_velocity * 0.5)) * mass
	var direction = ((%Camera.global_basis) * Vector3(0, 0, -1)).normalized()
	self.apply_central_impulse(Vector3( direction.x * jump_force, direction.y  * jump_force, direction.z  * jump_force ))




func move_normal_gravity_state(delta):
	var input_dir = Input.get_vector(input_left, input_right, input_forward, input_backwards)
	var direction = ((%HeadYawAxis.global_basis) * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir:
		self.apply_central_force(Vector3( direction.x * _speed_variable * delta, 0, direction.z * _speed_variable * delta))


func move_zero_gravity_state(delta):
	var input_dir = Input.get_vector(input_left, input_right, input_forward, input_backwards)
	var direction = ((%Camera.global_basis) * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir:
		self.apply_central_force(Vector3( direction.x * _speed_variable * delta, direction.y * _speed_variable * delta, direction.z * _speed_variable * delta))




func integrated_forces_normal_gravity_state(state):
	if get_contact_count() >  0 :
		
		
		for n in max_contacts_reported:
			
			var reference_normal = Vector3(0,1,0)
			
			var dot_product_angle = reference_normal.dot(state.get_contact_local_normal(n))
			
			#print(state.get_contact_local_normal(n)) 
			#if  $GroundedTestingHight.global_position.y   >= (state.get_contact_collider_position(n).y):
			if Vector3(0,1,0).dot(state.get_contact_local_normal(n)):
				if 0.7 <=  Vector3(0,1,0).dot(state.get_contact_local_normal(n)):
					#print(str(Vector3(0,1,0).dot(state.get_contact_local_normal(n))))
					
					grounded = true
					return
			else:
				grounded = false
	else:
		grounded = false



func integrated_forces_zero_gravity_state(state):
	if get_contact_count() >  0 :
		grounded = true
		
	elif %ZeroGravityRaycast.is_colliding():
		grounded = true
		
	else:
		grounded = false
	
	
	
	
