extends Node2D

class_name Solver


var methods: Array = []
var groups: Array = []


func _init() -> void:
	var naive = NaiveMethod.new()
	self.add_method(naive)


func add_method(method: SolvingMethod):
	if method not in methods:
		methods.append(method)


func method_solve():
	var mines = []
	for method in methods:
		mines = method.solve(groups)
	return mines

func generate_groups(board):
	# Go through all tile that is numbered
	# At tile(x, y) get all neightbor tiles that are covered
	# and make a MineGroup and append to groups
	groups = []
	for x in board.columns:
		for y in board.rows:
			var cell = board.cells[x][y]
			if cell.value <= 0 or !cell.is_reveal:
				continue
				
			var covered_neighbors = []
			var active_mine = cell.value
			var neighbors = board.get_neighbors(cell)

			for neighbor in neighbors:
				if !neighbor.is_reveal and !neighbor.is_flagged:
					covered_neighbors.append(neighbor)
					
				if neighbor.is_flagged:
					active_mine -= 1

			if covered_neighbors:
				var new_group = MineGroup.new(covered_neighbors, active_mine)
				self.groups.append(new_group)
