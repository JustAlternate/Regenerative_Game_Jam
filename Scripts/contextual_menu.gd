extends Node2D

var targeted_plant:Node
var closing:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = targeted_plant.global_position + Vector2(-5,10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_menu(plant:Node):
	targeted_plant = plant
	if targeted_plant.state == GlobalVariables.dico_caracteristique["number_of_phases"][targeted_plant.plant_type]:
		$Animated_Harvest.show()
		$Animated_Harvest.play("default", 1.5)
	$Animated_Info.show()
	$Animated_Info.play("default", 1.5)
	$Animated_Remove.show()
	$Animated_Remove.play("default", 1.5)
	visible = true

func destruction():
	closing = true
	if $button_harvest/Label_Harvest.visible:
		$button_harvest.hide()
		$Animated_Harvest.play("default", -2, true)
	$button_info.hide()
	$Animated_Info.show()
	$Animated_Info.play("default", -2, false)
	$button_remove.hide()
	$Animated_Remove.show()
	$Animated_Remove.play("default", -2, true)

func _on_button_harvest_pressed():
	print("harvest")
	targeted_plant.harvest_plant()
	destruction()

func _on_button_remove_pressed():
	print("remove")
	targeted_plant.remove_plant()
	destruction()

func _on_button_info_pressed():
	print("info")
	var a = get_tree().root
	get_tree().root.get_node("home/Game/Encyclopedia").open_on_name(targeted_plant.plant_type)
	destruction()

func _on_button_harvest_mouse_entered():
	$button_harvest/Label_Harvest.visible = true

func _on_button_harvest_mouse_exited():
	$button_harvest/Label_Harvest.visible = false

func _on_button_remove_mouse_entered():
	$button_remove/Label_remove.visible = true

func _on_button_remove_mouse_exited():
	$button_remove/Label_remove.visible = false

func _on_button_info_mouse_entered():
	$button_info/Label_Info.visible = true

func _on_button_info_mouse_exited():
	$button_info/Label_Info.visible = false



func _on_animated_info_animation_finished():
	if closing: 
		queue_free()
	$Animated_Info.hide()
	$button_info.show()

func _on_animated_harvest_animation_finished():
	$Animated_Harvest.hide()
	$button_harvest.show()

func _on_animated_remove_animation_finished():
	$Animated_Remove.hide()
	$button_remove.show()
	
