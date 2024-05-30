class_name BotSolver extends Object
"""
	This class is responsable to solve the 2048 game.
	It's implement the EXPECITMAX algorithm.
"""

const INFINITY := 2**64
const DIRECTIONS := ["move_up", "move_down", "move_left", "move_right"]
const PERFECT_SNAKE := [
	[2, 2**2, 2**3, 2**4],
	[2**8, 2**7, 2**6, 2**5],
	[2**9, 2**10,2**11, 2**12],
	[2**16, 2**15,2**14, 2**13]
]


func deepcopy(board: Array) -> Array:
	var new_state := []
	for i in range(board.size()):
		new_state.append([])
		for j in range(board[i].size()):
			if board[i][j]:
				new_state[i].append(board[i][j])
			else:
				new_state[i].append(null)
	return new_state


func snake_heuristic(board: BoardAI) -> int:
	var h := 0
	for i in range(board.WIDTH):
		for j in range(board.HEIGHT):
			if board.state[i][j]:
				h += board.state[i][j].value * PERFECT_SNAKE[i][j]
	return h


func best_move(board: Board, depth: int) -> String:
	var best_score := -INFINITY
	var best_next_move := DIRECTIONS[0]
	var results := []
	for dir in DIRECTIONS:
		var sim_board := BoardAI.new()
		sim_board.state = deepcopy(board.state)
		var is_moved = sim_board.move_tiles(dir)
		if is_moved == false:
			continue
		results.append(expectimax(sim_board, depth, dir, false))
		sim_board.free()
	for res in results:
		if res[0] >= best_score:
			best_score = res[0]
			best_next_move = res[1]
	return best_next_move


func expectimax(board_ai: BoardAI, depth: int, dir: String, is_player_max: bool) -> Array:
	if board_ai.is_game_over() == true:
		board_ai.free()
		return [-INFINITY, dir]
	elif depth == 0:
		return [snake_heuristic(board_ai), dir]

	var a := 0
	if is_player_max == true:
		a = -INFINITY
		for d in DIRECTIONS:
			var sim_board := BoardAI.new()
			sim_board.state = deepcopy(board_ai.state)
			var is_moved := sim_board.move_tiles(d)
			if is_moved:
				var res = expectimax(sim_board, depth - 1, d, false)
				if res[0] > a:
					a = res[0]
			sim_board.free()
	elif is_player_max == false:
		a = 0
		var open_cells := board_ai.get_blank_cells()
		for open_cell in open_cells:
			board_ai.add_tile(open_cell, 2)
			a += 1.0/len(open_cells) * expectimax(board_ai, depth - 1, dir, true)[0]
			board_ai.add_tile(open_cell, 0)
	return [a, dir]
