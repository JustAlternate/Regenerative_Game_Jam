extends Node2D

var actual_page_number = 0
@export var Pages_unlocked = 7
@export var Pages = [
	[ #Page 1 - 2
		["Encyclopedia","The Encyclopedia is your best friend in this game, nearly everything you must know about your crops and how the game works is in this book, make sure to read it as you progress and as you discover new crops ! ","book"], #Page gauche
		["Radish","Radish is a vegetable that can be sown all the year, except in fall 2.\nIt takes 1 phase to grow.\n\nIt prefers the shade or the rain, but can grow in any weather except under strong sunlight.\n\nNutrient-rich soil is necessary.\n\nIt needs soaked soil to grow.\n\nRadish appreciates to be next to carrots, garlic, peas and tomatoes.","carrot"]   #Page droite
	],
	[ #Page 3 - 4
		["Pea","Pea is a vegetable that can be sown in spring 1 and fall 2, but prefers to be planted in winter 1 & 2.\nIt takes 2 phases to grow.\n\nIt prefers the shade or the rain, but can grow in any weather except under strong sunlight.\n\nNutrient-poor soil is sufficient.\n\nIt needs moist soil to grow.","vide"], #Page gauche
		["Tomato","Tomato is a vegetable that can be sown in winter 2 and spring 2, but prefers to be planted in spring 1.\nIt takes 2 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nIt must have a minimum of nutrients in the soil.\n\nIt needs soaked soil to grow.\n\nTomatoes like to be next to radishes.","vide"]   #Page droite
	],
	[ #Page 5 - 6
		["Leak","Leak is a vegetable that can be sown in summer 1 and fall 1, but prefers to be planted in summer 2.\nIt takes 3 phases to grow.\n\nIt can grow in any weather.\n\nNutrient-poor soil is sufficient.\n\nIt needs moist soil to grow.\n\nLeak appreciates to be next to carrots and tomatoes, but doesn’t like to be next to peas.","vide"], #Page gauche
		["Wheat","Wheat is a cereal that can be sown in fall 1, but prefers to be planted in winter 2.\nIt takes 4 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is sufficient.\n\nIt needs moist soil to grow.","vide"]   #Page droite
	],
	[ #Page 7 - 8
		["Pumpkin","Pumpkin is a vegetable that can be sown in spring 1 and summer 1, but prefers to be planted in spring 2.\nIt takes 3 phases to grow.\n\nIt prefers the shade and the rain, but can grow in any weather except under strong sunlight.\n\nIt must have a minimum of nutrients in the soil.\n\nIt needs moist or soaked soil to grow.","vide"], #Page gauche
		["Zucchini","Zucchini is a vegetable that can be sown in winter 2 and spring 2, but prefers spring 1.\nIt takes 2 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-rich soil is necessary.\n\nIt needs soaked soil to grow.\n\nIt likes to be next to peas, but doesn’t like radishes.","vide"]   #Page droite
	],
	[ #Page 9 - 10
		["Mint","Mint is an herb that can be sown in winter 2 and spring 2, but prefers to be planted in spring 1.\nIt takes 3 phases to grow.\n\nIt can grow in any weather.\n\nNutrient-rich soil is necessary.\n\nIt needs moist soil to grow.\n\nMint appreciates to be next to thyme, radishes, tomatoes and peas.\nIt doesn’t like carrots and corn.","vide"], #Page gauche
		["Corn","Corn is a cereal that can be sown in spring 2, but prefers to be planted in spring 1.\nIt takes 2 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nIt must have a minimum of nutrients in the soil.\n\nIt needs soaked soil to grow.\n\nCorn appreciates to be next to pumpkins.","vide"]   #Page droite
	],
	[ #Page 11 - 12
		["Carrot","Carrot is a vegetable that can be sown in winter 2 and spring 2, but prefers to be planted in spring 1.\nIt takes 3 phases to grow.\n\nIt can grow in any weather.\n\nNutrient-rich soil is necessary.\n\nIt needs moist or soaked soil to grow.\n\nCarrots appreciate to be next to tomatoes, radishes, peas and garlic.","vide"], #Page gauche
		["Garlic","Garlic is an herb that can be sown in fall 2 and winter 2.\nIt takes 3 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is necessary.\n\nIt needs dry soil to grow.\n\nGarlic appreciates to be next to tomatoes and doesn’t like peas.","vide"]   #Page droite
	],
	[ #Page 13 - 14
		["Vine","Vine is a fruit plant that can be sown in fall 2 and spring 2, but prefers to be planted in winter 1 & 2.\nIt takes 4 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is necessary.\n\nIt needs moist soil to grow.","vide"], #Page gauche
		["Thyme","Thyme is an herb that can be sown in spring 1 & 2, but prefers to be planted in fall 1.\nIt takes 4 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is necessary.\n\nThyme needs dry soil to grow.","vide"]   #Page droite
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
	if GlobalVariables.game_state == "clock":
		return
	print("Openage of zi encyclopedia")
	$Book.visible = not($Book.visible)
	if $Book.visible:
		$PageFlipSFX.play_random_sound()
	else:
		$BookCloseSFX.play_random_sound()
	maj_book(actual_page_number)
	
func _on_close_button_down():
	if GlobalVariables.game_state == "clock":
		return
	close_enciclopedia()

func close_enciclopedia():
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
	if GlobalVariables.game_state == "clock":
		return
	if not(actual_page_number == Pages_unlocked-1):
		actual_page_number += 1
		$PageFlipSFX.play_random_sound()
		maj_book(actual_page_number)

func _on_previous_page_button_down():
	if GlobalVariables.game_state == "clock":
		return
	if actual_page_number > 0:
		actual_page_number -= 1
		$PageFlipSFX.play_random_sound()
		maj_book(actual_page_number)
