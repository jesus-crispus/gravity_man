extends Node3D



@export var size_vector:Vector3i
@export var pyramid = false

var number_of_blocks
@onready var block = preload("res://scenes/rigid_body_3d.tscn")
var blocks_spawned = 0







# Called when the node enters the scene tree for the first time.
func _ready():
	
	if pyramid == false:
		spawn_block_of_blocks()
	elif pyramid == true:
		spawn_Pyramid_of_blocks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#_spawn_block()
	pass


func spawn_block_of_blocks():
	
	var tracking_vector:Vector3
	
	for y in size_vector.y:
		for z in size_vector.z:
			for x in size_vector.x:
				
				var instance = block.instantiate()
				self.add_child(instance)
				instance.global_position = self.global_position + tracking_vector
				tracking_vector.x += 1
			tracking_vector.x = 0
			tracking_vector.z += 1
		
		tracking_vector.z = 0
		tracking_vector.y += 2

func spawn_Pyramid_of_blocks():
	
	var tracking_vector:Vector3
	
	for y in size_vector.y:
		for z in size_vector.z:
			for x in size_vector.x:
				
				var instance = block.instantiate()
				self.add_child(instance)
				instance.global_position = self.global_position + tracking_vector
				tracking_vector.x += 1
			tracking_vector.x -= size_vector.x
			tracking_vector.z += 1
		tracking_vector.x += 0.5
		size_vector.x -= 1
		tracking_vector.z -= size_vector.z
		tracking_vector.z += 0.5
		size_vector.z -= 1
		tracking_vector.y += 2


func _spawn_block():
	if blocks_spawned < number_of_blocks:
		var instance = block.instantiate()
		
		self.add_child(instance)
		instance.position = position
		blocks_spawned += 1
