extends Node2D

var plant_targeted:Node2D

signal button_harvest
signal button_remove
signal button_info


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_menu():
	global_position = get_global_mouse_position()
	visible = true



func _on_button_hervest_pressed():
	print("harvest")
	button_harvest.emit()

func _on_button_remove_pressed():
	print("remove")
	button_remove.emit()

func _on_button_info_pressed():
	print("info")
	button_info.emit()
