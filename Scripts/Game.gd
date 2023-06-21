extends Node2D

var id_new_context_menu = 0
var tab_context_menu = []
var random_event = "rien"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click") and len(tab_context_menu) >= 1:
		print("hop")
		var context_menu_to_delet_name = tab_context_menu.pop_front()
		get_node(context_menu_to_delet_name).free()
	

# new_phase : 0 = Winter2, 1 = Spring1 .... 7 = Winter1
var list_proba_events = [
	#[pluie, soleil, rien]
	[0.4, 0.4, 1], # Winter2
	[0.3, 0.5, 1], # Spring1
	[0.3, 0.5, 1],
	[0.1, 0.6, 1], # Ete1
	[0.1, 0.6, 1],
	[0.3, 0.5, 1], # Autumn1
	[0.3, 0.5, 1],
	[0.4, 0.4, 1], # Winter1
]

func generate_random_event(new_phase):
	var number = randf()
	if number <= list_proba_events[new_phase][0]:
		return "pluie"
	if number <= list_proba_events[new_phase][1]:
		return "soleil"
	return "rien"

func _on_clock_phase_changed(new_phase):
	# Here on va decider des random events :
	random_event = generate_random_event(new_phase)
	
	if random_event == "pluie":
		$Meteo/Rain.visible = true
		$Meteo/Sun/DirectionalLight2D.energy = 0.8
	else:
		$Meteo/Rain.visible = false
	
	if random_event=="soleil":
		$Meteo/Sun/DirectionalLight2D.energy = 1.3
	else:
		$Meteo/Sun/DirectionalLight2D.energy = 1
		
	
	# Updating every plants
	for i in range(8):
		$plant_spot_container.get_child(i).get_node("plant").next_quarter_of_season(new_phase,random_event)



func _on_plant_spot_calling_contextual_menu():
	print("had")
	var context_menu_scene = load("res://Scenes/contextual_menu.tscn")
	var context_menu_instance = context_menu_scene.instantiate()
	var name = "context_menu_" + str(id_new_context_menu)
	context_menu_instance.name = name
	tab_context_menu.append(name)
	add_child(context_menu_instance)
	get_node(name).open_menu(get_node(name))
	
