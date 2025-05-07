extends Label

@onready var game_manager = $"../.."

var time_elapsed := 0.0
# You don't really need this
var flags = 0



func _ready() -> void:
	game_manager.game_manager_place_flag.connect(_update)
	self.text = "Flags: "

func _update(flags):
	self.text = "Flags: " + str(flags)
