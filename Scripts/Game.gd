extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_clock_phase_changed(new_phase):
	print("going to next phase !!!")
	
	# Deciding what random events are going to happen
	print("mettre des random events")
	
	# Updating every plants
	for i in range(8):
		$plant_spot_container.get_child(i).get_node("plant").next_quarter_of_season(new_phase)
	
	
