extends Node2D

@export var plant_type = "None" #"carrot", "pea", "leek", "corn", "wheat", "pumpkin", "tomatoes", "thym", "vine", "courgette"
var bonus_season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
var season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
@export var damage_out_seasons = 3
var number_of_phase:int
var humidities_values = [] # 0 = sec, 1 = humide, 2 = très humide
var minimum_nutriment_values = [] # 0 = pas de nutriment, 1 = un peu nutriment, 2 = tres nutriments
var sunlight = [] # 0 = dont want sunlight, 1 = absolutly need sunlight
var sickness = [] # "mildiou", "Oïdium", "Furariose"
var appreciated_adjacents_plants = [] # "carrot", "pea", "leek", "corn", "wheat", "mint", "pumpkin", "tomatoes", "thym", "vine", "courgette"
var unapreciated_adjacents_plants = [] # pareil que au dessus.

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
		"courgette":[[1,1]],
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
		"courgette":[[4,2],[1,2]],
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
		"courgette":2,
		"ail":3,
		"radish":1,
	},
	"humidities_values":{
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
		"ail":[0],
		"radish":[2],
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
		"ail":0,
		"radish":2,
	},
	"sunlight":{
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
		"ail":2,
		"radish":0,
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
		"ail":["tomatoes"],
		"radish":["carrot","ail","pea","tomatoes"],
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
		"ail":["pea"],
		"radish":[],
	},
	
}

var dico_bonus_malus = {
	"bonus_season":[2,0],
	"season":[0,-4],
	"humidities_values":[1,"requis-actual"], # ATTENTION NE PAS CHANGER CETTE LIGNE
	"minimum_nutriment_values":[1,"requis-actual"], # ATTENTION NE PAS CHANGER CETTE LIGNE
	"sunlight":[1,-2], 
	"appreciated_adjacents_plants":[1,0],
	"unapreciated_adjacents_plants":[1,0],
}

var state:int
var plant_health:int
var nutriment_value:int

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.animation = "vide"
	position.x = 0
	position.y = 0
	state = 0 # 0=graine, 1=plante_1, 2=plant_2, ... -1=morte.
	plant_health = 5
	nutriment_value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_plant(type):
	if type != "None":
		plant_type = type
		$sprite.animation = plant_type+"_0"
		plant_health = 5
		state = 0

func remove_plant():
	if not plant_type == "None":
		plant_type = "None"	
		$sprite.animation = "vide"
	
	
func bonus_malus_seasons(actual_season):
	if state == 0: # Si la plante est une graine
		if actual_season in dico_caracteristique["bonus_season"][plant_type]:
			# Si la plante est une graine est quelle est a la bonne bonus saison alors boom, elle prend le bonus.
			plant_health += dico_bonus_malus["bonus_season"][0]
		
		else:
			# On met le malus du bonus season
			plant_health += dico_bonus_malus["bonus_season"][1]
		
		if actual_season in dico_caracteristique["season"][plant_type]:
			# Si la plant est dans une season valide
			plant_health += dico_bonus_malus["season"][0]
		else:
			# Si la plante est une graine mais quelle n'est pas dans une season valide alors on met le malus.
			plant_health += dico_bonus_malus["season"][1]

func bonus_malus_nutriment(nutriment_value):
	if state == 0: # Si la plante est une graine
		if nutriment_value >= dico_caracteristique["minimum_nutriment_values"][plant_type]:
			# On met le bonus.
			plant_health += dico_bonus_malus["minimum_nutriment_values"][0]
		else:
			# On met le malus.
			if dico_bonus_malus["minimum_nutriment_values"][1] == "requis-actual":
				plant_health += abs(dico_caracteristique["minimum_nutriment_values"][plant_type] - nutriment_value)
			else:
				plant_health += dico_bonus_malus["minimum_nutriment_values"][1]




func next_quarter_of_season(new_phase):
	var actual_season = [new_phase/2 +1 ,new_phase%2 +1]
	
	if plant_type == "None":
		# Si la terre est vide, on lui fait regagner des nutriments a chaque passage de quarter of season.
		if nutriment_value <= 2:
			nutriment_value += 1
	
	else:
		if state == 0:
			# Si on a posé une graine au quarter de season précédent, alors on baisse le nutriment de la terre de 1.
			nutriment_value -= 1
		
		if state < dico_caracteristique["number_of_phases"][plant_type]:
			# Alors la plante peut encore poussé :
			
			# On applique les bonus / malus sur la vie de le a plante.
			
			bonus_malus_seasons(actual_season)
			#bonus_malus_sunlight(sunlight)
			bonus_malus_nutriment(nutriment_value)
			
			# On fait poussé la plante si elle est toujours vivante :
			if plant_health > 0:
				state += 1
				$sprite.animation = plant_type+"_"+str(state)
			else:
				# Sinon on la remove pour l'instant.
				remove_plant()
				
	if plant_type != "None":
		print("actual_season : "+str(actual_season))
		print("state : "+str(state))
		print("plant_type : "+str(plant_type))
		print("plant_health : "+str(plant_health))
		print("nutriment_value : "+str(nutriment_value))
