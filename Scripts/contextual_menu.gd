extends Node2D

var targeted_plant:Node



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_menu(plant_to_target:Node):
	global_position = get_global_mouse_position()
	visible = true
	targeted_plant = plant_to_target 



func _on_button_harvest_pressed():
	print("harvest")
	targeted_plant.harvest()
	

func _on_button_remove_pressed():
	print("remove")
	targeted_plant.remove()

func _on_button_info_pressed():
	print("info")
	#hummm
