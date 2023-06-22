extends Node

var action_picked = "Graine"
var seed_picked = "carrot"
var game_state = "playing"

var master_volume = -2
var music_volume = -2
var sfx_volume = -2

var inventory = {
	"pea": {"seed": 0, "plant": 0},
	"leek":{"seed": 0, "plant": 0},
	"corn":{"seed": 0, "plant": 0},
	"wheat":{"seed": 0, "plant": 0},
	"carrot":{"seed": 0, "plant": 0},
	"mint":{"seed": 0, "plant": 0},
	"pumpkin":{"seed": 0, "plant": 0},
	"tomatoes":{"seed": 0, "plant": 0},
	"thym":{"seed": 0, "plant": 0},
	"vine":{"seed": 0, "plant": 0},
	"zucchini":{"seed": 0, "plant": 0},
	"ail":{"seed": 0, "plant": 0},
	"radish":{"seed": 0, "plant": 0}
}
