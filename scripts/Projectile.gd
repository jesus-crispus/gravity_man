extends RigidBody3D


var ignore_array: Array
var _last_pos

@onready var hit_effect = preload("res://scenes/hit_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_last_pos = self.global_position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	var _new_pos = self.global_position
	
	if _last_pos != null:
		var space_state = get_world_3d().direct_space_state
		
		#INFO link to wiki https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html#doc-physics-introduction-collision-layer-code-example
		var raycast = PhysicsRayQueryParameters3D.create( _last_pos, _new_pos, 0b0101, ignore_array)
		
		var result = space_state.intersect_ray(raycast)
		if result:
			
			var instance = hit_effect.instantiate()
			on_hit(result)
			result.collider.add_child(instance)
			instance.global_position = result.position
			
			
			
			
			
			
			queue_free()
			
			
			result = null
	
	
	_last_pos = _new_pos




func on_hit(result):
	if result.collider is RigidBody3D:
		result.collider.apply_impulse(self.linear_velocity * self.mass, result.position)
		result.collider.continuous_cd = true
	
	
	


func _on_timer_timeout():
	queue_free()
