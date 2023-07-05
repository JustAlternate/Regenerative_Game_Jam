extends Node2D

signal phase_changed(new_phase: int)

@export var number_of_phases = 8
var current_phase

var current_year:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_phase(0)

func set_phase(phase_number):
	current_phase = phase_number % number_of_phases
	# TAU = 2 * PI
	$ArrowSprite.animation = str(current_phase)
	$ArrowSprite.frame = 3
	phase_changed.emit(current_phase)
	
func increase_phase():
	$TickSFX.play()
	current_phase = (current_phase + 1) % number_of_phases
	if current_phase == 0:
		current_year += 1
		$Label.text = "Year " + str(current_year)
	$ArrowSprite.animation = str(current_phase)
	$ArrowSprite.frame = 0
	$ArrowSprite.play()
	phase_changed.emit(current_phase)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and GlobalVariables.game_state == "playing":
		increase_phase()


func _on_texture_button_pressed():
	if GlobalVariables.game_state == "clock":
		return
	increase_phase()


func _on_arrow_sprite_animation_looped():
	print("reçu")
	$ArrowSprite.stop()
	$ArrowSprite.frame = 3

func phase_after(i : int):
	return (i+1)%8

func _on_texture_button_mouse_entered():
	if GlobalVariables.game_state == "clock":
		return
	else:
		$ArrowSprite.animation = str(phase_after(current_phase))
		$ArrowSprite.frame = 0

func _on_texture_button_mouse_exited():
	if GlobalVariables.game_state == "clock":
		return
	else:
		$ArrowSprite.animation = str(current_phase)
		$ArrowSprite.frame = 3
