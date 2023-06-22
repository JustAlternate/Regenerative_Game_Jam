extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int
@export var time_betwen_carac:float = 0.03
@export var time_betwen_dialogue:float = 5
var Talking:bool = false

var dialogue_queue = ["rain"] #liste des dialogues à dire(key du dico_dialogue)
	
var dialogue_progress:int #nombre de caractères écrits
var dialogue_section:int = 0
@export var dialogue_unlocked = 1
var dico_dialogue = {
	"pluie":[true,["machin","machin2"]],
	"soleil":[true,["truc","truc2"]]
}

func _ready():
	show_buttons(dialogue_unlocked)
	grandpa_talk("pluie")

func show_buttons(nbr_buttons):
	for i in range(nbr_buttons):
		$RichTextLabel/VBoxContainer.get_child(i).visible = true

func writing_text(text):
	$Panel/Label.text = ""
	for letter in text:
		$Panel/Label.text += letter
		await get_tree().create_timer(time_betwen_carac).timeout

func grandpa_talk(text):
	$Panel.visible = true
	Talking = true
	
	$GrandpaSFX/AudioStreamPlayer2.play()
	for i in range(len(dico_dialogue[text][1])):
		$GrandpaSFX/AudioStreamPlayer.play()
		writing_text(dico_dialogue[text][1][i])
		await get_tree().create_timer(2.0).timeout
	
	Talking = false
	$Panel.visible = false

func _on_button_for_grandpa_button_activated(texte_name):
	if not(Talking):
		grandpa_talk(texte_name)

func _process(delta):
	if ($RichTextLabel.position.x <= get_local_mouse_position()[0] and get_local_mouse_position()[0] <=  $RichTextLabel.position.x + $RichTextLabel.size.x and $RichTextLabel.position.y <= get_local_mouse_position()[1] and get_local_mouse_position()[1] <= $RichTextLabel.position.y + $RichTextLabel.size.y) :
		$RichTextLabel.visible = true
	else:$RichTextLabel.visible = false
