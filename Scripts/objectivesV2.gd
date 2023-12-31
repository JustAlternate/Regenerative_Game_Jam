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
		"thym":0.1,
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
		"thym":1,
		"vine":0.5,
		"zucchini":0.1,
		"ail":1,
		"radish":0.1,
}

var ressource:float = 50
var diversity:float = 85
var taste:float = 85


var last_eat = ["tomatoes", "thym"]



func recolte(plant, number):
	ressource += number * relation_ressource[plant]
	taste += number * relation_taste[plant]
	
	if not plant in last_eat:
		diversity += 5
		last_eat.pop_front()
		last_eat.append(plant)
		
	ressource = min(ressource,100)
	diversity = min(diversity,100)
	taste = min(taste,100)
	
	$ressource.position.x = 16 + ressource/100*115
	$diversity.position.x = 16 + diversity/100*115
	$taste.position.x = 16 + taste/100*115
	
func next_season():
	compteur +=1
	if compteur == 2:
		ressource = ressource *0.85 - 10
		diversity = diversity *0.90 - 5
		taste = taste *0.95 - 5
		compteur = 0
	$ressource.position.x = 16 + ressource/100*115
	$diversity.position.x = 16 + diversity/100*115
	$taste.position.x = 16 + taste/100*115
	
	if ressource <= 0 or diversity <= 0 or taste <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ressource.position.x = 16 + ressource/100*115
	$diversity.position.x = 16 + diversity/100*115
	$taste.position.x = 16 + taste/100*115


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
