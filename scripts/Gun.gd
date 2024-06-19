extends Node3D

@onready var projectile = preload("res://scenes/projectile.tscn")
# Called when the node enters the scene tree for the first time.
@onready var rigidbody = get_parent().get_parent().get_parent().get_parent().get_parent()
@export var Newton_mode = true
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	if Input.is_action_pressed("shot"):
		if $GunTimer.is_stopped():
			
			$GunTimer.start()
			
			var instance = projectile.instantiate()
			instance.position = position
			self.add_child(instance)
			
			var gun_force = 200 * instance.mass
			var direction = ((%Camera.global_basis) * Vector3(0, 0, -1)).normalized()
			instance.ignore_array = [rigidbody]
			
			instance.apply_central_impulse(Vector3( direction.x * gun_force, direction.y  * gun_force, direction.z  * gun_force ))
			
			if Newton_mode == true:
				direction = ((%Camera.global_basis) * Vector3(0, 0, 1)).normalized()
				rigidbody.apply_central_impulse(Vector3( direction.x * gun_force, direction.y  * gun_force, direction.z  * gun_force ))
