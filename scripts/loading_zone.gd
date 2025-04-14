extends Area2D

@export var target = 1
var triggered = false


func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	triggered = true
	print("loading zone trigger to ", target)
	Main.load_level(target)
	await get_tree().create_timer(0.2).timeout
	triggered = false
	
