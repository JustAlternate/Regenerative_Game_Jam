extends Node2D

@export var Energy:float = 1
@export var Canvas_modulate_color = Color8(0,0,0)
@export var Sun_color = Color8(0,0,0)
var sfx_tween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sun/DirectionalLight2D.energy = Energy
	$Sun/CanvasModulate.color = Canvas_modulate_color
	$Sun/DirectionalLight2D.color = Sun_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func rain_fade_in():
	$RainSFX.volume_db = -80
