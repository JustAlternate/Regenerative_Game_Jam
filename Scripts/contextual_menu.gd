extends Node2D

var targeted_plant:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_menu(plant:Node):
	targeted_plant = plant
	if targeted_plant.state == targeted_plant.dico_caracteristique["number_of_phases"][targeted_plant.plant_type]:
		$button_harvest.show()
	else:
		$button_harvest.hide()
	global_position = get_global_mouse_position().round()
	visible = true

func _on_button_harvest_pressed():
	print("harvest")
	targeted_plant.harvest_plant()

func _on_button_remove_pressed():
	print("remove")
	targeted_plant.remove_plant()

func _on_button_info_pressed():
	print("info")
	var a = get_tree().root
	get_tree().root.get_node("home/Game/Encyclopedia").open_on_name(targeted_plant.plant_type)

func _on_button_harvest_mouse_entered():
	$button_harvest/Label_Harvest.visible = true

func _on_button_harvest_mouse_exited():
	$button_harvest/Label_Harvest.visible = false

func _on_button_remove_mouse_entered():
	$button_remove/Label_remove.visible = true

func _on_button_remove_mouse_exited():
	$button_remove/Label_remove.visible = false

func _on_button_info_mouse_entered():
	$button_info/Label_Info.visible = true

func _on_button_info_mouse_exited():
	$button_info/Label_Info.visible = false
