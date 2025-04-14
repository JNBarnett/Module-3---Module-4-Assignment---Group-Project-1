extends CanvasLayer



func _on_button_pressed() -> void:
	Main.load_level(1)
	$".".visible = false
