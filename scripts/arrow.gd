extends RigidBody2D

var velocity = Vector2.ZERO
var triggered = false

func _process(delta):
	position += velocity * delta
	# Continuously update rotation to follow velocity
	rotation = velocity.angle()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt()
		queue_free()
	else:
		queue_free()

func hurt():
	if triggered:
		return
	print("take damage was called")
	call_deferred("disable_collision")
	triggered = true
	$Sprite2D.hide()
	await get_tree().create_timer(3).timeout
	queue_free()

func disable_collision():
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
