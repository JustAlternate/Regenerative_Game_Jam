extends TextureButton

@export var Seed_Texture: Texture2D
@export var seed_name: String
var number_of_seeds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_texture(Seed_Texture)
	$Sprite2D.visible = false
	disabled = true

# Add n seeds to number_of_seeds and changes sprite visibility and enables button accordingly
func add_seeds(n):
	if (n > 0):
		number_of_seeds += n
		$Sprite2D.visible = true
		disabled = false
		$Sprite2D/SeedNumberLabel.text = str(number_of_seeds)

# Removes n seeds to number_of_seeds and if there are no seeds left, hides the seed sprite and disables the button
func remove_seeds(n):
	number_of_seeds -= n
	$Sprite2D/SeedNumberLabel.text = str(number_of_seeds)
	if (number_of_seeds <= 0):
		number_of_seeds = 0
		$Sprite2D.visible = false
		disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		add_seeds(1)
	if Input.is_action_just_pressed("ui_cancel"):
		remove_seeds(1)


func _on_pressed():
	if (GlobalVariables.action_picked == "seed" and GlobalVariables.seed_picked == seed_name):
		GlobalVariables.action_picked = "none"
	else:
		GlobalVariables.action_picked = "seed"
		GlobalVariables.seed_picked = seed_name
	print("Container pressed")
