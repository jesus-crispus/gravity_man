extends Area3D

var is_gravity_on = true
var is_point_gravity_on = true
var is_anti_gravity = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_released("gravity_switch"):
		if is_gravity_on == true:
			is_gravity_on = false
		else: is_gravity_on = true
		_update_garvity()
	
	if Input.is_action_just_released("point_gravity_switch"):
		if is_point_gravity_on == true:
			is_point_gravity_on = false
		else: is_point_gravity_on = true
		_update_point_garvity()
	
	if Input.is_action_just_released("point_gravity_switch"):
		if is_point_gravity_on == true:
			is_point_gravity_on = false
		else: is_point_gravity_on = true
		_update_point_garvity()

	if Input.is_action_just_released("anti_gravity"):
		if is_anti_gravity == true:
			is_anti_gravity = false
		else: is_anti_gravity = true
		_update_anti_gravity()
	

func _update_garvity():
	if is_gravity_on == true:
		gravity_space_override = Area3D.SPACE_OVERRIDE_REPLACE
	else: gravity_space_override = Area3D.SPACE_OVERRIDE_DISABLED
	

func _update_point_garvity():
	if is_point_gravity_on == true:
		gravity_point = true
	else: gravity_point = false

func _update_anti_gravity():
	if is_anti_gravity == true:
		gravity = -10
	
	else: gravity = 1
	
