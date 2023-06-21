extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int
@export var time_betwen_carac:float = 5

var number_of_time_since_last_carac:float = 0
var dialogue_state:String = "off" # on = parle, off= ne parle pas, pending = attend un clic pour continuer le dialogue
var dialogue_progress:int #nombre de caractères écrits
var dialogue_subject:String = "none" #key du dico_dialogue
var dialogue_section:int = 0
var dico_dialogue = {
	"rain": ["Looks like it had rain a loot recently!\nRain makes dirt more damp.", "Be careful with your plants!"]
} # dico de liste de dilogue (un dialogue coupé dans une liste)


func grandpa_come():
	visible = true

func grandpa_leave():
	visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Label.text = text
	$Panel/Label
	grandpa_talk("rain")

func process_input():
	if Input.is_action_just_pressed("left_click"):
		if dialogue_state == "pending":
			dialogue_state = "on"
			$Panel/Label.text = ""
			return
		if dialogue_state == "pending_off":
			dialogue_state = "off"
			grandpa_leave()
			return
		if dialogue_state == "on":
			dialogue_progress = len(dico_dialogue[dialogue_subject][dialogue_section])
			$Panel/Label.text = dico_dialogue[dialogue_subject][dialogue_section]
			reset_dialogue_if_needed()
			return
		

func reset_dialogue_if_needed():
	if dialogue_progress < len(dico_dialogue[dialogue_subject][dialogue_section]):
		return
	
	dialogue_section += 1
	if dialogue_section >= len(dico_dialogue[dialogue_subject]):
		dialogue_state = "pending_off"
		print("dialogue finished")
	else:
		dialogue_progress = 0
		dialogue_state = "pending"


func process_dialogue(delta):
	if dialogue_state != "on":
		return
	number_of_time_since_last_carac += delta
	if number_of_time_since_last_carac > time_betwen_carac:
		$Panel/Label.text += dico_dialogue[dialogue_subject][dialogue_section][dialogue_progress]
		dialogue_progress += 1
		number_of_time_since_last_carac = 0
		reset_dialogue_if_needed()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()
	process_dialogue(delta)


func grandpa_talk(dialogue_name:String):
	$Panel/Label.text = ""
	grandpa_come()
	dialogue_subject = dialogue_name
	dialogue_state = "on"
	dialogue_progress = 0
	dialogue_section = 0
	number_of_time_since_last_carac = 0
	
