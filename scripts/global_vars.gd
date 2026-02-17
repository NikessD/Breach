extends Node

#General 
var night_number: int 
var hour: int = 1
var config = ConfigFile.new()

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
var masterVOL: float = 1
var vfxVOL: float = 1
var ambienceVOL: float = 1
