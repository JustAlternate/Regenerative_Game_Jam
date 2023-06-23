extends TextureButton

@export var Seed_Texture: Texture2D
@export var seed_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false
	$Label.text = seed_name
	$Sprite2D.set_texture(Seed_Texture)
	$Sprite2D.visible = true

func update_number_seed():
	self.visible = (GlobalVariables.inventory[seed_name]["seed"] > 0)
	$SeedNumberLabel.text = str(GlobalVariables.inventory[seed_name]["seed"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if (GlobalVariables.action_picked == "seed" and GlobalVariables.seed_picked == seed_name): #this seed is selected
		GlobalVariables.action_picked = "none"
	else:
		GlobalVariables.action_picked = "seed"
		GlobalVariables.seed_picked = seed_name
		$SoundPool.play_random_sound()
	


func _on_mouse_entered():
	$Label.visible = true
	$SeedNumberLabel.visible = true


func _on_mouse_exited():
	$Label.visible = false
	$SeedNumberLabel.visible = false
