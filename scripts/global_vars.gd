extends Node

#General 
var night_number: int 
var hour: int = 0
var config = ConfigFile.new()

#Custom night vars
var custom_night: bool = false
var ricky_custom_night_ai: int = 0
var ardent_custom_night_ai: int = 0
var cage_custom_night_ai: int = 0

#View controll
var view_left: bool = false
var view_right: bool = false
var view_front: bool = true
var light_button_is_pressed: bool = false

#Camera IDs
var camera_clicked: int = 1
var camera_ID: int = 1

#Kill states
var ardent_killer: bool
var ricky_killer: bool
var blackout: bool = false

#Volume control
var volume: Array = [0.5, 0.5]
