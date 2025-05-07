extends Node2D

signal place_flag
signal game_won
signal game_lose
signal first_click
#signal cell_primary_triggered(x: int, y: int)
#signal cell_secondary_triggered(x: int, y: int)

var cell_scene := load("res://scenes/cell.tscn")


@export var columns =  9
@export var rows = 9
@export var mines = 10

var first_time = true
var is_game_finished = false

var cells = []
var flag_cells = []
var mine_cells = []
var flags = 0

func _init() -> void:
	Config.load_config()
	if Config != null:
		columns = Config.grid_width
		rows = Config.grid_height
		mines = Config.mine_count
	# Initiate the cells
	for i in range(columns):
		cells.append([])
		for j in range(rows):
			var cell = cell_scene.instantiate()
			cell.cell_primary_triggered.connect(reveal_tile)
			cell.cell_chording_triggered.connect(chording_cell)
			cell.cell_secondary_triggered.connect(flag_tile)
			cell.initiate(i, j, false)
			cells[i].append(cell)
			add_child(cell)


func place_mines(cell):
		# Place mines
	var mine_placed = 0
	while mine_placed != mines:
		var i = randi() % columns
		var j = randi() % rows
		var cur_cell = cells[i][j]
		if cur_cell.is_mine or cell.x == i and cell.y == j:
			continue
		cur_cell.is_mine = true
		mine_cells.append(cur_cell)
		mine_placed += 1
		
		## Set value for all cells
	for i in range(columns):
		for j in range(rows):
			var cur_cell = cells[i][j]
			if cur_cell.is_mine:
				continue
			var cell_value = count_adj_mine(cur_cell)
			cur_cell.value = cell_value


func count_adj_mine(cell):
	var adj_mines = 0
	if cell.is_mine:
		return -1
		
	for i in range(-1, 2):
		for j in range(-1, 2):
			#if j == 0 and i == 0: # dont need to check because already return if is_mine
				#continue
			var x = i + cell.x
			var y = j + cell.y
			if x < 0 or x > columns - 1 or y < 0 or y > rows - 1:
				continue
			if cells[x][y].is_mine:
				adj_mines += 1
	return adj_mines


func reveal_tile(cell):
	
	if first_time:
		place_mines(cell)
		self.place_flag.emit(mines)
		self.first_click.emit()
		first_time = false
		
		
	if cell.is_reveal or cell.is_flagged:
		return
	
	cell.reveal()
	
	if cell.is_mine:
		game_over()
		cell.draw_cell("exploded_mine")
		return
	
	var value = cell.value
	if value == 0:
		var neigbors = get_neighbors(cell)
		for neighbor in neigbors:
			reveal_tile(neighbor)


func flag_tile(cell):

	if cell.is_reveal:
		return
	
	var value = "hidden"
	if !cell.is_flagged:
		if flags >= mines:
			return
		flag_cells.append(cell)
		value = "flag"
		flags += 1

	elif cell.is_flagged:
		flag_cells.erase(cell)
		value = "hidden"
		flags -= 1

		
	cell.flag()
	place_flag.emit(mines - flags)

	
	var count = 0
	for flag_cell in flag_cells:
		for mine_cell in mine_cells:
			if flag_cell.x == mine_cell.x and flag_cell.y == mine_cell.y:
				count += 1
	
	if count == mines:
		win()


func win():
	is_game_finished = true
	reveal_all_value_cell()
	game_won.emit()


func game_over():
	is_game_finished = true
	reveal_all_mine_cell()
	game_lose.emit()


func reveal_all_mine_cell():
	for i in range(columns):
		for j in range(rows):
			var cell = cells[i][j]
			cell.disable()
			if cell.is_mine:
				cell.draw_cell("mine")
			if cell.is_flagged and !cell.is_mine:
				cell.draw_cell("cross_mine")
			if cell.is_flagged:
				cell.draw_cell("flag")


func reveal_all_value_cell():
	for i in range(columns):
		for j in range(rows):
			var cell = cells[i][j]
			cell.disable()
			if !cell.is_reveal and !cell.is_mine and !cell.is_flagged:
				var value = cell.value
				if value == 0:
					value = 'press'
				cell.draw_cell(value)


func get_neighbors(cell):
	var neighbors = []
	var dirs = [
		Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1,  0),                 Vector2(1,  0),
		Vector2(-1,  1), Vector2(0,  1), Vector2(1,  1)
	]
	for dir in dirs:
		var x = dir.x + cell.x
		var y = dir.y + cell.y

		if x >= 0 and y >= 0 and x < columns and y < rows:
			neighbors.append(cells[x][y])

	return neighbors


func set_mines(mines):
	if !mines:
		return
	for mine in mines:
		flag_tile(mine)
		
func count_adj_flag(cell):
	var flag = 0
	if !cell.is_reveal:
		return
	var neighbors = get_neighbors(cell)
	for neighbor in neighbors:
		if neighbor.is_flagged:
			flag += 1
	return flag
	
	
func safe_neighbors(cell):
	var safe_neighbors = []
	if !cell.is_reveal:
		return
	var neighbors = get_neighbors(cell)
	for neighbor in neighbors:
		if neighbor.is_flagged:
			continue
		safe_neighbors.append(neighbor)
	return safe_neighbors
	
	
func chording_cell(cell):
	if cell.value == count_adj_flag(cell):
		for safe in safe_neighbors(cell):
			reveal_tile(safe)
	
	
func open_cells():
	for i in range(columns):
		for j in range(rows):
			var cell = cells[i][j]
			chording_cell(cell)
