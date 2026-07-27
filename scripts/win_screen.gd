extends Control


func _ready() -> void:
	if GlobalVars.night_number < 6:
		GlobalVars.night_number += 1
	Saveload.contents_to_save.night_number = GlobalVars.night_number
	Saveload._save()
	$"Deep-strange-whoosh-183845".play()
	$CenterContainer/Night.text = "SHIFT COMPLETED" 
	GlobalVars.hour = 0

func _on_timer_timeout() -> void:
	$CenterContainer/Night.set_visible(false)
	$AnimatedSprite2D.set_visible(true)
	$AnimatedSprite2D.play("Static")
	$HumSoundPlayer.play()
	$BuzzAudioStreamPlayer.play()
	await get_tree().create_timer(1).timeout
	$HumSoundPlayer.stop()
	$BuzzAudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
