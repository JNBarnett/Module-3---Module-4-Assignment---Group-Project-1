extends CharacterBody2D

signal life_changed
signal died

@export var walk_speed = 100
@export var max_speed = 200

enum {IDLE, WALK, HURT, DEAD, ATTACK}
enum {NONE, UP, DOWN, LEFT, RIGHT}

var state = IDLE
var direction = NONE
var reset_life = 3
var life = 3


func _ready():
	change_state(IDLE)
	set_life(reset_life)

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
	set_life(reset_life)
	
func hurt() -> void:
	if state != HURT:
		$HurtSound.play()
		change_state(HURT)

func die() -> void:
	if state != DEAD:
		change_state(DEAD)
		
func set_life(value):
	life = value	
	life_changed.emit(life)
	
func get_input() -> Array:
	if state == HURT:
		return []  # Don't allow movement during hurt state
	
	# Get player input
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var attack = Input.is_action_pressed("attack")

	# Handle movement
	velocity = Vector2(0, 0)
	
	# Horizontal movement: prioritize right over left and left over right
	if right:
		velocity.x += walk_speed
	if left:
		velocity.x -= walk_speed

	# Vertical movement: prioritize up over down and down over up
	if up:
		velocity.y -= walk_speed
	if down:
		velocity.y += walk_speed

	# Determine movement direction
	if velocity.x > 0:
		change_dir(RIGHT)
	elif velocity.x < 0:
		change_dir(LEFT)
	elif velocity.y > 0:
		change_dir(DOWN)
	elif velocity.y < 0:
		change_dir(UP)

	# Handle attack input (should trigger ATTACK state)
	if attack and state != ATTACK:
		change_state(ATTACK)

	# State transitions based on velocity
	if state == IDLE and velocity.length() > 0:
		change_state(WALK)
	elif state == WALK and velocity.length() == 0:
		change_state(IDLE)

	# Return the inputs as an array (optional for debugging or additional logic)
	return [right, left, up, down, attack]

func change_dir(new_direction):
	direction = new_direction
	$back.visible = (direction == UP)
	$front.visible = (direction == DOWN)
	$side.visible = (direction == LEFT or direction == RIGHT)
	
	# Flip sprite horizontally for left/right
	if direction == LEFT:
		$side.flip_h = true
	else:
		$side.flip_h = false


func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			match direction:
				RIGHT, LEFT:
					$side.play("side_idle")  # Play idle animation once
				UP:
					$back.play("back_idle")
				DOWN:
					$front.play("idle")
				
		WALK:
			match direction:
				RIGHT, LEFT:
					$side.play("side_walk")
				UP:
					$back.play("back_walk")
				DOWN:
					$front.play("walk")
				
		ATTACK:
			match direction:
				RIGHT:
					$side.play("side_attack")
					$Attack/AttackRight.disabled = false
				LEFT:
					$side.play("side_attack")  # Play attack animation once
					$Attack/AttackLeft.disabled = false
				UP:
					$back.play("back_attack")
					$Attack/AttackBack.disabled = false
				DOWN:
					$front.play("attack")
					$Attack/AttackFront.disabled = false
			await get_tree().create_timer(1).timeout
			for attack_box in $Attack.get_children():
				attack_box.disabled = true
				
			# After attack animation is finished, check for movement or idle state.
			if velocity.length() > 0:
				change_state(WALK)
			else:
				change_state(IDLE)

		HURT:
			velocity.y = -200  # Apply some vertical velocity for hurt state (optional)
			set_life(life - 1)
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
			if life <= 0:
				change_state(DEAD)
		
		DEAD:
			died.emit()
			hide()
			await get_tree().create_timer(2).timeout

func _physics_process(_delta) -> void:
	get_input()
	# Normalize the velocity to ensure consistent speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * walk_speed
	# Limit the velocity to max_speed (after normalization)
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			hurt()



var attack_triggered = false
func _on_attack_body_entered(body: Node2D) -> void:
	if attack_triggered:
		return
	if body is CharacterBody2D and body.is_in_group("enemies"):
		attack_triggered = true
		body.take_damage()
		attack_triggered = false
	
