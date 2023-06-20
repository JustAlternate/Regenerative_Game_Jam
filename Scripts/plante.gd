extends Node2D

@export var plant_type = "None" #"carrot", "pea", "leek", "corn", "wheat", "pumpkin", "tomatoes", "thym", "vine", "courgette"
var bonus_season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
var required_season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
var number_of_phase:int
var required_humidities_values = [] # 0 = sec, 1 = humide, 2 = très humide
var minimum_nutriment_values = [] # 0 = pas de nutriment, 1 = un peu nutriment, 2 = tres nutriments
var required_sunlight = [] # 0 = vulnerable to sun, 1 = dont care about sunlight, 2 = absolutly need sunlight
var sickness = [] # "mildiou", "Oïdium", "Furariose"
var appreciated_adjacents_plants = [] # "carrot", "pea", "leek", "corn", "wheat", "mint", "pumpkin", "tomatoes", "thym", "vine", "courgette"
var unapreciated_adjacents_plants = [] # pareil que au dessus.

var dico_caracteristique = {
	"bonus_season":
	{# (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
		"pea":[[2,1],[2,0]],
		"leek":[[1,2],[0,1]],
		"corn":[[1,1]],
		"wheat":[[2,2]],
		"carrot":[[1,1]],
		"mint":[[1,1]],
		"pumpkin":[[1,2]],
		"tomatoes":[[1,1]],
		"thym":[[3,1]],
		"vine":[[2,1],[2,2]],
		"courgette":[[1,1]],
	},
	"required_season":
	{# (0,1] = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
		"pea":[[1,1],[0,2]],
		"leek":[[3,2],[0,2]],
		"corn":[[1,2]],
		"wheat":[[3,1]],
		"carrot":[[2,2],[1,2]],
		"mint":[[2,2],[1,2]],
		"pumpkin":[[1,1],[0,1]],
		"tomatoes":[[2,2],[1,2]],
		"thym":[[3,1]],
		"vine":[[3,2],[1,1]],
		"courgette":[[2,2],[1,2]],
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
		"courgette":2,
	},
	"required_humidities_values":{ # 0 = sec, 1 = humide, 2 = très humide
		"pea":[1],
		"leek":[0,1],
		"corn":[2],
		"wheat":[1],
		"carrot":[1,2],
		"mint":[2],
		"pumpkin":[1,2],
		"tomatoes":[1,2],
		"thym":[0],
		"vine":[1],
		"courgette":[2],
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
		"courgette":2,
	},
	"required_sunlight":{
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
		"courgette":2,
	},
	"appreciated_adjacents_plants":{
		"pea":[],
		"leek":["carrot","tomatoes"],
		"corn":["pumpkin"],
		"wheat":[],
		"carrot":["tomatoes","leek","pea"],
		"mint":["thym","tomatoes","pea"],
		"pumpkin":[],
		"tomatoes":[],
		"thym":["mint"],
		"vine":[],
		"courgette":["pea"],
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
		"courgette":[],
	},
	
}

var state:int

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.animation = "vide"
	position.x = 0
	position.y = 0
	state = 0 # 0=graine, 1=plante_1, 2=plant_2, -1=morte.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_plant(type):
	if type != "None":
		plant_type = type
		$sprite.animation = plant_type+"_0"

func remove_plant():
	if not plant_type == "None":
		state = 0
		plant_type = "None"	
		$sprite.animation = "vide"
	
func next_quarter_of_season():
	if not plant_type == "None":
		print("updating state")
		if state < dico_caracteristique["number_of_phases"][plant_type]:
			state += 1
			$sprite.animation = plant_type+"_"+str(state)
