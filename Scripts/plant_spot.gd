extends Node2D

var plant_scene:Resource
var plant_instance
var plant_type:String = "None"
var intance:Node
var a

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_button_pressed():
	if GlobalVariables.action_picked == "Graine":
		if plant_type == "None":
			plant_scene = load("res://Scenes/plants/" + GlobalVariables.seed_picked + ".tscn")
			plant_instance = plant_scene.instantiate()
			plant_instance.name = "plant"
			add_child(plant_instance)
