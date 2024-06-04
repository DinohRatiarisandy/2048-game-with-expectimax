extends Node2D

signal move

const inputs := {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN
}


func _unhandled_input(event) -> void:
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			emit_signal("move", direction)
