extends Button


func _ready() -> void:

	self.text = "Restart"
	self.size = Vector2i(80, 35)

func _pressed() -> void:
	get_tree().reload_current_scene()
