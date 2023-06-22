extends Node2D

var id_new_context_menu = 0
var tab_context_menu = []
var random_event = "rien"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(GlobalVariables.inventory)
	pass
	
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
	
	$Meteo/Nuages.kill_nuages()
	
	if random_event == "pluie":
		$Meteo.go_meteo(3,5)
		$Meteo/Rain.visible = true
		$Meteo.rain_fade_in()
		$Meteo/Sun/DirectionalLight2D.energy = 0.8
	else:
		$Meteo/Rain.visible = false
		$Meteo.rain_fade_out()
	
	if random_event=="soleil":
		$Meteo/Sun/DirectionalLight2D.energy = 1.3
	else:
		$Meteo/Sun/DirectionalLight2D.energy = 1
		$Meteo.go_meteo(0,2)
		
	# Updating every plants
	for i in range(8):
		$plant_spot_container.get_child(i).next_quarter_of_season(new_phase,random_event)
	
	if new_phase == 0:
		$"/root/PersistentSfx/WinterMusic".music_stop()
		$"/root/PersistentSfx/SpringMusic".play_song_phase1()
	elif new_phase == 1:
		$"/root/PersistentSfx/SpringMusic".play_song_phase2()
	elif new_phase == 2:
		$"/root/PersistentSfx/SpringMusic".music_stop()
		$"/root/PersistentSfx/SummerMusic".play_song_phase1()
	elif new_phase == 3:
		$"/root/PersistentSfx/SummerMusic".play_song_phase2()
	elif new_phase == 4:
		$"/root/PersistentSfx/SummerMusic".music_stop()
		$"/root/PersistentSfx/FallMusic".play_song_phase1()
	elif new_phase == 5:
		$"/root/PersistentSfx/FallMusic".play_song_phase2()
	elif new_phase == 6:
		$"/root/PersistentSfx/FallMusic".music_stop()
		$"/root/PersistentSfx/WinterMusic".play_song_phase1()
	elif new_phase == 7:
		$"/root/PersistentSfx/WinterMusic".play_song_phase2()


func _on_plant_calling_contextual_menu(plant_node):
	if plant_node.plant_type == "None":
		return
	if not(tab_context_menu==[]):
		tab_context_menu[-1].free()
		tab_context_menu.pop_front()
	print(tab_context_menu)
	#print(plant_node)
	var context_menu_scene = load("res://Scenes/contextual_menu.tscn")
	var context_menu_instance = context_menu_scene.instantiate()
	var name = "context_menu_" + str(id_new_context_menu)
	context_menu_instance.name = name
	add_child(context_menu_instance)
	get_node(name).open_menu(plant_node)
	tab_context_menu.append(context_menu_instance)
	await get_tree().create_timer(3.0).timeout
	if context_menu_instance in tab_context_menu:
		tab_context_menu.pop_front()
		context_menu_instance.free()

