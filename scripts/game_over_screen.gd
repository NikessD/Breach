extends Node2D


func _ready() -> void:
	if GlobalVars.ricky_killer:
		$ArdentDeath.set_visible(false)
		$RickyDeath.set_visible(true)
	else:
		$ArdentDeath.set_visible(true)
		$RickyDeath.set_visible(false)
	$GameOverSound.play()

func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
