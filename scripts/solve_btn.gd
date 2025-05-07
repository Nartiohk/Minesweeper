extends Button

signal solve

@onready var game_manager := $"../.."

func _ready() -> void:
	game_manager.game_manager_won.connect(_disabled)
	game_manager.game_manager_lose.connect(_disabled)
	self.text = "Solve"
	self.size = Vector2i(80, 35)

func _pressed() -> void:
	solve.emit()


func _disabled():
	self.disabled = true
