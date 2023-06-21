extends Node2D

signal phase_changed(new_phase: int)

@export var number_of_phases = 8
var current_phase
@export var starting_arrow_angle = -90
var arrow_rotation_offset = (TAU * starting_arrow_angle) / 360.0 + PI

# Called when the node enters the scene tree for the first time.
func _ready():
	arrow_rotation_offset = (TAU * starting_arrow_angle) / 360.0 + PI
	set_phase(0)

func set_phase(phase_number):
	current_phase = phase_number % number_of_phases
	# TAU = 2 * PI
	$ArrowSprite.rotation = (current_phase * TAU / number_of_phases) + arrow_rotation_offset
	phase_changed.emit(current_phase)
	
func increase_phase():
	current_phase = (current_phase + 1) % number_of_phases
	$ArrowSprite.rotation = (current_phase * TAU / number_of_phases) + arrow_rotation_offset
	phase_changed.emit(current_phase)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		increase_phase()


func _on_texture_button_pressed():
	increase_phase()
