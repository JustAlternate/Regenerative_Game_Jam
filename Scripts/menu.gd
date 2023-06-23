extends Node2D

var arrow_game = load("res://Assets/sprites/cursor_game.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow_game)
	$backgound/riviere.play("default")
	$"/root/PersistentSfx/SpringMusic".play_song_phase1()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range ($backgound/Sprite_deroulant.get_child_count()):
		if $backgound/Sprite_deroulant.get_child(i).position.x > 1000:
			$backgound/Sprite_deroulant.get_child(i).position.x = -2200
		$backgound/Sprite_deroulant.get_child(i).position.x +=1

func _on_play_pressed():
	$"/root/PersistentSfx/Click_sfx".play()
	# This is like autoloading the scene, only
	# it happens after already loading the main scene.
	get_tree().change_scene_to_file("res://Scenes/home.tscn")



func _on_options_pressed():
	$"/root/PersistentSfx/Click_sfx".play()
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
