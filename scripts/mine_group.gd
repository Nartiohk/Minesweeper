extends Node

class_name MineGroup

var cells = []
var mine = 0
var group_typpe = ""

func _init(cells: Array, mine: int, group_type = "exactly") -> void:
	self.cells = cells
	self.mine = mine
	self.group_typpe = group_type
