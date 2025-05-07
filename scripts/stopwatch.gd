extends Label

@onready var game_manager = $"../.."

var time_elapsed := 0.0
# You don't really need this
var counter = 1
var is_started := false
var is_stopped := false

func _ready() -> void:
	game_manager.game_manager_won.connect(stop)
	game_manager.game_manager_lose.connect(stop)
	game_manager.game_manager_first_click.connect(start)
	

func _process(delta: float) -> void:
	if !is_stopped and is_started:
		time_elapsed += delta
		self.text = str(time_elapsed).pad_decimals(2)

func reset() -> void:
	# possibly save time_elapsed somewhere else before overriding it
	time_elapsed = 0.0
	is_stopped = false

func stop() -> void:
	is_stopped = true
	
	
func start() -> void:
	is_stopped = false
	is_started = true
