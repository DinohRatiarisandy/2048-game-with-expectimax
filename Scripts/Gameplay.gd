extends Node2D

signal bot_solver_playing

var auto_play := false

const DIRECTIONS := ["move_up", "move_right", "move_down", "move_left"]

@onready var board: Board = $Board
@onready var auto_play_btn: Button = $Buttons/HBoxContainer/AutoPlay


func toggle_auto_play_btn() -> void:
	auto_play = not auto_play
	if  auto_play_btn.text == "autoplay":
		auto_play_btn.text = "stop"
	else:
		auto_play_btn.text = "autoplay"


func _on_keyboard_control_move(direction: String) -> void:
	board.play(direction)


func _on_restart_button_down() -> void:
	get_tree().reload_current_scene()

func _on_auto_play_button_down() -> void:
	toggle_auto_play_btn()
	var ai := BotSolver.new();
	while auto_play:
		board.play(ai.best_move(board, 3))
		await get_tree().create_timer(0.25).timeout
	ai.free()
