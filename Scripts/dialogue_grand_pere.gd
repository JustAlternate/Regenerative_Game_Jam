extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int
@export var time_betwen_carac:float = 0.03
@export var time_betwen_dialogue:float = 2
@export var time_after_dialogue:float = 3
var number_of_time_grandpa_talked = 0
var number_of_time_until_mongolian = 30
var skip

var state = "none"

var tutorial_progress = 0

var dialogue_queue = []

var dico_dialogue = {
	
	"Drawer":[true,["On your left is a drawer where you will store your plant's seeds."]],
	"Meteo":[true,["Rain make the soil wetter, and strong sunlight dries it."]],
	"Nutrients":[true,["Worms make your soil richer for certain crops to grow.","Let you soil rest for a while for it to get nutrients for your plants!"]],
	"Soil":[true,["As you can see, your soil can be dry, moist or soaked.","The closer the soil is from the river, the wetter it becomes.","The soil can be poor, average or rich in nutrients.","Plants require a certain amount of nutrients to grow.",]],
	"Seasons":[true,["Seeds have to be sown in specific parts of seasons.","If you sow in the favorite part of the season of a plant, you will harvest more."]],
	"Clock":[true,["You can go forward in time by clicking on the seasonal clock.","But be careful, each time you click on the seasonal clock, some of your family food ressources are consumed","So make sure to harvest some plants each seasons !"]],
	"Proximity":[true,["Remember that plants influence each other.","Some plants like to be close to specific plants, and some do not like each other."]],
	
	"Lore1":[false,["Hello my grandchild! So, this is it: our society is falling appart...","We must survive on our own! We are a long way from anywhere.","Here, take this book."]],
	"Lore2":[false,["There is not much in it because in the past","we did not have to know how to produce food by ourselves.","We were fools back then...","Anyways, I will teach you what little I know."]],
	"Lore3":[false,["Now look what is best for radishes in the encyclopedia."]],
	"Lore4":[false,["Look on your left is a drawer where you will store your seeds.","Pick some radish seeds and plant them on the right type of soil."]],
	"Lore5":[false,["Well done, grandchild! Now let us wait for a bit."]],
	"Lore6":[false,["Now harvest the results of your production."," Click on the plant and then on HARVEST."]],
	"Lore7":[false,["Congratulations! There, take these. They are leek seeds I have found in the granary."]],
	"Lore8":[false,["Now I will let you work in peace. If you need any advice you can ask me!","I will come back to you later. See ya!"]],
	
	"give_tomatoes":[false,["Well I think you should take those tomato seeds, Winter 2 is the best season to plant them!"]],
	"give_pea_and_wheat":[false,["Hello grandchild! Look, I found multiple new seeds for our garden!","Hopefully they will be enough diversify our food."]],
	"give_pumpkin":[false,["Its time to plant some pumpkins so we can have them next Fall season !"]],
	"give_zucchini":[false,["Its rainy today. Be careful and avoid  planting those zucchini seeds on rainy seasons!"]],
	"give_mint":[false,["Here you can take those mint seeds, it is a fantastic crop to enhance flavor!"]],
	"give_corn":[false,["Finally I found corn seeds. This is a great plant you can grow during Spring 1"]],
	"give_carrot":[false,["I see you are doing great with our garden! Here, take thoses carrots seeds so we can have something new to eat."]],
	"give_le_reste":[false,["Here take those seeds I found. I think I do not have any more seeds.","Well done harvesting all of this! I know you will make good use of these seeds.","I am going to take some rest now."]]
}
func player_just_did_something(thing):
	if thing[0] == "planted":
		if thing[1] == "radish":
			pass
	
	if thing[0] == "talk":
		if thing[1] == "Lore1":
			get_tree().root.get_node("home/Game/Encyclopedia").open_on_name("radish")
	
	if thing[0] == "talk":
		if thing[1] == "Lore3":
			GlobalVariables.update_invertory("radish","seed",1)
			get_tree().root.get_node("home/Game/seed_drawer")._on_open_drawer_button_toggled()

	
	if thing[0] == "closed_book":
		if tutorial_progress == 0:
			grandpa_talk("Lore2")
			tutorial_progress+=1
			
	if thing[0] == "closed_book":
		if tutorial_progress == 1:
			grandpa_talk("Soil")
			grandpa_talk("Meteo")
			grandpa_talk("Lore3")
			grandpa_talk("Lore4")
			tutorial_progress+=1
	
	if thing[0] == "planted":
		if thing[1] == "radish":
			if tutorial_progress == 2:
				tutorial_progress += 1
				grandpa_talk("Lore5")
				grandpa_talk("Clock")
	
	if thing[0] == "skiped_to_next_season":
		if tutorial_progress == 3:
			tutorial_progress += 1
			grandpa_talk("Lore6")
	
	if thing[0] == "harvested":
		if thing[1] == "radish":
			if tutorial_progress == 4:
				$button_skip_tuto.visible = false
				tutorial_progress += 1
				grandpa_talk("Lore7")
				GlobalVariables.update_invertory("leek","seed",2)
				get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
				grandpa_talk("Lore8")
				
	if thing[0] == "skiped_to_next_season":
		if thing[1] == "winter":
			if tutorial_progress == 5:
				tutorial_progress += 1
				grandpa_talk("give_tomatoes")
				get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
				GlobalVariables.update_invertory("tomatoes","seed",2)
			
	
	if GlobalVariables.inventory["tomatoes"]["plant"] > 4 or GlobalVariables.inventory["tomatoes"]["seed"] == 0:
		if tutorial_progress == 6:
			tutorial_progress += 1
			grandpa_talk("give_pea_and_wheat")
			get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=2
			GlobalVariables.update_invertory("pea","seed",2)
			GlobalVariables.update_invertory("wheat","seed",2)
			
	if thing[0] == "skiped_to_next_season":
		if thing[1] == "spring":
			if tutorial_progress == 7:
				tutorial_progress +=1
				grandpa_talk("give_pumpkin")
				get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
				GlobalVariables.update_invertory("pumpkin","seed",2)
				
	if thing[0] == "meteo":
		if thing[1] == "pluie":
			if tutorial_progress == 8:
				tutorial_progress += 1
				grandpa_talk("give_zucchini")
				get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
				GlobalVariables.update_invertory("zucchini","seed",2)
	
	if GlobalVariables.inventory["zucchini"]["plant"] > 4 or GlobalVariables.inventory["zucchini"]["seed"] == 0:
		if tutorial_progress == 9:
			tutorial_progress += 1
			grandpa_talk("give_mint")
			get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
			GlobalVariables.update_invertory("mint","seed",2)
	
	if GlobalVariables.inventory["mint"]["plant"] > 4 or GlobalVariables.inventory["mint"]["seed"] == 0 or GlobalVariables.inventory["pumpkin"]["plant"] > 4 or GlobalVariables.inventory["pumpkin"]["seed"] == 0  :
		if tutorial_progress == 10:
			tutorial_progress += 1
			grandpa_talk("give_corn")
			get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
			GlobalVariables.update_invertory("corn","seed",2)
	
	if thing[0] == "meteo":
		if thing[1] == "soleil":
			if tutorial_progress == 11:
				tutorial_progress += 1
				grandpa_talk("give_carrot")
				get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=1
				GlobalVariables.update_invertory("carrot","seed",2)
	
	if GlobalVariables.inventory["carrot"]["plant"] > 4 or GlobalVariables.inventory["carrot"]["seed"] == 0:
		if tutorial_progress == 12:
			tutorial_progress += 1
			grandpa_talk("give_le_reste")
			get_tree().root.get_node("home/Game/Encyclopedia").Pages_unlocked+=3
			GlobalVariables.update_invertory("ail","seed",2)
			GlobalVariables.update_invertory("vine","seed",2)
			GlobalVariables.update_invertory("thym","seed",2)
	
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
	if not(text in dialogue_queue):
		dialogue_queue.append(text)
		number_of_time_grandpa_talked+=1
	
func grandpa_start_talk():
	state = "talking"
	$Panel.visible = true
	
	text = dialogue_queue.pop_front()
	
	if number_of_time_grandpa_talked < number_of_time_until_mongolian:
		$GrandpaSFX/AudioStreamPlayer2.play()
	else:
		$GrandpaSFX/AudioStreamPlayer3.play()
	for i in range(len(dico_dialogue[text][1])):
		if not(skip):
			await writing_text(dico_dialogue[text][1][i])
			state = "pending"
			await get_tree().create_timer(time_betwen_dialogue).timeout #attend prochain dialogue
			$GrandpaSFX/AudioStreamPlayer.play()
	
	skip = false
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
	
func _on_button_skip_tuto_pressed():
	tutorial_progress = 4
	$button_skip_tuto.visible = false
	dialogue_queue = []
	skip = true
	
