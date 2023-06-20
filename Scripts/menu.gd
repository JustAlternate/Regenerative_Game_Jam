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
		
var simultaneous_scene = preload("res://Scenes/home.tscn").instantiate()


func _on_play_pressed():
	# This is like autoloading the scene, only
	# it happens after already loading the main scene.
	get_tree().get_root().add_child(simultaneous_scene)
	# ATTENTION IL FAUT SUPPRIMER LA MENU SCENE ICI, MAIS J'AI PAS ENCOER REUSSI !

