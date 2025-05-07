extends SolvingMethod

class_name NaiveMethod

func solve(groups):
	var mines = []
	var group = []
	for i in groups:
		group = i.cells
		if group.size() == i.mine:
			print("mine")
			for j in group:
				if j in mines:
					continue
				mines.append(j)
	print(mines.size())
	for i in mines:
		print(i.x, i.y)
	
	return mines
