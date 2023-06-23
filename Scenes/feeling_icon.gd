extends Node2D

var feeling_type: String
var position_offset
var starting_position


# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = position
	position_offset = 0
	$Sprite.animation = feeling_type
	await get_tree().create_timer(3).timeout
	free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_offset += delta
	position = starting_position
	position.y += position_offset * 10 + position_offset*position_offset*5
