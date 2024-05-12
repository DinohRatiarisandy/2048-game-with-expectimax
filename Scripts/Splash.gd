extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		go_to_main_scene()


func go_to_main_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")


func _on_splash_finished(_anim_name: StringName) -> void:
	go_to_main_scene()
