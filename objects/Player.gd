extends KinematicBody

# I dont figure it out how to get this vectors from scene
# and have not to hardcode it
var left_point = Vector3(-6.353, 0.8, 9.405)
var right_point = Vector3(-0.743, 0.8, 9.405)
var point = left_point

var speed = 10.0
var direction = Vector3.ZERO

signal obstacle_on_way

onready var playerModel = $Pivot/PlayerModel
onready var collisionShape1 = $CollisionShape
onready var collisionShape2 = $ObstacleDetector/CollisionShape
onready var obstacleDetector = $ObstacleDetector

func change_direction():
	if Input.is_action_pressed("move_right"):
		point = right_point
	elif Input.is_action_pressed("move_left"):
		point = left_point
	if point.distance_to(transform.origin) > 0.2:
		direction = point - transform.origin
		direction = direction.normalized() * speed
	else:
		direction = point - transform.origin

func _physics_process(delta: float) -> void:
	change_direction()
	move_and_slide(direction)

func _on_ObstacleDetector_body_entered(body: Node) -> void:
	emit_signal("obstacle_on_way")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		playerModel.run_change_animation("left")
	if event.is_action_pressed("move_right"):
		playerModel.run_change_animation("right")

func set_target_movement(target_movement: float) -> void:
	playerModel.target_movement = clamp(target_movement, 0.0, 1.0)

func play_fall_animation() -> void:
	playerModel.play_fall_animation()
	collisionShape1.disabled = true
	collisionShape2.disabled = true
	obstacleDetector.monitoring = false
