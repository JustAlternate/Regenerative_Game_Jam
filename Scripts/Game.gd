extends Node2D

var id_new_context_menu = 0
var tab_context_menu = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click") and len(tab_context_menu) >= 1:
		var context_menu_to_delet_name = tab_context_menu.pop_front()
		get_node(context_menu_to_delet_name).free()
		


func _on_clock_phase_changed(new_phase):
	print("going to next phase !!!")
	
	# Deciding what random events are going to happen
	print("mettre des random events")
	
	# Updating every plants
	for i in range(8):
		$plant_spot_container.get_child(i).get_node("plant").next_quarter_of_season(new_phase)



func _on_plant_spot_calling_contextual_menu():
	var context_menu_scene = load("res://Scenes/contextual_menu.tscn")
	var context_menu_instance = context_menu_scene.instanciate()
	context_menu_instance.name = "context_menu_" + str(id_new_context_menu)
	tab_context_menu.append("context_menu_" + str(id_new_context_menu))
	add_child(context_menu_instance)
	
