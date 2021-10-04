extends Spatial

var moving = false

func _process(delta: float) -> void:
	$AvalancheMesh.translation.x += delta * 40 if moving else 0.0

func go() -> void:
	$Timer.stop()
	moving = true
	$Timer.start()

func _on_Timer_timeout() -> void:
	moving = false
