extends Label

@export var Ui_data:Resource
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Grounded = " + str(Ui_data.player_grounded)
