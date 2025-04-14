extends CharacterBody2D

@onready var hud = get_node("/root/main/HUD")



@export var speed: float = 150  # Speed of the enemy
@onready var sprite = $AnimatedSprite2D # Reference to sprite
@onready var left_ray = $LeftRay  # Left-facing ray
@onready var right_ray = $RightRay  # Right-facing ray
@onready var collision = $CollisionShape2D

var direction: int = 1  # -1 = left, 1 = right

func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _physics_process(_delta):
	# Move enemy left or right
	velocity = Vector2.ZERO
	velocity.x = direction * speed
		# Check for collision using raycasts
	if left_ray.is_colliding() and direction == -1:
		flip_direction()
	elif right_ray.is_colliding() and direction == 1:
		flip_direction()
		
	move_and_slide()
	
			


func flip_direction() -> void:
	print("flipped direction")
	direction *= -1  # Reverse direction
	sprite.flip_h = !sprite.flip_h  # Flip sprite horizontally.

	
func _on_area_2d_body_entered(body: Node2D) -> void:
	hud.win()
