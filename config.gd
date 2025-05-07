extends Node

class_name Config

static var grid_width: int = 10
static var grid_height: int = 10
static var mine_count: int = 10
static var title: String = "Minesweeper"

const CONFIG_FILE_PATH: String = "user://minesweeper_config.cfg"


enum Difficulty {
	BEGINNER,
	INTERMEDIATE,
	EXPERT,
	CUSTOM
}

static func _init():
	load_config() 
	
	
static func set_difficulty(difficulty: int) -> void:
	match difficulty:
		Difficulty.BEGINNER:
			grid_width = 9
			grid_height = 9
			mine_count = 10
		Difficulty.INTERMEDIATE:
			grid_width = 16
			grid_height = 16
			mine_count = 40
		Difficulty.EXPERT:
			grid_width = 30
			grid_height = 16
			mine_count = 99
		Difficulty.CUSTOM:
			#  values will be whatever the user set them to.
			pass
		_:
			push_error("Invalid difficulty level: %s" % difficulty)


static func save_config() -> void:
	var config_data = {
		"grid_width": grid_width,
		"grid_height": grid_height,
		"mine_count": mine_count,
		"title": title
	}
	var json_string = JSON.stringify(config_data)

	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Minesweeper configuration saved to %s" % CONFIG_FILE_PATH)
	else:
		push_error("Could not open file for writing: %s" % CONFIG_FILE_PATH)

# Static method to load the configuration from a file.  Using JSON for better data handling.
static func load_config() -> void:
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		if not json_string.is_empty():
			var config_data = JSON.parse_string(json_string)
			if typeof(config_data) == TYPE_DICTIONARY:
				grid_width = config_data.get("grid_width", 9)  # Use defaults if keys are missing
				grid_height = config_data.get("grid_height", 9)
				mine_count = config_data.get("mine_count", 10)
				title = config_data.get("title", "Minesweeper")
				print("Minesweeper configuration loaded from %s" % CONFIG_FILE_PATH)
			else:
				push_error("Invalid data format in config file.")
				print("Using default configuration.")
		else:
			print("Config file is empty. Using default settings.")
	else:
		# File doesn't exist or error.  Use defaults.
		if file and file.is_resource_load_error():
			push_error("Error loading config file: %s" % CONFIG_FILE_PATH)
		print("Using default configuration.")
