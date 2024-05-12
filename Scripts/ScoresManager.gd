extends Control

@onready var high_score_label = $HBoxContainer/HighScoreContainer/VBoxContainer/HighScore
@onready var current_score_label = $HBoxContainer/CurrentScoreContainer/VBoxContainer/CurrentScore

var score := 0:
	set(value):
		score = value
		current_score_label.text = str(score)
var current_high_score := 0:
	set(value):
		current_high_score = value
		high_score_label.text = str(current_high_score)


func _ready() -> void:
	var save_file := FileAccess.open("user://save2048.data", FileAccess.READ)
	# If the file is not exist yet
	if save_file == null:
		current_high_score = 0
		# Create the file for the first time
		save_high_score()
	else:
		current_high_score = save_file.get_32()


func save_high_score() -> void:
	var save_file := FileAccess.open("user://save2048.data", FileAccess.WRITE)
	save_file.store_32(current_high_score)


func _on_board_update_score(new_tile_val: int) -> void:
	score += new_tile_val
	if score > current_high_score:
		current_high_score = score
		save_high_score()


func _on_restart_button_down() -> void:
	score = 0


func _on_reset_button_down():
	if score == 0:
		current_high_score = 0
	else:
		current_high_score = score
	save_high_score()
