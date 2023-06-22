extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int
@export var time_betwen_carac:float = 0.05
@export var time_betwen_dialogue:float = 3
@export var time_after_dialogue:float = 4
var Talking:bool = false

var dico_dialogue = {
	"Rain":[true,["Your soil gets wet when it rains."]],
	"Sunlight":[true,["The sun dry your soil.","Be carefull when planting for summer!"]],
	"Nutrients":[true,["Worms make your soil richer for certain crop to grow."]],
	"radish_unlock":[false,["unlock radish"]],
	"radish_recolte":[false,["Well done harvesting those radishes!", "Here, you can try planting these peas."]],
	"tomato_unlock":[false,["Take these tomato seeds.", "Now is the perfect time to plant them!"]],
	"wheat_leek_unlock":[false,"I found new seeds, you can have them!"],
	"pumpkin_unlock":[false,"Now's the right time to plant pumpkins!", "Plant these so we will have some for next Halloween!"],
	"zucchini_unlock":[false,"Here, take these zucchini seeds.", "Zucchinis don't grow well with rain, so be careful!"]
}

func _on_button_for_grandpa_button_activated(texte_name):
	if not(Talking):
		grandpa_talk(texte_name)

func maj_buttons():
	
	for elem in $RichTextLabel/VBoxContainer.get_children():
		elem.free()
		
	
	var button_scene = load("res://Scenes/button_for_grandpa.tscn")
	for dialogue_name in dico_dialogue:
		if dico_dialogue[dialogue_name][0]:
			var dialogue_button_instance = button_scene.instantiate()
			dialogue_button_instance.name = ("button_" + dialogue_name)
			dialogue_button_instance.texte = dialogue_name
			dialogue_button_instance.text = dialogue_name
			dialogue_button_instance.button_activated.connect(_on_button_for_grandpa_button_activated)
			$RichTextLabel/VBoxContainer.add_child(dialogue_button_instance)


func _ready():
	maj_buttons()
	show_buttons()
	grandpa_talk("radish_unlock")

func show_buttons():
	for child in $RichTextLabel/VBoxContainer.get_children():
		child.visible = true

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
		await get_tree().create_timer(time_betwen_dialogue).timeout
	
	
	await get_tree().create_timer(time_after_dialogue).timeout
	
	Talking = false
	$Panel.visible = false



func _process(delta):
	if ($RichTextLabel.position.x <= get_local_mouse_position()[0] and get_local_mouse_position()[0] <=  $RichTextLabel.position.x + $RichTextLabel.size.x and $RichTextLabel.position.y <= get_local_mouse_position()[1] and get_local_mouse_position()[1] <= $RichTextLabel.position.y + $RichTextLabel.size.y) :
		$RichTextLabel.visible = true
	else:$RichTextLabel.visible = false
