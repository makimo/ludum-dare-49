extends KinematicBody

var velocity = Vector3.ZERO

func _ready() -> void:
	pass # Replace with function body.

func initialize(start_position):
	translation = start_position
	
func move():
	velocity.z += 1
	move_and_slide(velocity)

func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()



