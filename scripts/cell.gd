extends Node2D


const CELL_SIZE := 16

signal cell_primary_triggered(cell)
signal cell_chording_triggered(cell)
signal cell_secondary_triggered(cell)

#@onready var button_template := $Button as TextureButton
@onready var button = $Button as TextureButton

var texture_tile_set := preload("res://assets/Tileset.png")
var texture_tile = {
	"empty": Vector2i(0, 0) * CELL_SIZE,
	"press": Vector2i(1, 0) * CELL_SIZE,
	"flag": Vector2i(2, 0) * CELL_SIZE,
	"mine": Vector2i(5, 0) * CELL_SIZE,
	"exploded_mine": Vector2i(6, 0) * CELL_SIZE,
	"cross_mine": Vector2i(7, 0) * CELL_SIZE,
	1: Vector2i(0, 1) * CELL_SIZE,
	2: Vector2i(1, 1) * CELL_SIZE,
	3: Vector2i(2, 1) * CELL_SIZE,
	4: Vector2i(3, 1) * CELL_SIZE,
	5: Vector2i(4, 1) * CELL_SIZE,
	6: Vector2i(5, 1) * CELL_SIZE,
	7: Vector2i(6, 1) * CELL_SIZE,
	8: Vector2i(7, 1) * CELL_SIZE,
}

var value := 0
var x := 0
var y := 0

var is_reveal := false
var is_flagged := false
var is_mine := false
		
		
func initiate(x: int, y:int, is_mine:bool, is_reveal:= false, is_flag:= false) -> void:
	self.x = x
	self.y = y
	position = Vector2i(x * CELL_SIZE, y * CELL_SIZE)
	self.is_mine = is_mine


func draw_cell(type):

	var atlas := AtlasTexture.new()
	atlas.atlas = texture_tile_set
	atlas.region = Rect2(texture_tile[type], Vector2i(16, 16))
	self.button.texture_normal = atlas

func reveal():
	if is_flagged or is_reveal:
		return false
	self.is_reveal = true
	var type = value
	if value == 0:
		type = "press"
	if is_mine:
		type = "mine"
	draw_cell(type)
	return true


func flag():
	if is_reveal:
		return false
	if is_flagged:
		draw_cell("empty")
	else:
		draw_cell("flag")
	is_flagged = !is_flagged
	return true


func disable():
	$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				print("right click")
				cell_secondary_triggered.emit(self)
			MOUSE_BUTTON_LEFT:
				if self.is_reveal:
					cell_chording_triggered.emit(self)
				else:
					print("Reveal")
					cell_primary_triggered.emit(self)
