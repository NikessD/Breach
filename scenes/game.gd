extends Node2D

@onready var office = $Office
@onready var ricky = $Office/Ricky
@onready var ardent = $Office/Ardent

var nvm: int 

func _ready():
	office.begining_set_ai()
	
func _on_ambient_sounds_timer_timeout() -> void:
	$AmbientSounds/Creepyambience2.play()
	$AmbientSounds/Creepyambience1.play()
	$AmbientSounds/Creepyambience2.volume_db = -1000000000
	$AmbientSounds/Creepyambience1.volume_db = -1000000000
	var random_ambient = randi_range(1,10)
	if random_ambient == 8:
		$AmbientSounds/Creepyambience1.volume_db = -51
		$AmbientSounds/Creepyambience2.volume_db = -1000000000
	elif random_ambient == 1:
		$AmbientSounds/Creepyambience1.volume_db = -1000000000
		$AmbientSounds/Creepyambience2.volume_db = -27





func begining_set_ai():
	match GlobalVars.night_number:
		1:
			ardent.ai = 0
			ricky.ai = 3
		2:
			ardent.ai = 1
			ricky.ai = 5
		3:
			ardent.ai = 3
			ricky.ai = 7
		4:
			ardent.ai = 4
			ricky.ai = 9
		5:
			ardent.ai = 6
			ricky.ai = 12
		6:
			ardent.ai = 20
			ricky.ai = 20
		null:
			ardent.ai = 20
			ricky.ai = 20
