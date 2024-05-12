extends ColorRect

@onready var auto_play_btn: Button = $"../Buttons/HBoxContainer/AutoPlay"


func _on_board_gameover() -> void:
	auto_play_btn.disabled = true
	visible = true
	self.create_tween().tween_property(self, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BOUNCE).set_delay(0.5)


func _make_invisible() -> void:
	if visible == true:
		visible = false
		self.scale = Vector2(0.2, 0.2)
