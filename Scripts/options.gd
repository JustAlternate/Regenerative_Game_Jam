extends Node2D


var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Master/MasterVolumeSlider.value = GlobalVariables.master_volume
	$Music/MusicVolumeSlider.value = GlobalVariables.music_volume
	$SFX/SfxVolumeSlider.value = GlobalVariables.sfx_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range ($backgound/Sprite_deroulant.get_child_count()):
		if $backgound/Sprite_deroulant.get_child(i).position.x > 1000:
			$backgound/Sprite_deroulant.get_child(i).position.x = -2600
		$backgound/Sprite_deroulant.get_child(i).position.x +=1

func _on_exit_pressed():
	$"/root/PersistentSfx/Click_sfx".play()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	


func _on_master_volume_slider_value_changed(value):
	var audio_value = value
	if value == $Master/MasterVolumeSlider.min_value:
		audio_value = -80
	AudioServer.set_bus_volume_db(master_bus_index, audio_value)
	GlobalVariables.master_volume = value


func _on_music_volume_slider_value_changed(value):
	var audio_value = value
	if value == $Music/MusicVolumeSlider.min_value:
		audio_value = -80
	AudioServer.set_bus_volume_db(music_bus_index, audio_value)
	GlobalVariables.music_volume = value


func _on_sfx_volume_slider_value_changed(value):
	var audio_value = value
	if value == $SFX/SfxVolumeSlider.min_value:
		audio_value = -80
	AudioServer.set_bus_volume_db(sfx_bus_index, audio_value)
	GlobalVariables.sfx_volume = value
