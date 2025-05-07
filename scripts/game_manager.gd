extends Node2D


@onready var game_logic = $GameLogic

signal game_manager_won
signal game_manager_lose
signal game_manager_first_click
signal game_manager_place_flag

func _ready():
	get_window().title = Config.title
	game_logic.board.position = Vector2i(320 - Config.grid_width * 16 / 2, (240 * 5/4) - Config.grid_height * 16 / 2)
	game_logic.game_logic_won.connect(on_game_won)
	game_logic.game_logic_lose.connect(on_game_lose)
	game_logic.board.first_click.connect(on_first_click)
	game_logic.board.place_flag.connect(on_place_flag)


func _on_difficulty_btn_item_selected(index: int) -> void:
	var diff
	match index:
		0: diff = Config.Difficulty.BEGINNER
		1: diff = Config.Difficulty.INTERMEDIATE
		2: diff = Config.Difficulty.EXPERT
		_: diff = Config.Difficulty.CUSTOM
	Config.set_difficulty(diff)
	Config.save_config()
	get_tree().reload_current_scene()
	
	
func on_game_won():
	game_manager_won.emit()
	
	
func on_game_lose():
	game_manager_lose.emit()
	
func on_first_click():
	game_manager_first_click.emit()

func on_place_flag(flags):
	print("check flags " + str(flags))
	game_manager_place_flag.emit(flags)
