extends Node2D

var state = 0 # 0=graine, 1=carrote, -1=morte.
@export var number_of_phase = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.animation = "0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_state():
	state += 1
	if state == number_of_phase:
		state = -1	#	a changer en fonction de ce qui se passe lorsque la plante meurt.
	$sprite.animation = str(state)  

func dying():
	state = -1
	$sprite.animation = str(state)  #a changer en fonction de ce qui se passe lorsque la plante meurt.
	


func next_phase(phase:int, humidity:int, lightness:int, nutriments:int):
	if phase >= 0 and phase <= 5: #printent/été/automne
		next_state()
	else:
		dying()
		
		
