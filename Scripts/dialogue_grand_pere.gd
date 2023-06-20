extends Node2D

@export var largeur_bulle_texte:int
@export var hauteur_bulle_texte:int
@export var text = "Grosse murge"
@export var taille_police:int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Label.text = text
	$Panel/Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
