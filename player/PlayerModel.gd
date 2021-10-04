extends Spatial

export(float, 0.0, 1.0) var target_movement = 0.0

var movement = 0.0

var move_left_enabled = false
var move_right_enabled = false

var left_blend = 0
var right_blend = 0

const SPEED_UP_MOD = 1
const SPEED_DOWN_MOD = 2

func _ready() -> void:
	$AnimationPlayer.get_animation("idle").set_loop(true)
	$AnimationPlayer.get_animation("fast walk").set_loop(true)
	$AnimationPlayer.get_animation("slow walk").set_loop(true)
	$AnimationPlayer.get_animation("change left").set_loop(true)
	$AnimationPlayer.get_animation("change right").set_loop(true)

func _process(delta: float) -> void:
	movement = clamp(move_toward(movement, target_movement, delta * (SPEED_UP_MOD if target_movement >= movement else SPEED_DOWN_MOD)), 0.0, 1.0)

	$AnimationTree.set("parameters/movement/blend_position", movement)

	left_blend = clamp(move_toward(left_blend, 0.5 if move_left_enabled else 0, delta), 0, 0.5)
	right_blend = clamp(move_toward(right_blend, 0.5 if move_right_enabled else 0, delta), 0, 0.5)

	$AnimationTree.set("parameters/move left blend/blend_amount", left_blend)
	$AnimationTree.set("parameters/move right blend/blend_amount", right_blend)

func run_change_animation(direction: String) -> void:
	if $Timer.is_stopped():
		match direction:
			"left":
				$Timer.start()
				move_left_enabled = true

			"right":
				$Timer.start()
				move_right_enabled = true
			_:
				pass


func _on_Timer_timeout() -> void:
	move_left_enabled = false
	move_right_enabled = false
	$Timer.stop()
