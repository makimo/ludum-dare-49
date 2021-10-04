extends Node

export (PackedScene) var rock_scene = preload("res://objects/obstacles/Rock.tscn")
export (PackedScene) var log_scene = preload("res://objects/obstacles/Log.tscn")
export (PackedScene) var bear_scene = preload("res://objects/obstacles/Bear.tscn")
export (PackedScene) var background_scene = preload("res://objects/background/Background_obj.tscn")
export var max_obstacle_objects = 3
export var max_background_objects = 20

var obstacles_scenes = [rock_scene, log_scene, bear_scene]
var end_game = false
var score = 0

signal update_score(value)

onready var player = $Player

func _ready() -> void:
	create_obstacle_object(true)
	randomize()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func create_obstacle_object(force : bool = false):
	if force or (randf() > 0.92 and get_tree().get_nodes_in_group("OBS").size() < max_obstacle_objects):
		var obstacle_scene = obstacles_scenes[randi() % obstacles_scenes.size()]
		var obstacle = obstacle_scene.instance()
		var obstacle_location = $ObstacleSpawnPoints/LeftPoint if randi() % 2 == 0 else $ObstacleSpawnPoints/RightPoint
		add_child(obstacle)
		obstacle.initialize(obstacle_location.translation)

func create_background_object():
	if randf() > 0.5 and get_tree().get_nodes_in_group("BCK").size() < max_background_objects:
		var background_obj = background_scene.instance()
		var obj_location = $BackroundSpawnPoints.get_children()[randi() % $BackroundSpawnPoints.get_child_count()]
		add_child(background_obj)
		background_obj.initialize(obj_location.translation)
		
func check_killed_by_bear(value):
	if value > 8:
		var obstacles = get_tree().get_nodes_in_group("OBS")
		for obstacle in obstacles:
			if obstacle.name == 'Bear':
				die("bear")
	
func die(reason):
	end_game = true
	var color
	if reason == 'bear':
		color  = Color8(169,39,39)
	elif reason == 'obstracle':
		color  = Color8(23,23,23)
	elif reason == 'loud':
		color = Color8(224,224,224)
	else:
		color = Color8(93,139,209)
	$UserInterface/Retry.color = color
	$UserInterface/Retry/Label2.text = "You were killed by " + reason
	$UserInterface/Retry/Label3.text = "Score: " + String(score)
	$UserInterface/Retry.show()

func _on_AudioEnergy_audio_volume(value) -> void:
	player.set_target_movement(value)
	value *= 60
	check_killed_by_bear(value)
	if not end_game:
		if value >= 15:
			die("loud")
		else:
			$KillTimer.stop()
			create_obstacle_object()
			create_background_object()
			get_tree().call_group("OBS", "move", value)
			get_tree().call_group("BCK", "move", value)
			value = round(value)
			emit_signal("update_score", value)
			score += value
			$KillTimer.start()

func _on_Player_obstacle_on_way() -> void:
	die("obstracle")

func _on_KillTimer_timeout() -> void:
	die("cold")
