extends Node

export (PackedScene) var rock_scene = preload("res://objects/obstacles/Rock.tscn")
export (PackedScene) var log_scene = preload("res://objects/obstacles/Log.tscn")
export (PackedScene) var bear_scene = preload("res://objects/obstacles/Bear.tscn")
export (PackedScene) var background_scene = preload("res://objects/background/Background_obj.tscn")
export var max_obstacle_objects = 3
export var max_background_objects = 20

var obstacles_scenes = [rock_scene, log_scene, bear_scene]
var end_game = false

onready var player = $Player

func _ready() -> void:
	create_obstacle_object(true)
	randomize()

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
				end_game = true
				print('YOU DIE - BEAR')
	

func _on_AudioEnergy_audio_volume(value) -> void:
	player.set_target_movement(value)
	value *= 60
	if value >= 15:
		end_game = true
		print("YOU DIE - TO LOUD")
	if not end_game:
		check_killed_by_bear(value)
		create_obstacle_object()
		create_background_object()
		get_tree().call_group("OBS", "move", value)
		get_tree().call_group("BCK", "move", value)


func _on_Player_obstacle_on_way() -> void:
	print("OBSTACLE - YOU DIE")
	end_game = true
