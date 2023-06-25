extends Node2D

var compteur = -1

var relation_ressource = {
		"pea":1,
		"leek":1,
		"corn":1,
		"wheat":1,
		"carrot":1,
		"mint":0.1,
		"pumpkin":1,
		"tomatoes":1,
		"thyme":0.1,
		"vine":1,
		"zucchini":1,
		"ail":0.5,
		"radish":0.5,
}

var relation_taste = {
		"pea":0.1,
		"leek":0.1,
		"corn":0.1,
		"wheat":0.1,
		"carrot":0.1,
		"mint":1,
		"pumpkin":0.1,
		"tomatoes":0.1,
		"thyme":1,
		"vine":0.5,
		"zucchini":0.1,
		"ail":1,
		"radish":0.1,
}

var ressource:float = 50
var diversity:float = 50
var taste:float = 50
var activation_state = 0 # 0 = seulement ressource, 1 = ressource + diversity, 2 = tout

var last_eat = ["tomatoes", "thyme"]

func start_objective_diversity(start_amount = 50):
	$sign_diversity.show()
	diversity = start_amount
	activation_state = 1

func start_objective_taste(start_amount = 50):
	$sign_taste.show()
	diversity = start_amount
	activation_state = 2

func recolte(plant, number):
	ressource += number * relation_ressource[plant] * GlobalVariables.dico_caracteristique["number_of_phases"][plant]
	ressource = min(ressource,100)
	$sign_ressource/cursor_ressource.position.x = ressource/100*115
	if activation_state >= 1:
		if not plant in last_eat:
			diversity += 5
			last_eat.pop_front()
			last_eat.append(plant)
			diversity = min(diversity, 100)
			$sign_diversity/cursor_diversity.position.x = diversity/100*115
	if activation_state >= 2:
		taste += number * relation_taste[plant] * GlobalVariables.dico_caracteristique["number_of_phases"][plant]
		taste = min(taste, 100)
		$sign_taste/cursor_taste.positio.x = taste/100*115
	
func next_season():
	compteur +=1
	if compteur == 2:
		ressource = ressource *0.85 - 10
		$sign_ressource/cursor_ressource.position.x = ressource/100*115
		if activation_state >= 1:
			diversity = diversity *0.90 - 5
			$sign_diversity/cursor_diversity.position.x = diversity/100*115
			if activation_state >= 2:
				taste = taste *0.95 - 5
				$sign_taste/cursor_taste.position.x = taste/100*115
		
		compteur = 0
		if ressource <= 0 or diversity <= 0 or taste <= 0:
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$sign_ressource/cursor_ressource.position.x = ressource/100*115
	$sign_diversity/cursor_diversity.position.x = diversity/100*115
	$sign_taste/cursor_taste.position.x = taste/100*115


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
