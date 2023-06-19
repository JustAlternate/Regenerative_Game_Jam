extends TextureButton

@export var Seed_Texture: Texture2D
@export var seed_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_texture(Seed_Texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if (GlobalVariables.action_picked == "seed" and GlobalVariables.seed_picked == seed_name):
		GlobalVariables.action_picked = "none"
	else:
		GlobalVariables.action_picked = "seed"
		GlobalVariables.seed_picked = seed_name
