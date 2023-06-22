extends Node2D

var actual_page_number = 0
@export var Pages_unlocked = 2
@export var Pages = [
	[ #Page 1 - 2
		["Encyclopedia","The Encyclopedia is your best friend in this game, nearly everything you must know about your crops and how the game works is in this book, make sure to read it as you progress and as you discover new crops ! ","book"], #Page gauche
		["Carrot","The carrot is a vegetable whose seeds can be planted into a rich and wet soil. The perfect time for planting the carrot is in the first part of Spring but can also be planted during both second part of Spring and Winter.","carrot"]   #Page droite
	],
	[ #Page 3 - 4
		["Title3","Body3","vide"], #Page gauche
		["Title4","Body4","vide"]   #Page droite
	],
	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Book.visible = false
	maj_book(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_down():
	print("Openage of zi encyclopedia")
	$Book.visible = not($Book.visible)
	if $Book.visible:
		$PageFlipSFX.play_random_sound()
	else:
		$BookCloseSFX.play_random_sound()
	maj_book(actual_page_number)
	
func _on_close_button_down():
	$Book.visible = false
	$BookCloseSFX.play_random_sound()

func maj_book(actual_page_number):
	if actual_page_number < Pages_unlocked:
		$Book/Page_gauche/Title.text = Pages[actual_page_number][0][0]
		$Book/Page_gauche/Body.text = Pages[actual_page_number][0][1]
		$Book/Page_gauche/Item.set_animation(Pages[actual_page_number][0][2])
	else:
		$Book/Page_gauche/Title.text = ""
		$Book/Page_gauche/Body.text = ""
		$Book/Page_gauche/Item.set_animation("vide")
	
	if actual_page_number < Pages_unlocked:
		$Book/Page_droite/Title.text = Pages[actual_page_number][1][0]
		$Book/Page_droite/Body.text = Pages[actual_page_number][1][1]
		$Book/Page_droite/Item.set_animation(Pages[actual_page_number][1][2])
	else:
		$Book/Page_droite/Title.text = ""
		$Book/Page_droite/Body.text = ""
		$Book/Page_droite/Item.set_animation("vide")
		
	if actual_page_number == Pages_unlocked-1:
		$Book/Next_Page.visible = false
	else:
		$Book/Next_Page.visible = true
	
	if actual_page_number == 0:
		$Book/Previous_Page.visible = false
	else:
		$Book/Previous_Page.visible = true

	

func _on_next_page_button_down():
	if not(actual_page_number == Pages_unlocked-1):
		actual_page_number += 1
		$PageFlipSFX.play_random_sound()
		maj_book(actual_page_number)

func _on_previous_page_button_down():
	if actual_page_number > 0:
		actual_page_number -= 1
		$PageFlipSFX.play_random_sound()
		maj_book(actual_page_number)
