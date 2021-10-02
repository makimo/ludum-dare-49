extends Node2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

var spectrum

func _draw():
	#warning-ignore:integer_division
	var w = WIDTH / VU_COUNT
	var prev_hz = 0
	var max_height = 0
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		max_height = max(height, max_height)
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.white)
		prev_hz = hz
	set_noise_bar_value(max_height)
	
func set_noise_bar_value(height):
	var low_threshold = 60
	var high_threshold = 80
	var noise_bar = get_node("Interface/NoiseBar")
	noise_bar.value = height
	if (height >= high_threshold):
		noise_bar.tint_progress = Color(0.8, 0.2, 0.2, 1)
	elif (height <= low_threshold):
		noise_bar.tint_progress = Color(0, 0, 0.8, 0.4)
	else:
		noise_bar.tint_progress = Color(0, 0.8, 0, 1)

func _process(_delta):
	update()


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(1, 0)

