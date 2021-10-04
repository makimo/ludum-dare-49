extends Node2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

const LOW_THRESHOLD = 60
const HIGH_THRESHOLD = 80
const SMOOTHING_SAMPLES = 15

var samples = []

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
	var noise_bar = get_node("Interface/NoiseBar")
	samples.pop_front()
	while (samples.size() < SMOOTHING_SAMPLES):
		samples.push_back(height)

	var sum = 0
	for sample in samples:
		sum += sample
	var average = sum / SMOOTHING_SAMPLES

	noise_bar.value = average
	if (height >= HIGH_THRESHOLD):
		noise_bar.tint_progress = Color(0.7, 0.2, 0.2, 1)
	elif (height <= LOW_THRESHOLD):
		noise_bar.tint_progress = Color(0, 0, 0.7, 0.3)
	else:
		noise_bar.tint_progress = Color(0, 0.7, 0, 1)

func _process(_delta):
	update()


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0, 0)

