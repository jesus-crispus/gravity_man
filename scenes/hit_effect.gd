extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.position)
	mesh = load("res://scenes/hit_effect.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass