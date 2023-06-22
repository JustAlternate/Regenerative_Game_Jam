extends Node2D


# Called when the node enters the scene tree for the first time.

var direction:int
var positions:int
var vitesse:int
var time_beforme_moving_again:float
var pos_x:int
var pos_y:int

var id_nuage = 0

var scene_nuage = load("res://Scenes/nuage_normal.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill_nuages():
	for i in get_children():
		i.free()

func go_nuages(prob_nuage1,prob_nuage2):
	direction = randi_range(0,1)
	var proba_nuage = randi_range(prob_nuage1,prob_nuage2)
	for i in range(proba_nuage):
		time_beforme_moving_again = randf_range(0.5,0.8)
		pos_y = randi_range(20,60)
		vitesse = randi_range(1,1)
		if direction == 0: # vers la gauche
			pos_x = randi_range(9*64 - 600,9*64)
		else:
			pos_x = randi_range(0,600)
		
		var nuage_instance = scene_nuage.instantiate()
		nuage_instance.direction = direction
		nuage_instance.time_beforme_moving_again = time_beforme_moving_again
		nuage_instance.vitesse = vitesse
		nuage_instance.position.x = pos_x
		nuage_instance.position.y = pos_y
		var name = "nuage_" + str(id_nuage)
		nuage_instance.name = name
		add_child(nuage_instance)
