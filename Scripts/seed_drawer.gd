extends Node2D

var seedList = []

func refresh_drawer():
	$HBoxContainer/GridContainer.columns = ceil(count_nombre_container_visible()/2 +1)


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/GridContainer.visible = false
	refresh_drawer()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func count_nombre_container_visible():
	var total_container = $HBoxContainer/GridContainer.get_child_count()
	var count_visible = 0
	for i in range(total_container):
		if $HBoxContainer/GridContainer.get_child(i).visible == true:
			count_visible += 1
	return count_visible

func add_seed_in_drawer(seed):
	$HBoxContainer/GridContainer.get_node("Container_"+seed).visible = true
	
func remove_seed_from_drawer(seed):
	$HBoxContainer/GridContainer.get_node("Container_"+seed).visible = false

func _on_open_drawer_button_toggled(button_pressed):
	GlobalVariables.action_picked = "none"
	$HBoxContainer/GridContainer.visible = not $HBoxContainer/GridContainer.visible
	refresh_drawer()
