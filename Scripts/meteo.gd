extends Node2D

@export var Energy:float = 1
@export var Canvas_modulate_color = Color8(0,0,0)
@export var Sun_color = Color8(0,0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func go_meteo():
	$Sun/DirectionalLight2D.energy = Energy
	$Sun/CanvasModulate.color = Canvas_modulate_color
	$Sun/DirectionalLight2D.color = Sun_color
	$Nuages.go_nuages()

func rain_fade_in():
	var sfx_tween = create_tween()
	$RainSFX.volume_db = -80
	$RainSFX.play()
	sfx_tween.tween_property($RainSFX, "volume_db", 0, 1)
	
func rain_fade_out():
	var sfx_tween = create_tween()
	sfx_tween.tween_property($RainSFX, "volume_db", -80, 1)
	# $RainSFX.stop()
