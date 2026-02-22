extends Node


func _ready() -> void:
	var new_audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_audio_player.bus = "Music"
	add_child(new_audio_player)
	var audio_stream: AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(
		"res://sound/music/Godot Wild 90 Jam.ogg"
	)
	new_audio_player.stream = audio_stream
	new_audio_player.play()
	# Looping by setting loop: enable to true isn't cooperating, so here we are.
	new_audio_player.finished.connect(func() -> void: new_audio_player.play())
