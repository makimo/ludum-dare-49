extends KinematicBody
class_name Obj_base

var point = Vector3.ZERO
var speed = 4.0

func initialize(start_position):
	translation = start_position
	point = start_position

func move(steps):
	translation.z += steps

func _physics_process(_delta: float) -> void:
	pass
	# var direction = translation
	# if point.distance_to(transform.origin) > 0.05:
	# 	direction = point - transform.origin
	# 	direction = direction.normalized() * speed
	# else:
	# 	direction = point - transform.origin
	# move_and_slide(direction)


func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()



