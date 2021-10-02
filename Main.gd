extends Node

export (PackedScene) var obstacle_scene = preload("obstacles/Obstacle.tscn")
export var max_obstacle_objects = 2
var obstacle_array = []

func _ready() -> void:
	randomize()

func obstacle_or_not_obstacle() -> bool:
	return randf() > 0.92

func _on_Player_move() -> void:
	obstacle_array = get_tree().get_nodes_in_group("OBS")
	if obstacle_or_not_obstacle() and obstacle_array.size() < max_obstacle_objects:
		var obstacle = obstacle_scene.instance()
		var obstacle_location = $SpawnPoints/LeftPoint if randi() % 2 == 0 else $SpawnPoints/RightPoint
		
		add_child(obstacle)
		obstacle_array.append(obstacle)
		obstacle.initialize(obstacle_location.translation)
	get_tree().call_group("OBS", "move")
