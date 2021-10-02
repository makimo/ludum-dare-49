extends Node2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

var spectrum

signal audio_volume(value)

func _process(_delta):
	var magnitude: float = spectrum.get_magnitude_for_frequency_range(0, 20000).length()
	var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
	emit_signal("audio_volume", energy)

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(1,0)
