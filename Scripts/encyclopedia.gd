extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	maj_book(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@export var Pages = [
	[ #Page 1 - 2
		["Title1","Body1","godot"], #Page gauche
		["Title2","Body2","book"]   #Page droite
	],
	[ #Page 3 - 4
		["Title3","Body3","encyclopedia"], #Page gauche
		["Title4","Body4","godot"]   #Page droite
	],
	
]

var actual_page_number = 0

func _on_button_button_down():
	print("Openage of zi encyclopedia")
	$Book.visible = not($Book.visible)
	
func _on_close_button_down():
	$Book.visible = false

func maj_book(actual_page_number):
		$Book/Page_gauche/Title.text = Pages[actual_page_number][0][0]
		$Book/Page_gauche/Body.text = Pages[actual_page_number][0][1]
		$Book/Page_gauche/Item.set_animation(Pages[actual_page_number][0][2])
		
		$Book/Page_droite/Title.text = Pages[actual_page_number][1][0]
		$Book/Page_droite/Body.text = Pages[actual_page_number][1][1]
		$Book/Page_droite/Item.set_animation(Pages[actual_page_number][1][2])

func _on_next_page_button_down():
	if actual_page_number < len(Pages)-1:
		actual_page_number += 1
		maj_book(actual_page_number)

func _on_previous_page_button_down():
	if actual_page_number > 0:
		actual_page_number -= 1
		maj_book(actual_page_number)
