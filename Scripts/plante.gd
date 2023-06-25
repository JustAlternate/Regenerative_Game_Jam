extends Node2D

@export var transition:bool
@export var flip_dirt = false
@export var plant_type = "None" #"carrot", "pea", "leek", "corn", "wheat", "pumpkin", "tomatoes", "thyme", "vine", "courgette"

@onready var Icon= load("res://Scenes/feeling_icon.tscn")

var bonus_season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1
var season = [] # (0,1) = Summer1, (1,2) = spring2, (2,1) = winter1, (3,1) = autumn1

var number_of_phase:int
var humidities_values = [] # 0 = sec, 1 = humide, 2 = très humide
var minimum_nutriment_values = [] # 0 = pas de nutriment, 1 = un peu nutriment, 2 = tres nutriments
var sunlight = [] # 0 = dont want sunlight, 1 = absolutly need sunlight
var sickness = [] # "mildiou", "Oïdium", "Furariose"
var appreciated_adjacents_plants = [] # "carrot", "pea", "leek", "corn", "wheat", "mint", "pumpkin", "tomatoes", "thyme", "vine", "courgette"
var unapreciated_adjacents_plants = [] # pareil que au dessus.

signal calling_contextual_menu

@export var humidity_from_river:int
@export var voisin_droit:Node2D = null
@export var voisin_gauche:Node2D = null


var state:int
var plant_health:int
var nutriment_value:int
var humidity_value:int # 0 = sec, 1 = mouillé, 2 = trempé
var sunlight_value:int = 1  # 0 = ombre, 1 = soleil

var voisin_droit_plant:String
var voisin_gauche_plant:String
var voisin_droit_state:int
var voisin_gauche_state:int


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
		
		$HarvestSFX.play_random_sound()
		remove_plant()

func remove_plant():
	if plant_type != "None":
		if state == 0 and plant_health > 0:
			GlobalVariables.update_invertory(plant_type,"seed",1)
		if plant_type=="vine":
			$sprite/pour_vine_1.visible = false
			$sprite/pour_vine_2.visible = false
			$sprite/vine_final.visible = false
		
		plant_type = "None"	
		$sprite.animation = "vide"
		$sign_container.hide()

func afficher_feeling(name):
	await get_tree().create_timer(0.5).timeout #pour pas que les feeling soient les uns sur les autres
	
	var feeling_icon_scene = Icon
	var feeling_icon_instance = feeling_icon_scene.instantiate()
	feeling_icon_instance.position = Vector2(5,5)
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
		if actual_season in GlobalVariables.dico_caracteristique["bonus_season"][plant_type]:
			await afficher_feeling("season+")
			# Si la plante est une graine est quelle est a la bonne bonus saison alors boom, elle prend le bonus.
			plant_health += GlobalVariables.dico_bonus_malus["bonus_season"][0]
		elif actual_season in GlobalVariables.dico_caracteristique["season"][plant_type]:
			# Si la plant est dans une season valide
			plant_health += GlobalVariables.dico_bonus_malus["season"][0]
		else:
			await afficher_feeling("season-")
			# Si la plante est une graine mais quelle n'est pas dans une season valide alors on met le malus.
			plant_health += GlobalVariables.dico_bonus_malus["season"][1]
func bonus_malus_nutriment(nutriment_value):
	if state == 0: # Si la plante est une graine
		if nutriment_value >= GlobalVariables.dico_caracteristique["minimum_nutriment_values"][plant_type]:
			await afficher_feeling("nutrient+")
			# On met le bonus.
			plant_health += GlobalVariables.dico_bonus_malus["minimum_nutriment_values"][0]
		else:
			await afficher_feeling("nutrient-")
			# On met le malus.
			if GlobalVariables.dico_bonus_malus["minimum_nutriment_values"][1] == "requis-actual":
				plant_health += abs(GlobalVariables.dico_caracteristique["minimum_nutriment_values"][plant_type] - nutriment_value)
			else:
				plant_health += GlobalVariables.dico_bonus_malus["minimum_nutriment_values"][1]
func bonus_malus_humidity(humidity_value):
	if humidity_value in GlobalVariables.dico_caracteristique["humidities_bonus"][plant_type]:
		await afficher_feeling("humidity+")
		plant_health += GlobalVariables.dico_bonus_malus["humidities_bonus"][0]
	else:
		plant_health += GlobalVariables.dico_bonus_malus["humidities_bonus"][1]
	
	if not(humidity_value in GlobalVariables.dico_caracteristique["humidities_bonus"][plant_type]):
		if humidity_value in GlobalVariables.dico_caracteristique["humidities_possible"][plant_type]:
			plant_health += GlobalVariables.dico_bonus_malus["humidities_possible"][0]
		else:
			await afficher_feeling("humidity-")
			plant_health += GlobalVariables.dico_bonus_malus["humidities_possible"][1]

func bonus_malus_sunlight(sunlight):
	var temp_sunlight_value = sunlight
	if ((voisin_droit_plant=="vine" and voisin_droit_state > 2) or (voisin_gauche_plant=="vine" and voisin_gauche_state > 3)) and temp_sunlight_value>0:
		temp_sunlight_value -= 1
	if temp_sunlight_value == GlobalVariables.dico_caracteristique["sunlight_bonus"][plant_type]:
		await afficher_feeling("sun+")
		plant_health += GlobalVariables.dico_bonus_malus["sunlight_bonus"][0]
	else:
		if temp_sunlight_value in GlobalVariables.dico_caracteristique["sunlight_possible"][plant_type]:
			plant_health += GlobalVariables.dico_bonus_malus["sunlight_possible"][0]
		else:
			await afficher_feeling("sun-")
			plant_health += GlobalVariables.dico_bonus_malus["sunlight_possible"][1]	
func bonus_malus_voisin(voisin_droit,voisin_gauche):
	#voisin droit
	if voisin_droit in GlobalVariables.dico_caracteristique["appreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend+")
		plant_health += GlobalVariables.dico_bonus_malus["appreciated_adjacents_plants"][0]
	else:
		plant_health += GlobalVariables.dico_bonus_malus["appreciated_adjacents_plants"][1]
	
	if voisin_droit in GlobalVariables.dico_caracteristique["unapreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend-")
		plant_health += GlobalVariables.dico_bonus_malus["unapreciated_adjacents_plants"][0]
	else:
		plant_health += GlobalVariables.dico_bonus_malus["unapreciated_adjacents_plants"][1]
	#voisin gauche
	if voisin_gauche in GlobalVariables.dico_caracteristique["appreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend+")
		plant_health += GlobalVariables.dico_bonus_malus["appreciated_adjacents_plants"][0]
	else:
		plant_health += GlobalVariables.dico_bonus_malus["appreciated_adjacents_plants"][1]

	if voisin_gauche in GlobalVariables.dico_caracteristique["unapreciated_adjacents_plants"][plant_type]:
		await afficher_feeling("friend-")
		plant_health += GlobalVariables.dico_bonus_malus["unapreciated_adjacents_plants"][0]
	else:
		plant_health += GlobalVariables.dico_bonus_malus["unapreciated_adjacents_plants"][1]

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
	$nutrient.animation = str(nutriment_value)
	$nutrient.speed_scale = randf_range(0.5,1)
	$nutrient.play()

func mettre_a_jour_voisins():
		if voisin_droit != null:
			voisin_droit_plant = voisin_droit.plant_type
			voisin_droit_state = voisin_droit.state
		else: 
			voisin_droit_plant = "None"
			voisin_droit_state = 0
		if voisin_gauche != null:
			voisin_gauche_plant = voisin_gauche.plant_type
			voisin_gauche_state = voisin_gauche.state
		else: 
			voisin_gauche_plant = "None"
			voisin_gauche_state = 0


func next_quarter_of_season(new_phase,random_event):
	var actual_season = [new_phase/2 +1 ,new_phase%2 +1]
	var before_season = [((new_phase+7)%8)/2 +1, ((new_phase+7)%8)%2 +1]
	
	var temp_humidity_value = humidity_value
	var temp_sunlight_value = sunlight_value
	
	
	if random_event == "pluie":
		if temp_humidity_value < 2:
			temp_humidity_value += 1
		temp_sunlight_value -= 1
		
	if random_event == "soleil":
		temp_sunlight_value += 1
		if temp_humidity_value > 0:
			temp_humidity_value -= 1
	
	change_dirt(temp_humidity_value, random_event)
	if plant_type == "None":
		# Si la terre est vide, on lui fait regagner des nutriments a chaque passage de quarter of season.
		if nutriment_value < 2:
			nutriment_value += 1
			change_nutrient_visual()
		return

	
	if state < GlobalVariables.dico_caracteristique["number_of_phases"][plant_type]:
		# Alors la plante peut encore poussé :
		
		# On applique les bonus / malus sur la vie de le a plante.
		mettre_a_jour_voisins()

			
		print("plant_health_avant_bonus_malus : "+str(plant_health))
		await bonus_malus_humidity(temp_humidity_value)
		await bonus_malus_sunlight(temp_sunlight_value)
		if state == 0:
			await bonus_malus_seasons(before_season)
			await bonus_malus_nutriment(nutriment_value)
		if state == 0 and nutriment_value > 0:
			# Si on a posé une graine au quarter de season précédent, alors on baisse le nutriment de la terre de 1.
			nutriment_value -= 1
			change_nutrient_visual()
		
		await bonus_malus_voisin(voisin_droit_plant,voisin_gauche_plant)
		print("plant_health_apres_bonus_malus : "+str(plant_health))
		
		await show_emotions()
		
		# On fait poussé la plante si elle est toujours vivante :
		if plant_health > 0:
			state += 1
			if plant_type == "vine":
				$sprite.animation = plant_type+"_"+str(min(2,state))
				if state == 2:
					$sprite/pour_vine_1.visible = true
					$sprite/pour_vine_1.animation="vine_top1_1"
				elif state == 3:
					$sprite/pour_vine_1.animation="vine_top1_2"
				elif state == 4:
					$sprite/pour_vine_2.visible = true
					$sprite/pour_vine_2.animation="vine_top2_1"
				elif state == 5:
					$sprite/pour_vine_2.animation="vine_top2_2"
					$sprite/vine_final.visible = true
					$sprite/vine_final.animation="vine_top3_1"
				elif state == 6:
					$sprite/vine_final.animation="vine_top3_2"
			else:
				$sprite.animation = plant_type+"_"+str(state)
			$sign_container.hide()
		else:
			# Sinon on la remove pour l'instant.
			remove_plant()
			print("la plante est morte")
				
func _on_button_pressed():
	if GlobalVariables.game_state == "clock":
		return #pas le droit
	if GlobalVariables.action_picked == "seed" and plant_type == "None":
		add_plant(GlobalVariables.seed_picked)
	else:
		calling_contextual_menu.emit(self)
