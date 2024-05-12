class_name Tile extends Node

@onready var tile_image: Sprite2D = $TileImage

var value: int

const ASSETS := {
	"2": "res://Assets/Tiles/tile_2.png",
	"4": "res://Assets/Tiles/tile_4.png",
	"8": "res://Assets/Tiles/tile_8.png",
	"16": "res://Assets/Tiles/tile_16.png",
	"32": "res://Assets/Tiles/tile_32.png",
	"64": "res://Assets/Tiles/tile_64.png",
	"128": "res://Assets/Tiles/tile_128.png",
	"256": "res://Assets/Tiles/tile_256.png",
	"512": "res://Assets/Tiles/tile_512.png",
	"1024": "res://Assets/Tiles/tile_1024.png",
	"2048": "res://Assets/Tiles/tile_2048.png",
	"4096": "res://Assets/Tiles/tile_4096.png",
	"8192": "res://Assets/Tiles/tile_8192.png"
}


func set_image(piece_val: String) -> void:
	tile_image.texture = load(ASSETS[piece_val])


func slide_anim(new_pos: Vector2) -> void:
	self.create_tween().tween_property(self, "global_position", new_pos, 0.13).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


func spawn_anim() -> void:
	self.create_tween().tween_property(self, "scale", Vector2.ONE, 0.13).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func merge_anim() -> void:
	self.create_tween().tween_property(self, "scale", Vector2.ONE, 0.09).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)


func remove() -> void:
	queue_free()

