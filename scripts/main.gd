extends Node2D

@export var level1 := load("res://scenes/forest.tscn")
@export var level2 := load("res://scenes/dungeon.tscn")
@export var level3 := load("res://scenes/town.tscn")
@export var player := load("res://scenes/player.tscn")
var camera

var level_instance = null
var player_instance = null
var level = 1

func add_level():
	add_child(level_instance)
func add_player():
	add_child(player_instance)
func load_level(level) -> void:
	print("Loading Level:", level)  # Debugging to make sure the level is being fed
	# Free the previous level if it exists
	if level_instance != null:
		print("Freeing previous level")  # Debugging to confirm the previous level is being freed
		level_instance.queue_free()
		player_instance.queue_free()
		level_instance = null
		player_instance = null
	
	# Create and add the new level instance based on the specified level
	if level == 1:
		level_instance = level1.instantiate()
		call_deferred("add_level")
		player_instance = player.instantiate()
		call_deferred("add_player")
		player_instance.position = Vector2(4452.711, 1644.627)
		player_instance.camera_update_limit(level)

		
	elif level == 2:
		level_instance = level2.instantiate()
		call_deferred("add_level")
		player_instance = player.instantiate()
		call_deferred("add_player")
		player_instance.position = Vector2(3996.595, 1338.277)
		player_instance.camera_update_limit(level)

	elif level == 3:
		level_instance = level3.instantiate()
		call_deferred("add_level")
		player_instance = player.instantiate()
		call_deferred("add_player")
		player_instance.position = Vector2(1929.312, 2379.309)
		player_instance.camera_update_limit(level)
