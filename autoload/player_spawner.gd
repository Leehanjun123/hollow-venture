extends Node
## Player Spawner - Hollow Knight style
## Manages player instance across scene transitions

# Player instance (persistent across scenes)
var player_instance: CharacterBody2D = null

# Player scene to instantiate
const PLAYER_SCENE = preload("res://scenes/player/player.tscn")

# Current spawn point name (for room transitions)
var current_spawn_point: String = "DefaultSpawn"


func _ready() -> void:
	print("PlayerSpawner: Initialized")


func spawn_player(spawn_position: Vector2, parent_node: Node) -> void:
	"""Spawn player at specified position in the scene"""

	# Create player instance if it doesn't exist
	if not player_instance:
		player_instance = PLAYER_SCENE.instantiate()
		print("PlayerSpawner: Created new player instance")
	else:
		# Remove from previous parent
		if player_instance.get_parent():
			player_instance.get_parent().remove_child(player_instance)
		print("PlayerSpawner: Reusing existing player instance")

	# Set position and add to scene
	player_instance.global_position = spawn_position
	parent_node.add_child(player_instance)

	print("PlayerSpawner: Player spawned at %s" % spawn_position)


func spawn_player_at_marker(marker_name: String, room_node: Node) -> void:
	"""Spawn player at a named marker in the room"""

	# Find the marker node
	var marker = room_node.get_node_or_null(marker_name)

	if not marker:
		push_warning("PlayerSpawner: Spawn marker '%s' not found, using fallback" % marker_name)
		# Fallback to center of screen
		spawn_player(Vector2(576, 384), room_node)
		return

	# Spawn at marker position
	spawn_player(marker.global_position, room_node)
	current_spawn_point = marker_name


func set_next_spawn_point(spawn_point: String) -> void:
	"""Set which spawn point to use for next room"""
	current_spawn_point = spawn_point
	print("PlayerSpawner: Next spawn point set to '%s'" % spawn_point)


func get_player() -> CharacterBody2D:
	"""Get the current player instance"""
	return player_instance
