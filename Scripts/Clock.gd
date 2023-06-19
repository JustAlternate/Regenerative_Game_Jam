extends Node2D

@export var number_of_phases = 8
var current_phase


# Called when the node enters the scene tree for the first time.
func _ready():
	current_phase = 0

func set_phase(phase_number):
	current_phase = phase_number % number_of_phases
	# TAU = 2 * PI
	$ArrowSprite.rotation = current_phase * TAU / number_of_phases
	
func increase_phase():
	current_phase = (current_phase + 1) % number_of_phases
	$ArrowSprite.rotation = current_phase * TAU / number_of_phases


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
