extends KinematicBody
export var speed = 14.0

signal move
var direction = Vector3.ZERO
var velocity = Vector3.ZERO

func get_direction() -> Vector3:
	return Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		0
	)

func _physics_process(delta: float) -> void:
	direction = get_direction()
	
	if Input.is_action_pressed("move_forward"):
		emit_signal("move")
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity = move_and_slide(velocity, Vector3.UP)
