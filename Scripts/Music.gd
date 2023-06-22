extends Node

@export var melody: AudioStream
@export var chords: AudioStream
@export var bass: AudioStream
@export var drums: AudioStream

var looped_once = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Melody.stream = melody
	$Chords.stream = chords
	$Bass.stream = bass
	$Drums.stream = drums
	

	

func play_song_phase1():
	if not $Melody.playing:
		$Melody.play()
	if not $Chords.playing:
		$Chords.play()
	if not $Bass.playing:
		$Bass.play()
	if not $Drums.playing:
		$Drums.play()

	$Bass.volume_db = -80
	$Drums.volume_db = -80

func play_song_phase2():
	if not $Melody.playing:
		$Melody.play()
	if not $Chords.playing:
		$Chords.play()
	if not $Bass.playing:
		$Bass.play()
	if not $Drums.playing:
		$Drums.play()
	$Melody.volume_db = 0
	$Chords.volume_db = 0
	$Bass.volume_db = 0
	$Drums.volume_db = 0

func music_stop():
	$Melody.stop()
	$Chords.stop()
	$Bass.stop()
	$Drums.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
