extends Label

var score = 0

func _on_Main_update_score(value) -> void:
	score += value
	text = "Score: %s" % score
