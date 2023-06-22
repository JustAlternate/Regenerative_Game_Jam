extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range ($Sprite_deroulant.get_child_count()):
		if $Sprite_deroulant.get_child(i).position.x > 1000:
			$Sprite_deroulant.get_child(i).position.x = -100
		$Sprite_deroulant.get_child(i).position.x +=1

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
