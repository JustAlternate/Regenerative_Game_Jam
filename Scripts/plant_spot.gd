extends Node2D

@export var number_of_tile_from_river:int

signal calling_contextual_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_button_pressed():
	if GlobalVariables.action_picked == "seed":
		if $plant.plant_type == "None":
			$plant.add_plant(GlobalVariables.seed_picked)
		else:
			calling_contextual_menu.emit()
	else:
		calling_contextual_menu.emit()
