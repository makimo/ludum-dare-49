extends Node2D


func _ready():
	pass # Replace with function body.

func _on_AudioEnergy_audio_volume(value):
	print(value)
	
func _on_AudioEnergy_audio_pitch(value):
	print("pitch: %f" % value)
