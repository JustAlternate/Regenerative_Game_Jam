extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int
@export var time_betwen_carac:float = 0.05
@export var time_betwen_dialogue:float = 5

var time_counter:float = 0
var dialogue_state:String = "off" # on = parle, off= ne parle pas, pending = attend un clic pour continuer le dialogue
var dialogue_queue:Array = [] #liste des dialogues à dire(key du dico_dialogue)

var dialogue_progress:int #nombre de caractères écrits
var dialogue_section:int = 0
var dico_dialogue = {
	"rain": ["Looks like it had rain a loot recently!\nRain makes dirt more damp.", "Be careful with your plants!"]
} # dico de liste de dilogue (un dialogue coupé dans une liste)


func grandpa_come(): #a appeler seulement quand le grandpa parle
	GlobalVariables.game_state = "grandpa"
	visible = true

func grandpa_leave():
	GlobalVariables.game_state = "playing"
	visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Label.text = text
	$Panel/Label
	grandpa_talk("rain")
	grandpa_talk("rain")


func next_dialogue_if_needed():
	print("len:", len(dialogue_queue))
	if len(dialogue_queue) >= 1:
		dialogue_state = "on"
		$Panel/Label.text = ""
		dialogue_progress = 0
		dialogue_section = 0
	else:
		dialogue_state = "off"
		grandpa_leave()


func process_input():
	if Input.is_action_just_pressed("left_click"):
		if dialogue_state == "pending":
			dialogue_state = "on"
			$Panel/Label.text = ""
			return
		if dialogue_state == "pending_off":
			next_dialogue_if_needed()
			return
		if dialogue_state == "on":
			dialogue_progress = len(dico_dialogue[dialogue_queue[0]][dialogue_section])
			$Panel/Label.text = dico_dialogue[dialogue_queue[0]][dialogue_section]
			reset_dialogue_if_needed()
			return
		

func reset_dialogue_if_needed():
	if dialogue_progress < len(dico_dialogue[dialogue_queue[0]][dialogue_section]):
		return
	
	dialogue_section += 1
	if dialogue_section >= len(dico_dialogue[dialogue_queue[0]]):
		dialogue_state = "pending_off"
		dialogue_queue.pop_front()
		print("dialogue finished")
	else:
		dialogue_progress = 0
		dialogue_state = "pending"


func process_dialogue(delta):
	if dialogue_state == "on":
		time_counter += delta
		if time_counter > time_betwen_carac:
			$Panel/Label.text += dico_dialogue[dialogue_queue[0]][dialogue_section][dialogue_progress]
			dialogue_progress += 1
			time_counter = 0
			reset_dialogue_if_needed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()
	process_dialogue(delta)


func grandpa_talk(dialogue_name:String):
	
	dialogue_queue.append(dialogue_name)
	if len(dialogue_queue) == 1:
		$Panel/Label.text = ""
		grandpa_come()
		dialogue_state = "on"
		dialogue_progress = 0
		dialogue_section = 0
		time_counter = 0
	
