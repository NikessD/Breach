extends Node2D

## Obecná inicializace hry + ostatní věci při jejím běhu

@onready var office = $Office
@onready var ricky = $Office/Ricky
@onready var ardent = $Office/Ardent
@onready var cage = $Office/Cage
@onready var creepy_ambience1: AudioStreamPlayer = $AmbientSounds/CreepyAmbience1
@onready var creepy_ambience2: AudioStreamPlayer = $AmbientSounds/CreepyAmbience2


func _ready():
	begining_set_ai()


func _on_ambient_sounds_timer_timeout() -> void:
	creepy_ambience2.play()
	creepy_ambience1.play()
	creepy_ambience2.volume_db = -1000000000
	creepy_ambience1.volume_db = -1000000000
	var random_ambient = randi_range(1,10)
	if random_ambient == 8:
		creepy_ambience1.volume_db = -51
		creepy_ambience2.volume_db = -1000000000
	elif random_ambient == 1:
		creepy_ambience1.volume_db = -1000000000
		creepy_ambience2.volume_db = -27


func begining_set_ai():
	if GlobalVars.custom_night == true:
		pass
	else:
		match GlobalVars.night_number:
			1:
				ardent.ai = 0
				ricky.ai = 3
				cage.ai = 0
			2:
				ardent.ai = 0
				ricky.ai = 5
				cage.ai = 3
			3:
				ardent.ai = 3
				ricky.ai = 7
				cage.ai = 6
			4:
				ardent.ai = 4
				ricky.ai = 9
				cage.ai = 8
			5:
				ardent.ai = 6
				ricky.ai = 14
				cage.ai = 10
			6:
				ardent.ai = 12
				ricky.ai = 12
				cage.ai = 12
			null:
				ardent.ai = 20
				ricky.ai = 20
				cage.ai = 20


func _on_tutorial_button_pressed() -> void:
	if $Office/Tutorial/CamFeed.visible and GlobalVars.view_front:
		$Office/Tutorial/CamFeed.set_visible(false)
	elif !$Office/Tutorial/CamFeed.visible and GlobalVars.view_front:
		$Office/Tutorial/CamFeed.set_visible(true)
		
	if $Office/Tutorial/SideView.visible and !GlobalVars.view_front:
		$Office/Tutorial/SideView.set_visible(false)
	elif !$Office/Tutorial/SideView.visible and !GlobalVars.view_front:
		$Office/Tutorial/SideView.set_visible(true)
