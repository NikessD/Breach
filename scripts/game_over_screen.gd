extends Node2D

## Konec hry

func _ready() -> void:
	if GlobalVars.ricky_killer:
		$RickyDeath.set_visible(true)
	elif GlobalVars.ardent_killer:
		$ArdentDeath.set_visible(true)
	else:
		$CageDeath.set_visible(true)
	$GameOverSound.play()


func _on_timer_timeout() -> void:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
