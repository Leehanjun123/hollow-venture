extends Camera2D
## Hollow Knight style camera controller
## Features: Smooth follow, lookahead, room boundaries

# Camera settings (Hollow Knight values)
const FOLLOW_SPEED: float = 3.0  # How fast camera follows player
const LOOKAHEAD_DISTANCE: float = 100.0  # How far ahead to look when facing direction
const LOOKAHEAD_SPEED: float = 2.0  # How fast lookahead adjusts
const VERTICAL_OFFSET: float = -50.0  # Slight upward offset to see more above

# Room boundaries (set by room script)
var room_bounds: Rect2 = Rect2(0, 0, 1152, 768)  # Default bounds
var use_room_bounds: bool = true

# Internal state
var target_position: Vector2 = Vector2.ZERO
var current_lookahead: Vector2 = Vector2.ZERO
var player: CharacterBody2D = null


func _ready() -> void:
	# Make this camera current
	make_current()

	# Find player
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

	if not player:
		push_warning("CameraController: Player not found!")
		return

	# Initialize camera position to player position
	global_position = player.global_position + Vector2(0, VERTICAL_OFFSET)
	target_position = global_position

	print("CameraController: Initialized, following player")


func _process(delta: float) -> void:
	if not player:
		return

	# Calculate lookahead based on player facing direction
	var lookahead_target := Vector2.ZERO
	if player.facing_right:
		lookahead_target.x = LOOKAHEAD_DISTANCE
	else:
		lookahead_target.x = -LOOKAHEAD_DISTANCE

	# Smoothly interpolate lookahead
	current_lookahead = current_lookahead.lerp(lookahead_target, LOOKAHEAD_SPEED * delta)

	# Calculate target camera position
	target_position = player.global_position + Vector2(0, VERTICAL_OFFSET) + current_lookahead

	# Apply room boundaries if enabled
	if use_room_bounds:
		target_position = _apply_room_bounds(target_position)

	# Smoothly move camera to target position
	global_position = global_position.lerp(target_position, FOLLOW_SPEED * delta)


func _apply_room_bounds(pos: Vector2) -> Vector2:
	"""Constrain camera position to stay within room bounds"""
	var viewport_size = get_viewport_rect().size / zoom

	# Calculate the area the camera can move within
	var half_viewport_width = viewport_size.x / 2.0
	var half_viewport_height = viewport_size.y / 2.0

	# Clamp camera position to keep viewport within room bounds
	var clamped_pos = pos
	clamped_pos.x = clamp(pos.x, room_bounds.position.x + half_viewport_width, room_bounds.position.x + room_bounds.size.x - half_viewport_width)
	clamped_pos.y = clamp(pos.y, room_bounds.position.y + half_viewport_height, room_bounds.position.y + room_bounds.size.y - half_viewport_height)

	return clamped_pos


func set_room_bounds(bounds: Rect2) -> void:
	"""Set the camera boundaries for current room"""
	room_bounds = bounds
	print("CameraController: Room bounds set to %s" % bounds)


func enable_room_bounds(enabled: bool) -> void:
	"""Enable or disable room boundary constraints"""
	use_room_bounds = enabled
