extends Node2D

signal game_logic_won
signal game_logic_lose
#signal game_logic_place_flag

@onready var solver: Solver = $Solver
@onready var button: Button = $"../UI/SolveBtn"
@onready var board = $Board

enum methods {
	Naive,
	Test,
}

@export var method := methods.Naive


var remaining_flags = 0

func _ready() -> void:

	board.game_won.connect(on_game_won)
	board.game_lose.connect(on_game_lose)
	#board.place_flag.connect(on_place_flag)
	button.solve.connect(bot_solve)
	
	
func on_game_won():
	print("game win")
	game_logic_won.emit()
	
	
func on_game_lose():
	print("game lose")
	game_logic_lose.emit()
	

	
#func on_place_flag():
	#remaining_flags = board.mines - board.flags
	#game_logic_place_flag.emit(remaining_flags)


func bot_solve():
	solver.generate_groups(board)
	board.set_mines(solver.method_solve())
	board.open_cells()
