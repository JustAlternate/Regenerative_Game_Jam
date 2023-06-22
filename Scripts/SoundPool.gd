extends Node

var sfx_list = []
var nb_sfx = 0
var random_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# On récupère tous les enfants de la Node et si c'est un AudioStreamPlayer, on l'ajoute à liste_sfx
	for child in get_children():
		if child is AudioStreamPlayer:
			sfx_list.append(child)
	nb_sfx = sfx_list.size()

func play_random_sound():
	if nb_sfx != 0:
		random_number = randi() % nb_sfx
		sfx_list[random_number].play()
