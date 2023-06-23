extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int
@export var time_betwen_carac:float = 0.05
@export var time_betwen_dialogue:float = 1
@export var time_after_dialogue:float = 2

var state = "none"

var tutorial_progress = 0

var dialogue_queue = []

var dico_dialogue = {
	
	"Meteo":[true,["Rain make the soil wetter, and strong sunlight dryer."]],
	"Nutrients":[true,["Worms make your soil richer for certain crop to grow."]],
	"Soil":[true,["As you can see, the soil can be dry, moist or soaked.","The closer the soil is from the river, the wetter it becomes."]],
	"Seasons":[true,["Seeds have to be sown in specific parts of seasons","If you sow in the favorite part of the season of the plant, you will harvest more."]],
	"Clock":[true,["You can go forward in time by « clicking » on the seasonal clock."]],
	"Proximity":[true,["Remember that plants influence each other","Some plants like to be close to specific plants, some others don’t"]],
	
	"Lore1":[false,["Hello my grandchild ! So this is it : our society is falling appart…","We must survive by our own ! We are far from everything","Here, take this book"]],
	"Lore2":[false,["There’s not much in it because in the past","we didn’t have to know how to produce food by ourselves","What fools we’ve been…","Anyway, I will teach you the few I know"]],
	"Lore3":[false,["Now look in the book what is the best for the radishes"]],
	"Lore4":[false,["The soil can be poor, average or rich of nutrients.","Plants have a minimum of nutrients necessary to grow.","Open the drawer on your left, pick a bag of radish seeds.","And then plant them on the right type of soil."]],
	"Lore5":[false,["Well done grandchild ! Now let’s wait a little."]],
	"Lore6":[false,["Now harvest the results of your production by « clicking » on the plant and then on « HARVEST »"]],
	"Lore7":[false,["Congratulations ! There, take this. This is some leaks seeds I’ve found in the granary."]],
	"Lore8":[false,["Now I let you work in peace. If you need something you can ask me !","I will come back to you later, bye !"]],
	
	"give_tomatoes":[false,["Well I think you should take those tomatoes seeds, Winter 2 is the best season to plant them !"]],
	"give_pea_and_wheat":[false,["Hello grandchild, look I found multiple new seeds for our garden !"]],
	"give_pumpkin":[false,["Its time to plant some pumpkins so we can have them next Fall season !"]],
	"give_zucchini":[false,["Its rainy today,  becareful and avoid  planting those zucchini seeds on rainy seasons !"]],
}
func player_just_did_something(thing):
	if thing[0] == "planted":
		if thing[1] == "radish":
			pass
	
	if thing[0] == "talk":
		if thing[1] == "Lore1":
			GlobalVariables.update_invertory("radish","seed",1)
			get_tree().root.get_node("home/Game/Encyclopedia").open_on_name("radish")
	
	if thing[0] == "closed_book":
		if tutorial_progress == 0:
			grandpa_talk("Lore2")
			grandpa_talk("Soil")
			grandpa_talk("Meteo")
			grandpa_talk("Lore3")
			grandpa_talk("Lore4")
			tutorial_progress+=1
	
	if thing[0] == "planted":
		if thing[1] == "radish":
			if tutorial_progress == 1:
				tutorial_progress += 1
				grandpa_talk("Lore5")
				grandpa_talk("Clock")
	
	if thing[0] == "skiped_to_next_season":
		if tutorial_progress == 2:
			tutorial_progress += 1
			grandpa_talk("Lore6")
	
	if thing[0] == "harvested":
		if thing[1] == "radish":
			if tutorial_progress == 3:
				tutorial_progress += 1
				grandpa_talk("Lore7")
				GlobalVariables.update_invertory("leek","seed",2)
				grandpa_talk("Lore8")
				
	if thing[0] == "skiped_to_next_season":
		if thing[1] == "winter":
			if tutorial_progress == 4:
				tutorial_progress += 1
				grandpa_talk("give_tomatoes")
				GlobalVariables.update_invertory("tomatoes","seed",2)
			
	
	if GlobalVariables.inventory["tomatoes"]["plant"] > 4 or GlobalVariables.inventory["tomatoes"]["seed"] == 0:
		if tutorial_progress == 5:
			tutorial_progress += 1
			grandpa_talk("give_pea_and_wheat")
			GlobalVariables.update_invertory("pea","seed",2)
			GlobalVariables.update_invertory("wheat","seed",2)
			
	if thing[0] == "skiped_to_next_season":
		if thing[1] == "spring":
			if tutorial_progress == 6:
				tutorial_progress +=1
				grandpa_talk("give_pumpkin")
				GlobalVariables.update_invertory("pumpkin","seed",2)
				
	if thing[0] == "meteo":
		if thing[1] == "pluie":
			if tutorial_progress == 7:
				tutorial_progress += 1
				grandpa_talk("give_zucchini")
				GlobalVariables.update_invertory("zucchini","seed",2)
	
func _on_button_for_grandpa_button_activated(texte_name):
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
	grandpa_talk("Lore1")

func show_buttons():
	for child in $RichTextLabel/VBoxContainer.get_children():
		child.visible = true

func writing_text(text):
	state = "talking"
	$Panel/Label.text = ""
	for letter in text: 
		if state == "speed_talk":
			$Panel/Label.text = text
			return
		$Panel/Label.text += letter
		await get_tree().create_timer(time_betwen_carac).timeout

func grandpa_talk(text):
	dialogue_queue.append(text)
	
func grandpa_start_talk():
	state = "talking"
	$Panel.visible = true
	
	text = dialogue_queue.pop_front()
	
	$GrandpaSFX/AudioStreamPlayer2.play()
	for i in range(len(dico_dialogue[text][1])):
		await writing_text(dico_dialogue[text][1][i])
		state = "pending"
		await get_tree().create_timer(time_betwen_dialogue).timeout #attend prochain dialogue
		$GrandpaSFX/AudioStreamPlayer.play()
	
	state = "none"
	$Panel.visible = false
	
	player_just_did_something(["talk",text])

func _process(delta):
	
	#look if something is in dialogue queue, if so, say if nothing is being said already
	if dialogue_queue != [] and state == "none":
		grandpa_start_talk()
		
	
	if ($RichTextLabel.position.x <= get_local_mouse_position()[0] and get_local_mouse_position()[0] <=  $RichTextLabel.position.x + $RichTextLabel.size.x and $RichTextLabel.position.y <= get_local_mouse_position()[1] and get_local_mouse_position()[1] <= $RichTextLabel.position.y + $RichTextLabel.size.y) :
		$RichTextLabel.visible = true
	else:$RichTextLabel.visible = false


func _on_button_pressed():
	if state == "talking":
		state = "speed_talk"
	
