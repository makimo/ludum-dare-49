extends Node

export (PackedScene) var obstacle_scene = preload("obstacles/Obstacle.tscn")
export (PackedScene) var background_scene = preload("res://background/Background_obj.tscn")
export var max_obstacle_objects = 2
export var max_background_objects = 6

func _ready() -> void:
	randomize()

func create_obstacle_object():
	if randf() > 0.92 and get_tree().get_nodes_in_group("OBS").size() < max_obstacle_objects:
		var obstacle = obstacle_scene.instance()
		var obstacle_location = $ObstacleSpawnPoints/LeftPoint if randi() % 2 == 0 else $ObstacleSpawnPoints/RightPoint
		add_child(obstacle)
		obstacle.initialize(obstacle_location.translation)
	
func create_background_object():
	if randf() > 0.95 and get_tree().get_nodes_in_group("BCK").size() < max_background_objects:
		var background_obj = background_scene.instance()
		var obj_location = $BackroundSpawnPoints.get_children()[randi() % $BackroundSpawnPoints.get_child_count()]
		add_child(background_obj)
		background_obj.initialize(obj_location.translation)
		
func _on_Player_move() -> void:
	create_obstacle_object()
	create_background_object()
	get_tree().call_group("OBS", "move")
	get_tree().call_group("BCK", "move")
