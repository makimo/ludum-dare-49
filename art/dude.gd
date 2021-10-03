extends Spatial

func _ready() -> void:
	$AnimationPlayer.current_animation = "idle"
	$AnimationPlayer.get_animation("idle").set_loop(true)
	$AnimationPlayer.get_animation("slow walk").set_loop(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		$AnimationPlayer.current_animation = "slow walk"
	if event.is_action_released("ui_left"):
		$AnimationPlayer.current_animation = "idle"
