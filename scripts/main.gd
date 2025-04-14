extends Node2D

signal on_load_level
signal ready_to_load
@export var level1 := load("res://scenes/forest.tscn")
@export var level2 := load("res://scenes/dungeon.tscn")
@export var level3 := load("res://scenes/town.tscn")


var level_instance = null
var level = 1

func _ready() -> void:
	ready_to_load.emit()
	print_stack()
	print("Main ready. Player is: ", $Player)
	print("Main ready called from:", self.name)
	print("Main ready called from:", self.get_path())
	
		
func add_level():
	add_child(level_instance)

func load_level(level) -> void:
	print("Loading Level:", level)
	call_deferred("do_load_level", level)
	
func do_load_level(level) -> void:
	# Free the previous level if it exists
	if level_instance != null:
		print("Freeing previous level")  # Debugging to confirm the previous level is being freed
		level_instance.queue_free()
		level_instance = null
	if level == 1:
		print("Loading Level:", level)
		level_instance = level1.instantiate()
		call_deferred("add_level")
		await get_tree().process_frame  # Let the tree updates
		move_child($Player, get_child_count() - 1)
		$Player.reset(Vector2(4452.711, 1644.627))
		$Player.camera_update_limit(level)


		
	elif level == 2:
		print("Loading Level:", level)
		level_instance = level2.instantiate()
		call_deferred("add_level")
		await get_tree().process_frame  # Let the tree update
		move_child($Player, get_child_count() - 1)
		$Player.reset(Vector2(3996.595, 1338.277))
		$Player.camera_update_limit(level)


	elif level == 3:
		print("Loading Level:", level)
		level_instance = level3.instantiate()
		call_deferred("add_level")
		await get_tree().process_frame  # Let the tree update
		move_child($Player, get_child_count() - 1)
		$Player.reset(Vector2(1929.312, 2379.309))
		$Player.camera_update_limit(level)
	
	on_load_level.emit()
