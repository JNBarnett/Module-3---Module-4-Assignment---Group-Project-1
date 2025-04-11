extends CharacterBody2D


@export var speed: float = 50  # Speed of the enemy
@onready var sprite = $Sprite2D  # Reference to sprite
@onready var left_ray = $LeftRay  # Left-facing ray
@onready var right_ray = $RightRay  # Right-facing ray

var triggered = false
var direction: int = -1  # -1 = left, 1 = right

func _physics_process(_delta):
	if triggered:
		return
	# Move enemy left or right
	velocity.x = direction * speed
	print("increased bubbles speed", velocity)
		# Check for collision using raycasts
	if left_ray.is_colliding() and direction == -1:
		flip_direction()
	elif right_ray.is_colliding() and direction == 1:
		flip_direction()
		
	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		print(collision.get_collider().name)
		if collision.get_collider().is_in_group("player"):  # Detect player collision
			collision.get_collider().hurt()  # Call the hurt function on the player
			break  # Stop checking once the player is hit
			


func flip_direction() -> void:
	print("flipped direction")
	direction *= -1  # Reverse direction
	sprite.flip_h = !sprite.flip_h  # Flip sprite horizontally.
	
func take_damage() ->  void:
	if triggered:
		return
	print("take damage was called")
	triggered = true
	$Sprite2D.hide()
	await get_tree().create_timer(3).timeout
	queue_free()
