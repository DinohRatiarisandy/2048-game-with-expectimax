class_name Board extends Node

"""
This class is to control the function of the state state.
These functions are creating tiles, finding blank spaces,
moving / deleting / replacing tiles
"""

signal  gameover
signal update_score(score)

@export var four_chance := 20;

const WIDTH := 4
const HEIGHT := 4
const TILE := preload("res://Scenes/Tile/Tile.tscn")
const OFFSET := Vector2(64, 64)

var state := []

@onready var board: Node2D = $"."


func print_state() -> void:
	var tab := [
		[0, 0, 0, 0],
		[0, 0, 0, 0],
		[0, 0, 0, 0],
		[0, 0, 0, 0]
	]
	for i in range(WIDTH):
		for j in range(HEIGHT):
			if state[i][j]:
				tab[i][j] = state[i][j].value
	
	for row in tab:
		print(row)
	
	print("------------")


func _ready() -> void:
	initialize()


func initialize() -> void:
	randomize()
	state = create_state()
	spawn_new_tile()
	spawn_new_tile()


func create_state() -> Array:
	var array := []
	for i in range(WIDTH):
		array.append([])
		for j in range(HEIGHT):
			array[i].append(null)
	return array


func get_blank_cell() -> Vector2i:
	var valid_cell_idx := []
	for i in range(WIDTH):
		for j in range(HEIGHT):
			if state[i][j] == null:
				valid_cell_idx.append(Vector2i(i, j))
	return valid_cell_idx.pick_random()


func get_two_or_four() -> int:
	var chance := randi_range(1, 100)
	if chance <= (100 - four_chance): return 2
	else: return 4


func spawn_new_tile() -> void:
	var valid_cell_idx := get_blank_cell()
	var new_tile_val := get_two_or_four()
	var tile := TILE.instantiate()
	tile.value = new_tile_val
	state[valid_cell_idx.x][valid_cell_idx.y] = tile
	add_child(tile)
	tile.global_position = GridCoord.get_pos(valid_cell_idx.x, valid_cell_idx.y) + OFFSET
	tile.scale = Vector2(0, 0)
	tile.spawn_anim()
	tile.set_image(str(new_tile_val))


func reverse_state(key: String) -> void:
	if key == "column":
		for col in state:
			col.reverse()
	elif key == "row":
		state.reverse()


func swap(pos_A: Vector2i, pos_B: Vector2i) -> void:
	var tmp = state[pos_B.x][pos_B.y]
	state[pos_B.x][pos_B.y] = state[pos_A.x][pos_A.y]
	state[pos_A.x][pos_A.y] = tmp


func move_tiles(direction: String) -> bool:
	var moved := false
	var merged := [
		[false, false, false, false],
		[false, false, false, false],
		[false, false, false, false],
		[false, false, false, false]
	]
	
	if direction == "move_left" or direction == "move_right":
		if direction == "move_right":
			reverse_state("column")
		for i in range(WIDTH):
			for j in range(HEIGHT):
				if j > 0 and state[i][j]:
					var shift := 0
					for j_backward in range(j):
						if state[i][j_backward] == null:
							shift += 1

					if shift > 0:
						var column_idx := ~(j - shift) + WIDTH if direction == "move_right" else j - shift
						state[i][j].slide_anim(GridCoord.get_pos(i, column_idx) + OFFSET)
						swap(Vector2i(i, j), Vector2i(i, j - shift))
						state[i][j - shift].set_image(str(state[i][j - shift].value))
						moved = true

					if (
						j - shift - 1 >= 0
						and state[i][j - shift].value == state[i][j - shift - 1].value
						and merged[i][j - shift - 1] == false
					):
						var column_idx := ~(j - shift - 1) + WIDTH if direction == "move_right" else j - shift - 1
						var new_tile_val = state[i][j - shift - 1].value * 2
						state[i][j - shift].remove()
						state[i][j - shift - 1].remove()
						state[i][j - shift] = null
						state[i][j - shift - 1] = null
						var tile := TILE.instantiate()
						add_child(tile)
						tile.value = new_tile_val
						tile.global_position = GridCoord.get_pos(i, column_idx) + OFFSET
						tile.scale = Vector2(1.5, 1.5)
						tile.merge_anim()
						tile.set_image(str(new_tile_val))
						state[i][j - shift - 1] = tile
						merged[i][j - shift - 1] = true
						moved = true
						emit_signal("update_score", new_tile_val)

		if direction == "move_right":
			reverse_state("column")

	elif direction == "move_up" or direction == "move_down":
		if direction == "move_down":
			reverse_state("row")
		for i in range(WIDTH):
			for j in range(HEIGHT):
				if i > 0 and state[i][j]:
					var shift := 0
					for i_backward in range(i):
						if state[i_backward][j] == null:
							shift += 1

					if shift > 0:
						var row_idx := ~(i - shift) + HEIGHT if direction == "move_down" else i - shift
						state[i][j].slide_anim(GridCoord.get_pos(row_idx, j) + OFFSET)
						swap(Vector2i(i, j), Vector2i(i - shift, j))
						state[i - shift][j].set_image(str(state[i - shift][j].value))
						moved = true

					if (
						i - shift - 1 >= 0
						and state[i - shift][j].value == state[i - shift - 1][j].value
						and merged[i - shift - 1][j] == false
					):
						var row_idx := ~(i - shift - 1) + HEIGHT if direction == "move_down" else i - shift - 1
						var new_tile_val = state[i - shift - 1][j].value * 2
						state[i - shift][j].slide_anim(GridCoord.get_pos(row_idx, j) + OFFSET)
						state[i - shift][j].remove()
						state[i - shift - 1][j].remove()
						state[i - shift][j] = null
						state[i - shift - 1][j] = null
						var tile := TILE.instantiate()
						add_child(tile)
						tile.value = new_tile_val
						tile.global_position = GridCoord.get_pos(row_idx, j) + OFFSET
						tile.scale = Vector2(1.5, 1.5)
						tile.merge_anim()
						tile.set_image(str(new_tile_val))
						state[i - shift - 1][j] = tile
						merged[i - shift - 1][j] = true
						moved = true
						emit_signal("update_score", new_tile_val)

		if direction == "move_down":
			reverse_state("row")
	return moved

func is_game_over() -> bool:
	for i in range(WIDTH):
		for j in range(HEIGHT):
			if state[i][j] == null:
				return false
			if (
				j + 1 < WIDTH and
				(state[i][j + 1] == null or state[i][j].value == state[i][j + 1].value)
			):
				return false
			if (
				i + 1 < HEIGHT and 
				(state[i + 1][j] == null or state[i][j].value == state[i + 1][j].value)
			):
				return false
	return true


func clear_UI() -> void:
	for child in board.get_children():
		board.remove_child(child)


func play(direction: String) -> void:
	var tmp: Array = state.duplicate()
	var is_moved := move_tiles(direction)
	if is_moved == false: 
		state = tmp
		return
	# HACK: How to remove in memory the temporary array
	tmp.clear()
	await get_tree().create_timer(0.12).timeout
	spawn_new_tile()
	if is_game_over() == true:
		emit_signal("gameover")


func restart() -> void:
	clear_UI()
	initialize()

