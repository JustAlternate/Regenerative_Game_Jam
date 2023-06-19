extends Node2D

var seedList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/GridContainer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_open_drawer_button_toggled(button_pressed):
	$HBoxContainer/GridContainer.visible = not $HBoxContainer/GridContainer.visible
