extends Spatial

var moving = false

onready var particles = $AvalancheMesh/CPUParticles

func _process(delta: float) -> void:
	$AvalancheMesh.translation.x += delta * 40 if moving else 0.0

func go() -> void:
	$Timer.stop()
	moving = true
	particles.emitting = true
	$Timer.start()

func _on_Timer_timeout() -> void:
	particles.emitting = false
	moving = false
