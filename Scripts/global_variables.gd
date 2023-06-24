extends Node

var action_picked = "Graine"
var seed_picked = "carrot"
var game_state = "playing"

var master_volume = -2
var music_volume = -2
var sfx_volume = -2

var ressource:float
var divesity:float
var taste:float





func update_invertory(plant,type,number): #pea, seed, 4  ou  carott, plant, -4
	# ajout dans inventory :
	if type == "seed":
		GlobalVariables.inventory[plant]["seed"] += number
		get_tree().root.get_node("home/Game/seed_drawer/HBoxContainer/GridContainer/Container_"+plant).update_number_seed()

	if type == "plant":
		if plant == "all":
			get_tree().root.get_node("home/Game/Objectives").next_season()
		else:
			GlobalVariables.inventory[plant]["plant"] += number
			get_tree().root.get_node("home/Game/Objectives").recolte(plant, number)
		
	pass
	



var inventory = {
	"pea": {"seed": 0, "plant": 0},
	"leek":{"seed": 0, "plant": 0},
	"corn":{"seed": 0, "plant": 0},
	"wheat":{"seed": 0, "plant": 0},
	"carrot":{"seed": 0, "plant": 0},
	"mint":{"seed": 0, "plant": 0},
	"pumpkin":{"seed": 0, "plant": 0},
	"tomatoes":{"seed": 0, "plant": 0},
	"thym":{"seed": 0, "plant": 0},
	"vine":{"seed": 0, "plant": 0},
	"zucchini":{"seed": 0, "plant": 0},
	"ail":{"seed": 0, "plant": 0},
	"radish":{"seed": 1, "plant": 0}
}

