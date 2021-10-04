extends Node2D

const VU_COUNT = 1024
const FREQ_MAX = 11050.0

const WIDTH = 1024
const HEIGHT = 200
const LIMIT = 30 # one in every `limit` samples gets sent
const MIN_DB = 55
const MIN_ENERGY = 0.0005
# probably some fourier parameters are fucked up, this coeff makes it good.
const MAGIC_KITI_NUMBER = 1.07

var spectrum
var curr_limit = 0
var glob_mags = []


signal audio_volume(value)
signal audio_pitch(value)

func calc_pitch_from_spec(mags, bin_size):
	var THRESHOLD = 0.05
	# leave only the peaks
	var max_val = mags.max()
	for i in range(0, len(mags)):
		mags[i] = 0 if max_val*THRESHOLD >= mags[i] else mags[i]
	var island = false
	var local_max = 0
	var local_index = -1
	var maxes = []
	for i in range(0, len(mags)):
		# start island
		if (mags[i] > 0 and not island):
			island = true
			local_max = mags[i]
			local_index = i
		# proceed with island
		if (mags[i] > local_max and island):
			local_max = mags[i]
			local_index = i
		# end island
		if (mags[i] == 0 and island):
			island = false
			maxes.append(local_index)
	if (len(maxes) >= 1):
		#print(maxes)
		return maxes[0] * bin_size
	#if (len(maxes) > 1):
	#	return (maxes[1] - maxes[0]) * bin_size
	return 0
	#return maxes[0] * bin_size

func _draw():
	#warning-ignore:integer_division
	if (len(glob_mags) == 0):
		return
	var w = WIDTH / VU_COUNT
	for i in range(1, VU_COUNT+1):
		var height = glob_mags[i-1] * HEIGHT
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.white)

func _process(_delta):
	var magnitude: float = spectrum.get_magnitude_for_frequency_range(0, 20000).length()
	var final_energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
#	var prev_hz = 0
#	var pitch = 0
#	var pitch_energy = 0
#	var mags = []
#	mags.resize(VU_COUNT)
#	for i in range(1, VU_COUNT+1):
#		var hz = i * FREQ_MAX / VU_COUNT
#		magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
#		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
#		mags[i-1] = energy
#		prev_hz = hz
#		if (energy > pitch_energy):
#			pitch = hz
#			pitch_energy = energy
#	glob_mags = mags
#	pitch = MAGIC_KITI_NUMBER * calc_pitch_from_spec(mags, FREQ_MAX/VU_COUNT)
	curr_limit += 1
	if (final_energy >= MIN_ENERGY and curr_limit >= LIMIT):
		emit_signal("audio_volume", final_energy)
#		emit_signal("audio_pitch", pitch)
		curr_limit = 0
		#update()

func _ready():
	var bus_index = AudioServer.get_bus_index("Master")
	spectrum = AudioServer.get_bus_effect_instance(bus_index,0)


