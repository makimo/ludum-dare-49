extends KinematicBody

# I dont figure it out how to get this vectors from scene
# and have not to hardcode it
var left_point = Vector3(-6.353, 0.8, 9.405)
var right_point = Vector3(-0.743, 0.8, 9.405)
var point = left_point

var speed = 15.0
var direction = Vector3.ZERO

func change_direction():
	if Input.is_action_pressed("move_right"):
		point = right_point
	elif Input.is_action_pressed("move_left"):
		point = left_point
	if point.distance_to(transform.origin) > 0.05:
		direction = point - transform.origin
		direction = direction.normalized() * speed
	else:
		direction = point - transform.origin

func _physics_process(delta: float) -> void:
	change_direction()
	move_and_slide(direction)
