extends AudioStreamPlayer2D

@export var stream_array: Array[AudioStream]

func play_random() -> void:
	if stream_array == null || stream_array.size() == 0: return
	stream = stream_array.pick_random()
	play()
