extends Node

var sfx_rock = preload("res://assets/sfx_rock.ogg")
var sfx_bear = preload("res://assets/sfx_bear.ogg")
var sfx_avalanche = preload("res://assets/sfx_avalanche.ogg")
var sfx_log = preload("res://assets/sfx_tree.ogg")
var sfx_walk = preload("res://assets/sfx_walk.ogg")

export (PackedScene) var rock_scene = preload("res://objects/obstacles/Rock.tscn")
export (PackedScene) var log_scene = preload("res://objects/obstacles/Log.tscn")
export (PackedScene) var bear_scene = preload("res://objects/obstacles/Bear.tscn")
export (PackedScene) var background_scene = preload("res://objects/background/Background_obj.tscn")
export var max_obstacle_objects = 3
export var max_background_objects = 20

var obstacles_scenes = [rock_scene, log_scene, bear_scene]
var end_game = false
var score = 0
var death_by = ""
var background_object_step = 0
var obstacle_object_step = 0

signal update_score(value)

onready var player = $Player
onready var avalanche = $Avalanche

func _ready() -> void:
	randomize()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func create_background_object_with_step(step: float) -> void:
	background_object_step -= step

	if background_object_step <= 0:
		var background_obj = background_scene.instance()
		var obj_location = $BackroundSpawnPoints.get_children()[randi() % $BackroundSpawnPoints.get_child_count()]
		add_child(background_obj)
		background_obj.initialize(obj_location.translation)
		background_obj.rotation.y += rand_range(-10, 10)

		background_object_step = rand_range(10, 20)

func create_obstacle_object_with_step(step: float) -> void:
	obstacle_object_step -= step

	if obstacle_object_step <= 0:
		var obstacle_scene = obstacles_scenes[randi() % obstacles_scenes.size()]
		var obstacle = obstacle_scene.instance()
		var obstacle_location = $ObstacleSpawnPoints/LeftPoint if randi() % 2 == 0 else $ObstacleSpawnPoints/RightPoint
		add_child(obstacle)
		obstacle.initialize(obstacle_location.translation)

		obstacle_object_step = rand_range(30, 50)

func check_killed_by_bear(value):
	if value > 0.5:
		var obstacles = get_tree().get_nodes_in_group("OBS")
		for obstacle in obstacles:
			if obstacle.name == 'Bear':
				die("bear")

func get_die_text_color(reason: String) -> Color:
	match reason:
		'bear': return Color8(169, 39, 39, 255)
		'obstacle': return Color8(23, 23, 23, 100)
		'avalanche': return Color8(93, 139, 209, 100)
		_: return Color8(224, 224, 224, 100)

func get_death_sound(reason):
	match reason:
		'bear': return sfx_bear
		'rock': return sfx_rock
		'log': return sfx_log
		'avalanche': return sfx_avalanche

func play_death_sound(reason):
	$AudioPlayer_SFX.stop()
	$AudioPlayer_SFX.stream = get_death_sound(reason)
	$AudioPlayer_SFX.play()

func die(reason, name = ""):
	if end_game:
		return

	end_game = true

	play_death_sound(name if name else reason)

	$UserInterface/Retry.color = get_die_text_color(reason)
	$UserInterface/Retry/Label2.text = "You were killed by " + reason
	$UserInterface/Retry/Label3.text = "Score: " + String(score)
	$UserInterface/Retry.show()


func move_and_generate_objects(value: float) -> void:
	create_obstacle_object_with_step(value)
	create_background_object_with_step(value)
	get_tree().call_group("OBS", "move", value)
	get_tree().call_group("BCK", "move", value)

func _on_AudioEnergy_audio_volume(value) -> void:
	player.set_target_movement(value)

	check_killed_by_bear(value)

	if not end_game:
		if value >= 0.75:
			die("avalanche")
			$Avalanche.go()
		elif value >= 0.05:
			move_and_generate_objects(value)
			$KillTimer.stop()

			var rounded_value = round(value * 10)
			emit_signal("update_score", rounded_value)
			score += rounded_value

			$KillTimer.start()

func _on_KillTimer_timeout() -> void:
	die("cold")

func _process(delta: float) -> void:
	if not end_game:
		return

	match death_by:
		"obstacle":
			move_and_generate_objects(0.1 if player.get_node("Pivot/PlayerModel/AnimationPlayer").is_playing() else 0.0)
		_:
			pass

func _on_Player_obstacle_on_way(name: String) -> void:
	die("obstacle", name)
	print("OBSTACLE - YOU DIE: ", name)
	player.play_fall_animation()
	death_by = "obstacle"
	end_game = true
