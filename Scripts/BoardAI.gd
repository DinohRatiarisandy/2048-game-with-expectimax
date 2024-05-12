class_name BoardAI extends Node

const WIDTH := 4
const HEIGHT := 4

var state := []


func add_tile(pos: Vector2i, tile_val: int) -> void:
	if tile_val == 0:
		state[pos.x][pos.y].queue_free()
		state[pos.x][pos.y] = null
	else:
		var tile := Tile.new()
		tile.value = tile_val
		state[pos.x][pos.y] = tile


func get_blank_cells() -> Array:
	var valid_cell_idx := []
	for i in range(WIDTH):
		for j in range(HEIGHT):
			if state[i][j] == null:
				valid_cell_idx.append(Vector2i(i, j))
	return valid_cell_idx


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
						swap(Vector2i(i, j), Vector2i(i, j - shift))
						moved = true

					if (
						j - shift - 1 >= 0
						and state[i][j - shift].value == state[i][j - shift - 1].value
						and merged[i][j - shift - 1] == false
					):
						var new_tile_val = state[i][j - shift - 1].value * 2
						#state[i][j - shift].queue_free()
						#state[i][j - shift - 1].queue_free()
						state[i][j - shift] = null
						state[i][j - shift - 1] = null
						var tile := Tile.new()
						tile.value = new_tile_val
						state[i][j - shift - 1] = tile
						merged[i][j - shift - 1] = true
						moved = true

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
						swap(Vector2i(i, j), Vector2i(i - shift, j))
						moved = true

					if (
						i - shift - 1 >= 0
						and state[i - shift][j].value == state[i - shift - 1][j].value
						and merged[i - shift - 1][j] == false
					):
						var new_tile_val = state[i - shift - 1][j].value * 2
						#state[i - shift][j].queue_free()
						#state[i - shift - 1][j].queue_free()
						state[i - shift][j] = null
						state[i - shift - 1][j] = null
						var tile := Tile.new()
						tile.value = new_tile_val
						state[i - shift - 1][j] = tile
						merged[i - shift - 1][j] = true
						moved = true

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
