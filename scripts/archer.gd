extends CharacterBody2D

@export var speed: float = 150
@export var shoot_cooldown: float = 2.5
@export var detection_range: float = 1500.0
@export var arrow_scene: PackedScene

@onready var sprite = $AnimatedSprite2D
@onready var left_ray = $LeftRay
@onready var right_ray = $RightRay
@onready var collision = $CollisionShape2D
@onready var player = get_node("/root/main/Player")  # Adjust path if needed

var triggered = false
var direction: int = 1   # -1 = left, 1 = right
var shoot_timer = 0.0
var is_aiming = false    # Flag: true when we're aiming and waiting to shoot

func _physics_process(delta):
	shoot_timer -= delta

	# Patrol logic if not triggered
	if not triggered and not is_aiming:
		velocity.x = direction * speed
		if left_ray.is_colliding() and direction == -1:
			flip_direction()
		elif right_ray.is_colliding() and direction == 1:
			flip_direction()
		move_and_slide()
		for i in range(get_slide_collision_count()):
			var coll = get_slide_collision(i)
			if coll.get_collider().is_in_group("player"):
				coll.get_collider().hurt()
				break

	# When player is detected (within range) begin aiming, regardless of patrol
	if is_instance_valid(player) and global_position.distance_to(player.global_position) < detection_range:
		face_player()  # Plays the appropriate aim animation
		is_aiming = true

func face_player():
	var to_player = player.global_position - global_position
	direction = sign(to_player.x)
	sprite.flip_h = direction < 0
	# Choose animation based on whether player is more horizontal or vertical relative to the archer
	if abs(to_player.x) > abs(to_player.y):
		if direction < 0:
			sprite.play("aim_left")
		else:
			sprite.play("aim_right")
	else:
		if to_player.y < 0:
			sprite.play("aim_up")
		else:
			sprite.play("aim_down")


func shoot_arrow():
	if triggered or not arrow_scene:
		return
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	# Aim arrow at the player
	arrow.look_at(player.global_position)
	arrow.velocity = (player.global_position - global_position).normalized() * 400
	arrow.rotation = arrow.velocity.angle()

func flip_direction():
	print("flipped direction")
	direction *= -1
	sprite.flip_h = !sprite.flip_h

func hurt():
	if triggered:
		return
	print("take damage was called")
	call_deferred("disable_collision")
	triggered = true
	sprite.hide()
	await get_tree().create_timer(3).timeout
	queue_free()

func disable_collision():
	collision.disabled = true


func _on_animated_sprite_2d_animation_looped() -> void:
			# When the aiming animation finishes, shoot if we are in aiming state and cooldown expired.
	if is_aiming and shoot_timer <= 0:
		print("shhot")
		shoot_arrow()
		shoot_timer = shoot_cooldown
		# Optionally reset is_aiming to false so enemy goes back to patrolling until next detection:
		is_aiming = false
