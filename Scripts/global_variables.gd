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

# Spring1 = [1,1] , Summer2 = [2,2], Automn1 = [3,1] , Winter2 = [4,2]
var dico_caracteristique = {
	"bonus_season":{
		"pea":[[4,1],[4,2]],
		"leek":[[2,2]],
		"corn":[[1,1]],
		"wheat":[[4,2]],
		"carrot":[[1,1]],
		"mint":[[1,1]],
		"pumpkin":[[1,2]],
		"tomatoes":[[1,1]],
		"thym":[[3,1]],
		"vine":[[4,1],[4,2]],
		"zucchini":[[1,1]],
		"ail":[],
		"radish":[],
	},
	"season":
	{
		"pea":[[1,1],[3,2]],
		"leek":[[2,1],[2,2],[3,1]],
		"corn":[[1,2]],
		"wheat":[[3,1]],
		"carrot":[[4,2],[1,2]],
		"mint":[[4,2],[1,2]],
		"pumpkin":[[1,1],[2,1]],
		"tomatoes":[[4,2],[1,2]],
		"thym":[[1,1],[1,2]],
		"vine":[[3,2],[1,1]],
		"zucchini":[[4,2],[1,2]],
		"ail":[[3,2],[4,2]],
		"radish":[[4,1],[4,2],[1,1],[1,2],[2,1],[2,2],[3,1]],
	},
	"number_of_phases":{
		"pea":2,
		"leek":3,
		"corn":2,
		"wheat":4,
		"carrot":3,
		"mint":3,
		"pumpkin":3,
		"tomatoes":2,
		"thym":4,
		"vine":4,
		"zucchini":2,
		"ail":3,
		"radish":1,
	},
	"humidities_bonus":{ #0 = sec, 1 = normal, 2 = trempé
		"pea":[1],
		"leek":[1],
		"corn":[2],
		"wheat":[1],
		"carrot":[1,2],
		"mint":[2],
		"pumpkin":[1,2],
		"tomatoes":[2],
		"thym":[0],
		"vine":[1],
		"zucchini":[2],
		"ail":[0],
		"radish":[2],
	},
	"humidities_possible":{ #0 = sec, 1 = normal, 2 = trempé
		"pea":[0,1,2],
		"leek":[0,1,2],
		"corn":[1,2],
		"wheat":[0,1,2],
		"carrot":[1,2,3],
		"mint":[1,2],
		"pumpkin":[1,2,3],
		"tomatoes":[1,2,3],
		"thym":[0,1],
		"vine":[0,1,2],
		"zucchini":[1,2],
		"ail":[0,1],
		"radish":[1,2],
	},
	"minimum_nutriment_values":{ # 0 = pas de nutriment, 1 = un peu nutriment, 2 = tres nutriments
		"pea":0,
		"leek":0,
		"corn":1,
		"wheat":0,
		"carrot":2,
		"mint":2,
		"pumpkin":1,
		"tomatoes":1,
		"thym":0,
		"vine":0,
		"zucchini":2,
		"ail":0,
		"radish":2,
	},
	"sunlight_possible":{
		"pea":[0,1],
		"leek":[0,1,2],
		"corn":[1,2],
		"wheat":[1,2],
		"carrot":[0,1,2],
		"mint":[0,1,2],
		"pumpkin":[0,1],
		"tomatoes":[1,2],
		"thym":[1,2],
		"vine":[1,2],
		"zucchini":[1,2],
		"ail":[1,2],
		"radish":[0,1],
	},
	"sunlight_bonus":{
		"pea":0,
		"leek":1,
		"corn":2,
		"wheat":2,
		"carrot":1,
		"mint":1,
		"pumpkin":0,
		"tomatoes":2,
		"thym":2,
		"vine":2,
		"zucchini":2,
		"ail":2,
		"radish":0,
	},
	"appreciated_adjacents_plants":{
		"pea":[],
		"leek":["carrot","tomatoes"],
		"corn":["pumpkin"],
		"wheat":[],
		"carrot":["tomatoes","leek","pea","radish","ail"],
		"mint":["thym","tomatoes","pea","fadish"],
		"pumpkin":[],
		"tomatoes":["radish"],
		"thym":["mint"],
		"vine":[],
		"zucchini":["pea"],
		"ail":["tomatoes"],
		"radish":["carrot","ail","pea","tomatoes"],
		"None":[]
	},
	"unapreciated_adjacents_plants":{
		"pea":[],
		"leek":["pea"],
		"corn":[],
		"wheat":[],
		"carrot":[],
		"mint":["carrot","corn"],
		"pumpkin":[],
		"tomatoes":[],
		"thym":[],
		"vine":[],
		"zucchini":[],
		"ail":["pea"],
		"radish":[],
		"None":[]
	},
}

var dico_bonus_malus = { #[Bonus si respectée, Bonus si pas respectée]
	"bonus_season":[2,0],
	"season":[0,-4],
	"humidities_bonus":[1,0],
	"humidities_possible":[0,-1],
	"minimum_nutriment_values":[1,"requis-actual"], # ATTENTION NE PAS CHANGER CETTE LIGNE
	"appreciated_adjacents_plants":[1,0],
	"unapreciated_adjacents_plants":[-1,0],
	"sunlight_bonus":[1,0],
	"sunlight_possible":[0,-1],
}



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

