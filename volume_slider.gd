extends HSlider


@export var bus_name: String
@export var bus_index: int


func _set_volume() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(GlobalVars.volume[abs(bus_index)])
	)
	
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
