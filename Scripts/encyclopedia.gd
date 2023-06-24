extends Node2D

var actual_page_number = 0
var summary = {
	"introduction":0,
	"radish":0,
	"leek":2,
	"tomatoes":2,
	"pea":4,
	"wheat":4,
	"pumpkin":6,
	"zucchini":6,
	"mint":8,
	"corn":8,
	"carrot":10,
	"garlic":10,
	"vine":12,
	"thyme":12,
}

var real_page_number = {
	"introduction":0,
	"radish":1,
	"leek":2,
	"tomatoes":3,
	"pea":4,
	"wheat":5,
	"pumpkin":6,
	"zucchini":7,
	"mint":8,
	"corn":9,
	"carrot":10,
	"garlic":11,
	"vine":12,
	"thyme":13,
}

@export var Pages_unlocked = 2
@export var Pages = [
	#Page 1 - 2
		["Encyclopedia","The Encyclopedia is your best friend in this game, nearly everything you must know about your crops and how the game works is in this book. Make sure to read it as you progress and as you discover new crops!\n\nA phase is a half of a season.","Encyclopedia"], #Page gauche
		["Radish","Radish is a vegetable that can be sown all year long, except in fall 2.\nIt takes 1 phase to grow.\n\nIt prefers the shade or the rain, but can grow in any weather except under strong sunlight.\n\nNutrient-rich soil is necessary.\n\nIt needs soaked soil to grow.\n\nRadish appreciates to be next to carrots, garlic, peas and tomatoes.","radish"],   #Page droite

	#Page 3 - 4
		["Leek","Leek is a vegetable that can be sown in summer 1 and fall 1, but prefers to be planted in [b]summer 2[/b].\nIt takes 3 phases to grow.\n\nIt can grow in any weather.\n\nNutrient-poor soil is sufficient.\n\nIt needs moist soil to grow.\n\nLeek appreciates to be next to carrots and tomatoes, but does not like to be next to peas.","leek"], #Page gauche
		["Tomato","Tomato is a vegetable that can be sown in winter 2 and spring 2, but prefers to be planted in [b]spring 1[/b].\nIt takes 2 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nIt does not need a lot of nutrients in the soil.\n\nIt needs soaked soil to grow.\n\nTomatoes like to be next to radishes.","tomatoes"],   #Page droite

	#Page 5 - 6
		["Pea","Pea is a vegetable that can be sown in spring 1 and fall 2, but prefers to be planted in [b]winter 1 & 2[/b].\nIt takes 2 phases to grow.\n\nIt prefers the shade or the rain, but can grow in any weather except under strong sunlight.\n\nNutrient-poor soil is sufficient.\n\nIt needs moist soil to grow.","pea"], #Page gauche
		["Wheat","Wheat is a cereal that can be sown in fall and winter, but prefers to be planted in [b]winter 2[/b].\nIt takes 4 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is sufficient.\n\nIt needs moist soil to grow.","wheat"],   #Page droite

	#Page 7 - 8
		["Pumpkin","Pumpkin is a vegetable that can be sown in spring 1 and summer 1, but prefers to be planted in [b]spring 2[/b].\nIt takes 3 phases to grow.\n\nIt prefers the shade and the rain, but can grow in any weather except under strong sunlight.\n\nIt does not need a lot of nutrients in the soil.\n\nIt needs moist or soaked soil to grow.","pumpkin"], #Page gauche
		["Zucchini","Zucchini is a vegetable that can be sown in winter 2 and spring 2, but prefers [b]spring 1[/b].\nIt takes 2 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-rich soil is necessary.\n\nIt needs soaked soil to grow.\n\nIt likes to be next to peas, but doesn’t like radishes.","zucchini"],   #Page droite

	#Page 9 - 10
		["Mint","Mint is an herb that can be sown in winter 2 and spring 2, but prefers to be planted in [b]spring 1[/b].\nIt takes 3 phases to grow.\n\nIt can grow in any weather.\n\nNutrient-rich soil is necessary.\n\nIt needs moist soil to grow.\n\nMint appreciates to be next to thyme, radishes, tomatoes and peas.\nIt doesn’t like carrots and corn.","mint"], #Page gauche
		["Corn","Corn is a cereal that can be sown in spring 2, but prefers to be planted in [b]spring 1[/b].\nIt takes 2 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nIt must have a minimum of nutrients in the soil.\n\nIt needs soaked soil to grow.\n\nCorn appreciates to be next to pumpkins.","corn"],   #Page droite

	#Page 11 - 12
		["Carrot","Carrot is a vegetable that can be sown in winter 2 and spring 2, but prefers to be planted in [b]spring 1[/b].\nIt takes 3 phases to grow.\n\nIt can grow in any weather.\n\nNutrient-rich soil is necessary.\n\nIt needs moist or soaked soil to grow.\n\nCarrots appreciate to be next to tomatoes, radishes, peas and garlic.","carrot"], #Page gauche
		["Garlic","Garlic is an herb that can be sown in [b]fall 2 and winter 2[/b].\nIt takes 3 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is necessary.\n\nIt needs dry soil to grow.\n\nGarlic appreciates to be next to tomatoes and doesn’t like peas.","ail"],   #Page droite

	#Page 13 - 14
		["Vine","Vine is a fruit plant that can be sown in fall 2 and spring 2, but prefers to be planted in [b]winter 1 & 2[/b].\nIt takes 4 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is necessary.\n\nIt needs moist soil to grow.","vine"], #Page gauche
		["Thyme","Thyme is an herb that can be sown in spring 1 & 2, but prefers to be planted in [b]fall 1[/b].\nIt takes 4 phases to grow.\n\nIt prefers strong sunlight, but can grow in any weather except in the shade or under the rain.\n\nNutrient-poor soil is necessary.\n\nThyme needs dry soil to grow.","thym"],  #Page droite
]

# Called when the node enters actual_page_numberthe scene tree for the first time.
func _ready():
	$Book.visible = false
	maj_book(0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_down():
	print("Openage et closage of zi encyclopedia")
	$Book.visible = not($Book.visible)
	if $Book.visible:
		$PageFlipSFX.play_random_sound()
	else:
		$BookCloseSFX.play_random_sound()
		get_tree().root.get_node("home/Game/Dialogue_grand_pere").player_just_did_something(["closed_book",actual_page_number])
	maj_book(actual_page_number)
	
func _on_close_button_down():
	get_tree().root.get_node("home/Game/Dialogue_grand_pere").player_just_did_something(["closed_book",actual_page_number])
	$Book.visible = false
	$BookCloseSFX.play_random_sound()

func maj_book(new_page_number):
	if new_page_number < Pages_unlocked:
		$Book/Page_gauche/Title.text = Pages[new_page_number][0]
		$Book/Page_gauche/Body.text = Pages[new_page_number][1]
		$Book/Page_gauche/Item.set_animation(Pages[new_page_number][2])
	else:
		$Book/Page_gauche/Title.text = ""
		$Book/Page_gauche/Body.text = ""
		$Book/Page_gauche/Item.set_animation("vide")
	
	if new_page_number+1 < Pages_unlocked:
		$Book/Page_droite/Title.text = Pages[new_page_number+1 ][0]
		$Book/Page_droite/Body.text = Pages[new_page_number+1 ][1]
		$Book/Page_droite/Item.set_animation(Pages[new_page_number+1 ][2])
	else:
		$Book/Page_droite/Title.text = ""
		$Book/Page_droite/Body.text = ""
		$Book/Page_droite/Item.set_animation("vide")
	
	if actual_page_number > 0:
		$Book/turn_page_left.visible = true
	else:$Book/turn_page_left.visible = false
	
func open_on_name(plant:String):
	if plant != "None":
		var actual_page_number = summary[plant]
		$Book.show()
		$PageFlipSFX.play_random_sound()
		maj_book(actual_page_number)
		

func _on_next_page_button_down():
	actual_page_number += 2
	$PageFlipSFX.play_random_sound()
	maj_book(actual_page_number)

func _on_previous_page_button_down():
	if actual_page_number > 1:
		actual_page_number -= 2
		$PageFlipSFX.play_random_sound()
		maj_book(actual_page_number)


func _on_open_close_mouse_entered():
	$box_little_book.animation = "souris"

func _on_open_close_mouse_exited():
	$box_little_book.animation = "default"
 
func _on_close_mouse_entered():
	$Book/button_close.animation = "souris"


func _on_close_mouse_exited():
	$Book/button_close.animation = "default"


func _on_previous_page_mouse_entered():
	$Book/turn_page_left.animation = "souris"

func _on_previous_page_mouse_exited():
	$Book/turn_page_left.animation = "default"


func _on_next_page_mouse_entered():
	$Book/turn_page_right.animation = "souris"


func _on_next_page_mouse_exited():
	$Book/turn_page_right.animation = "default"
