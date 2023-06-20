extends TextureButton

@export var Seed_Texture: Texture2D
@export var seed_name: String
@export var is_shovel: bool = false
@export var activated: bool = false
var number_of_seeds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_texture(Seed_Texture)
	$Sprite2D.visible = activated
	disabled = not activated

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
	pass


func _on_pressed():
	print("a")
	if not is_shovel:
		if (GlobalVariables.action_picked == "seed" and GlobalVariables.seed_picked == seed_name): #this seed is selected
			print("b")
			GlobalVariables.action_picked = "none"
		else:
			print("c")
			GlobalVariables.action_picked = "seed"
			GlobalVariables.seed_picked = seed_name
	else: #is_shovel
		if (GlobalVariables.action_picked == "shovel"):
			print("d")
			GlobalVariables.action_picked = "none"
		else:
			print("e")
			GlobalVariables.action_picked = "shovel"
		
