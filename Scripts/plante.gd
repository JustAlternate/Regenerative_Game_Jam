extends Node2D

@export var transition:bool
@export var flip_dirt = false
@export var plant_type = "None" #"carrot", "pea", "leek", "corn", "wheat", "pumpkin", "tomatoes", "thym", "vine", "courgette"

@onready var Icon= load("res://Scenes/contextual_menu.tscn")

var bonus_season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
var season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1

var number_of_phase:int
var humidities_values = [] # 0 = sec, 1 = humide, 2 = très humide
var minimum_nutriment_values = [] # 0 = pas de nutriment, 1 = un peu nutriment, 2 = tres nutriments
var sunlight = [] # 0 = dont want sunlight, 1 = absolutly need sunlight
var sickness = [] # "mildiou", "Oïdium", "Furariose"
var appreciated_adjacents_plants = [] # "carrot", "pea", "leek", "corn", "wheat", "mint", "pumpkin", "tomatoes", "thym", "vine", "courgette"
var unapreciated_adjacents_plants = [] # pareil que au dessus.

signal calling_contextual_menu

@export var humidity_from_river:int
@export var voisin_droit:Node2D = null
@export var voisin_gauche:Node2D = null

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
	"humidities_possible":[0,-2],
	"minimum_nutriment_values":[1,"requis-actual"], # ATTENTION NE PAS CHANGER CETTE LIGNE
	"appreciated_adjacents_plants":[1,0],
	"unapreciated_adjacents_plants":[-1,0],
	"sunlight_bonus":[1,0],
	"sunlight_possible":[0,-1],
}

var state:int
var plant_health:int
var nutriment_value:int
var humidity_value:int # 0 = sec, 1 = mouillé, 2 = trempé
var sunlight_value:int  # 0 = ombre, 1 = soleil

# Called when the node enters the scene tree for the first time.
func _ready():
	change_dirt(humidity_value, "None")
	change_nutrient_visual()
	$dirt.flip_h = flip_dirt
	$sprite.animation = "vide"
	$sign_container.hide()
	state = 0 # 0=graine, 1=plante_1, 2=plant_2, ... -1=morte.
	plant_health = 5
	nutriment_value = 0
	humidity_value = humidity_from_river # 0 = sec, 1= humide, 2 = trempé
	sunlight_value = 1  # 0 = ombre, 1 = ni_l'un_ni_l'autre, 2 = soleil 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_plant(type):
	
	if type != "None":
		if GlobalVariables.inventory[type]["seed"]>0:
			# Envoie un message a grand_pere pour lui dire que le joueur vient de planter une certaine plante
			get_tree().root.get_node("home/Game/Dialogue_grand_pere").player_just_did_something(["planted",type])
			
			# Remove a seed from this plant
			GlobalVariables.update_invertory(type,"seed",-1)
			
			plant_type = type
			$PlantingSFX.play()
			$sprite.animation = plant_type+"_0"
			$sign_container.show()
			$sign_container/plant_icon.animation = plant_type
			plant_health = 5
			state = 0

func harvest_plant():
	
	if plant_type != "None":
		# Envoie un message a grand_pere pour lui dire que le joueur vient d'harvest une certaine plante
		get_tree().root.get_node("home/Game/Dialogue_grand_pere").player_just_did_something(["harvested",plant_type])
		
		# On recolte les seeds
		if plant_health >= 8:
			GlobalVariables.update_invertory(plant_type,"seed",3)
			GlobalVariables.update_invertory(plant_type,"plant",10)
		elif plant_health >= 4:
			GlobalVariables.update_invertory(plant_type,"seed",2)
			GlobalVariables.update_invertory(plant_type,"plant",7)
		else:
			GlobalVariables.update_invertory(plant_type,"seed",1)
			GlobalVariables.update_invertory(plant_type,"plant",4)
		
		plant_type = "None"
		$sprite.animation = "vide"
		$sign_container.hide()
		$HarvestSFX.play_random_sound()

func remove_plant():
	print("removed")
	if state == 0 and plant_type != "None" and plant_health > 0:
		GlobalVariables.update_invertory(plant_type,"seed",1)
	plant_type = "None"	
	$sprite.animation = "vide"
	$sign_container.hide()

func afficher_feeling(name):
	await get_tree().create_timer(0.5).timeout #pour pas que les feeling soient les uns sur les autres
	
	var feeling_icon_scene = Icon
	var feeling_icon_instance = feeling_icon_scene.instantiate()
	feeling_icon_instance.position = Vector2(5,5)
	print("ajout feeling")
	feeling_icon_instance.feeling_type = name
	add_child(feeling_icon_instance)

func show_emotions():
	if plant_health <= 0:
		await afficher_feeling(("head_dead"))
	elif plant_health <= 4:
		await afficher_feeling(("head_sad"))
	elif plant_health <= 8:
		await afficher_feeling(("head_meh"))
	else:
		await afficher_feeling(("head_happy"))

func bonus_malus_seasons(actual_season):
	if state == 0: # Si la plante est une graine
		if actual_season in dico_caracteristique["bonus_season"][plant_type]:
			await afficher_feeling("season+")
			# Si la plante est une graine est quelle est a la bonne bonus saison alors boom, elle prend le bonus.
			plant_health += dico_bonus_malus["bonus_season"][0]
		elif actual_season in dico_caracteristique["season"][plant_type]:
			# Si la plant est dans une season valide
			plant_health += dico_bonus_malus["season"][0]
		else:
			await afficher_feeling("season-")
			# Si la plante est une graine mais quelle n'est pas dans une season valide alors on met le malus.
			plant_health += dico_bonus_malus["season"][1]
func bonus_malus_nutriment(nutriment_value):
	if state == 0: # Si la plante est une graine
		if nutriment_value >= dico_caracteristique["minimum_nutriment_values"][plant_type]:
			await afficher_feeling("nutrient+")
			# On met le bonus.
			plant_health += dico_bonus_malus["minimum_nutriment_values"][0]
		else:
			await afficher_feeling("nutrient-")
			# On met le malus.
			if dico_bonus_malus["minimum_nutriment_values"][1] == "requis-actual":
				plant_health += abs(dico_caracteristique["minimum_nutriment_values"][plant_type] - nutriment_value)
			else:
				plant_health += dico_bonus_malus["minimum_nutriment_values"][1]
func bonus_malus_humidity(humidity_value):
	if humidity_value in dico_caracteristique["humidities_bonus"][plant_type]:
		await afficher_feeling("humidity+")
		plant_health += dico_bonus_malus["humidities_bonus"][0]
	else:
		plant_health += dico_bonus_malus["humidities_bonus"][1]
	
	if not(humidity_value in dico_caracteristique["humidities_bonus"][plant_type]):
		if humidity_value in dico_caracteristique["humidities_possible"][plant_type]:
			plant_health += dico_bonus_malus["humidities_possible"][0]
		else:
			await afficher_feeling("humidity-")
			plant_health += dico_bonus_malus["humidities_possible"][1]

func bonus_malus_sunlight(sunlight_value):
	if sunlight_value == dico_caracteristique["sunlight_bonus"][plant_type]:
		await afficher_feeling("sun+")
		plant_health += dico_bonus_malus["sunlight_bonus"][0]
	else:
		plant_health += dico_bonus_malus["sunlight_bonus"][1]
	
	if not(sunlight_value == dico_caracteristique["sunlight_bonus"][plant_type]):
		if sunlight_value in dico_caracteristique["sunlight_possible"][plant_type]:
			plant_health += dico_bonus_malus["sunlight_possible"][0]
		else:
			await afficher_feeling("sun-")
			plant_health += dico_bonus_malus["sunlight_possible"][1]	
func bonus_malus_voisin(voisin_droit,voisin_gauche):
	#voisin droit
	if voisin_droit in dico_caracteristique["appreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend+")
		plant_health += dico_bonus_malus["appreciated_adjacents_plants"][0]
	else:
		plant_health += dico_bonus_malus["appreciated_adjacents_plants"][1]
	
	if voisin_droit in dico_caracteristique["unapreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend-")
		plant_health += dico_bonus_malus["unapreciated_adjacents_plants"][0]
	else:
		plant_health += dico_bonus_malus["unapreciated_adjacents_plants"][1]
	#voisin gauche
	if voisin_gauche in dico_caracteristique["appreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend+")
		plant_health += dico_bonus_malus["appreciated_adjacents_plants"][0]
	else:
		plant_health += dico_bonus_malus["appreciated_adjacents_plants"][1]

	if voisin_gauche in dico_caracteristique["unapreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend-")
		plant_health += dico_bonus_malus["unapreciated_adjacents_plants"][0]
	else:
		plant_health += dico_bonus_malus["unapreciated_adjacents_plants"][1]

func change_dirt(temp_humidity_value, random_event):
	if temp_humidity_value == 0:
		if transition and not (random_event == "soleil" and humidity_from_river == 0):
			$dirt.animation = "dry_transition"
		else:
			$dirt.animation = "dry"
	if temp_humidity_value == 1:
		if transition:
			$dirt.animation = "normal_transition"
		else:
			$dirt.animation = "normal"
	if temp_humidity_value == 2:
		$dirt.animation = "soak"

func change_nutrient_visual():
	print("nutrient:", nutriment_value)
	$nutrient.animation = str(nutriment_value)
	$nutrient.speed_scale = randf_range(0.5,1)
	$nutrient.play()
	

func next_quarter_of_season(new_phase,random_event):
	var actual_season = [new_phase/2 +1 ,new_phase%2 +1]
	var before_season = [((new_phase+7)%8)/2 +1, ((new_phase+7)%8)%2 +1]
	
	var temp_humidity_value = humidity_value
	var temp_sunlight_value = sunlight_value
	
	var voisin_droit_plant = "None"
	var voisin_gauche_plant = "None"
	
	
	if random_event == "pluie":
		if temp_humidity_value < 2:
			temp_humidity_value += 1
		temp_sunlight_value -= 1
		
	if random_event == "soleil":
		temp_sunlight_value += 1
		if temp_humidity_value > 0:
			temp_humidity_value -= 1
	
	change_dirt(temp_humidity_value, random_event)
	change_nutrient_visual()
	if plant_type == "None":
		# Si la terre est vide, on lui fait regagner des nutriments a chaque passage de quarter of season.
		if nutriment_value < 2:
			nutriment_value += 1
	else:
		
		if state == 0 and nutriment_value > 0:
			# Si on a posé une graine au quarter de season précédent, alors on baisse le nutriment de la terre de 1.
			nutriment_value -= 1
		
		if random_event == "pluie":
			if temp_humidity_value < 2:
				temp_humidity_value += 1
			temp_sunlight_value -= 1
			
		if random_event == "soleil":
			temp_sunlight_value += 1
			if temp_humidity_value > 0:
				temp_humidity_value -= 1
		
		if state < dico_caracteristique["number_of_phases"][plant_type]:
			# Alors la plante peut encore poussé :
			
			# On applique les bonus / malus sur la vie de le a plante.
			
			print("plant_health_avant_bonus_malus : "+str(plant_health))
			await bonus_malus_humidity(temp_humidity_value)
			await bonus_malus_sunlight(temp_sunlight_value)
			if state == 0:
				await bonus_malus_seasons(before_season)
				await bonus_malus_nutriment(nutriment_value)
			
			if voisin_droit != null:
				voisin_droit_plant = voisin_droit.plant_type
			if voisin_gauche != null:
				voisin_gauche_plant = voisin_gauche.plant_type
			
			await bonus_malus_voisin(voisin_droit_plant,voisin_gauche_plant)
			print("plant_health_apres_bonus_malus : "+str(plant_health))
			
			await show_emotions()
			
			# On fait poussé la plante si elle est toujours vivante :
			if plant_health > 0:
				state += 1
				$sprite.animation = plant_type+"_"+str(state)
				$sign_container.hide()
			else:
				# Sinon on la remove pour l'instant.
				remove_plant()
				print("la plante est morte")
				
	if plant_type != "None":
		print("==================================")
		print("voisin_droit : "+str(voisin_droit_plant))
		print("voisin_gauche : "+str(voisin_gauche_plant))
		print("actual_season : "+str(actual_season))
		print("state : "+str(state))
		print("plant_type : "+str(plant_type))
		print("plant_health : "+str(plant_health))
		print("nutriment_value : "+str(nutriment_value))
		print("temp_humidity_value : "+str(temp_humidity_value))
		print("temp_sunlight_value : "+str(temp_sunlight_value))
		print("==================================")

func _on_button_pressed():
	#print("pressed")
	if GlobalVariables.game_state == "clock":
		return #pas le droit
	if GlobalVariables.action_picked == "seed" and plant_type == "None":
		add_plant(GlobalVariables.seed_picked)
	else:
		calling_contextual_menu.emit(self)
