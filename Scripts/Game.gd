extends Node2D

var id_new_context_menu = 0
var tab_context_menu = []
var random_event = "rien"
@export var nombre_de_plante_consomed_par_quart_de_saison:int = 10
@export var cheat_mode:bool

@onready var context_menu_scene = load("res://Scenes/contextual_menu.tscn")

# Load the custom images for the mouse cursor.
var arrow_game = load("res://Assets/sprites/cursor_game.png")
var number_of_phases_without_event:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	

	if cheat_mode == true:
		for seed in GlobalVariables.inventory:
			GlobalVariables.update_invertory(seed,"seed",10)
		get_node("Dialogue_grand_pere").tutorial_progress = 10
		get_node("Encyclopedia").Pages_unlocked = 14
		
	GlobalVariables.game_state = "playing"
	$background/riviere.play("default")
	$background/AnimatedSprite2D.play()
	Input.set_custom_mouse_cursor(arrow_game)
	pass # Replace with function body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		Input.set_custom_mouse_cursor(arrow_game)
		GlobalVariables.action_picked = "none"

var background_season_animation_dico = [
	"spring", # Spring1
	"spring",
	"summer", # Ete1
	"summer",
	"fall", # Autumn1
	"fall",
	"winter", # Winter1
	"winter", # Winter2
]

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
	if number_of_phases_without_event > 0 :
		number_of_phases_without_event -= 1
		return "rien"
		
	var number = randf()
	if number <= list_proba_events[new_phase][0]:
		return "pluie"
	if number <= list_proba_events[new_phase][1]:
		return "soleil"
	return "rien"

func _on_clock_phase_changed(new_phase):
	
	#On update les objectives :
	GlobalVariables.update_invertory("all","plant",nombre_de_plante_consomed_par_quart_de_saison)
	
	# Envoie un message a grand_pere pour lui dire que le joueur vient de planter une certaine plante
	get_tree().root.get_node("home/Game/Dialogue_grand_pere").player_just_did_something(["skiped_to_next_season",background_season_animation_dico[new_phase]])
	$background/AnimatedSprite2D.animation = background_season_animation_dico[new_phase]
	# Here on va decider des random events :
	GlobalVariables.game_state = "clock"
	random_event = generate_random_event(new_phase)
	
	$Meteo/Nuages.kill_nuages()
	
	if random_event == "pluie":
		$Meteo.go_meteo(3,5)
		$background/Rain.set_visibility_layer_bit(1,1)
		$background/Rain.play("default")
		$Meteo.rain_fade_in()
		$Meteo/Sun/DirectionalLight2D.energy = 0.5
	else:
		$background/Rain.set_visibility_layer_bit(1,0)
		$background/Rain.stop()
		$Meteo.rain_fade_out()
	
	if random_event=="soleil":
		$Meteo/Sun/DirectionalLight2D.energy = 1.2
		$background/DirtBehindRiver.animation = "normal"
	else:
		random_event == "rien"
		$Meteo/Sun/DirectionalLight2D.energy = 1
		$Meteo.go_meteo(0,2)
		$background/DirtBehindRiver.animation = "soaked"

	get_tree().root.get_node("home/Game/Dialogue_grand_pere").player_just_did_something(["meteo",random_event])
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
	
	#wait then turn on the game:
	await get_tree().create_timer(2).timeout
	GlobalVariables.game_state = "playing"


func _on_plant_calling_contextual_menu(plant_node):
	if plant_node.plant_type == "None":
		return
	if not(tab_context_menu==[]):
		if is_instance_valid(tab_context_menu[-1]):
			if tab_context_menu[-1].targeted_plant == plant_node:
				tab_context_menu[-1].queue_free()
				tab_context_menu.pop_front()
			else:
				tab_context_menu[-1].destruction()
				tab_context_menu.pop_front()
	print(tab_context_menu)
	#print(plant_node)
	var context_menu_instance = context_menu_scene.instantiate()
	var name = "context_menu_" + str(id_new_context_menu)
	context_menu_instance.open_menu(plant_node)
	add_child(context_menu_instance)
	tab_context_menu.append(context_menu_instance)
	await get_tree().create_timer(3.0).timeout
	if context_menu_instance in tab_context_menu:
		tab_context_menu.pop_front()
		if is_instance_valid(context_menu_instance):
			context_menu_instance.destruction()

