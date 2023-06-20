extends Node2D

var plant_scene:Resource
var plant_instance
var plant_type:String = "none"
var intance:Node
var shovel_level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click") and not $Button.is_hovered():
		shovel_level = 0




func _on_button_pressed():
	if GlobalVariables.action_picked == "seed":
		if plant_type == "none":
			plant_scene = load("res://Scenes/plants/" + GlobalVariables.seed_picked + ".tscn")
			plant_instance = plant_scene.instantiate()
			plant_instance.name = "plant"
			add_child(plant_instance)
	if GlobalVariables.action_picked == "shovel" and plant_type != "none":
		shovel_level += 1
		if shovel_level == 2:
			get_node("plant").free
			$shovel.visible = false
			shovel_level = 0
		else: 
			$shovel.visible = true

