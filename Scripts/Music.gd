extends Node

@export var phase1: AudioStream
@export var drums_bass: AudioStream

var looped_once = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Phase1.stream = phase1
	$DrumsBass.stream = drums_bass
	
	

	

func play_song_phase1():
	if not $Phase1.playing:
		$Phase1.play()
	if not $DrumsBass.playing:
		$DrumsBass.play()

	$DrumsBass.volume_db = -80

func play_song_phase2():
	if not $Phase1.playing:
		$Phase1.play()
	if not $DrumsBass.playing:
		$DrumsBass.play()
	$Phase1.volume_db = 0
	$DrumsBass.volume_db = 0

func music_stop():
	$Phase1.stop()
	$DrumsBass.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
