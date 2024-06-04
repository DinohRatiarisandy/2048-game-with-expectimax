extends Node

const pos = [
	[Vector2(10, 104), Vector2(148, 104), Vector2(286, 104), Vector2(424, 104)],
	[Vector2(10, 242), Vector2(148, 242), Vector2(286, 242), Vector2(424, 242)],
	[Vector2(10, 380), Vector2(148, 380), Vector2(286, 380), Vector2(424, 380)],
	[Vector2(10, 518), Vector2(148, 518), Vector2(286, 518), Vector2(424, 518)]
]

func get_pos(i: int, j: int) -> Vector2:
	return pos[i][j]
