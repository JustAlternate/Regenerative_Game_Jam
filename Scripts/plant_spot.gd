extends Node2D

var plant_scene:Resource
var plant_instance
var intance:Node
var shovel_level:int = 0

signal calling_contextual_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click") and not $Button.is_hovered():
		shovel_level = 0
		$shovel.visible = false

func _on_button_pressed():
	if GlobalVariables.action_picked == "seed":
		if $plant.plant_type == "None":
			$plant.add_plant(GlobalVariables.seed_picked)
		else:
			calling_contextual_menu.emit()
	else:
		calling_contextual_menu.emit()
