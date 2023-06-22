extends Sprite2D

var direction
var time_beforme_moving_again
var vitesse
var pos_x
var pos_y

# Called when the node enters the scene tree for the first time.
func _ready():
	print("heho")
	while position.x > 0 or position.x < 9*64:
		await get_tree().create_timer(time_beforme_moving_again).timeout
		if direction == 1:
			# vers la droite
			position.x += vitesse
		else:
			# vers la gauche
			position.x -= vitesse
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
