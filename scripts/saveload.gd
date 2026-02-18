extends Control

const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"night_number": 1,
	"master_volume": 0.0,
	"vfx_volume": 0.0
}

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()


func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.night_number = save_data.night_number
		contents_to_save.master_volume = save_data.master_volume
		contents_to_save.vfx_volume = save_data.vfx_volume
