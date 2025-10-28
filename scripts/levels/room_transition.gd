extends Area2D
## Room Transition Trigger - Hollow Knight style
## Requires player to press interact button to transition

# Transition settings (set in editor)
@export_file("*.tscn") var target_scene: String = ""
@export var target_spawn_point: String = "DefaultSpawn"
@export var prompt_text: String = "Enter"  # Text to display

# Internal state
var player_in_area: bool = false
var can_transition: bool = true
var transition_cooldown: float = 0.5  # Prevent double-triggering

# UI nodes
var prompt_label: Label


func _ready() -> void:
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Set collision layer/mask to detect player only
	collision_layer = 0  # Don't occupy any layer
	collision_mask = 1   # Detect layer 1 (Player)

	if target_scene.is_empty():
		push_warning("RoomTransition: No target scene set!")

	# Create UI prompt
	_create_prompt()


func _create_prompt() -> void:
	"""Create the interaction prompt label"""
	prompt_label = Label.new()
	prompt_label.text = "↑ " + prompt_text
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Style the label
	prompt_label.add_theme_font_size_override("font_size", 20)
	prompt_label.modulate = Color.WHITE

	# Position above the transition area
	prompt_label.position = Vector2(-50, -80)
	prompt_label.size = Vector2(100, 30)

	# Hide initially
	prompt_label.visible = false

	add_child(prompt_label)


func _process(_delta: float) -> void:
	"""Check for interact input when player is in area"""
	if not player_in_area:
		return

	if not can_transition:
		return

	# Check for interact input
	if Input.is_action_just_pressed("interact"):
		_trigger_transition()


func _on_body_entered(body: Node2D) -> void:
	"""Triggered when a body enters the transition area"""
	# Check if it's the player
	if not body.is_in_group("player"):
		return

	player_in_area = true
	prompt_label.visible = true
	print("RoomTransition: Player entered area, press 'interact' to transition")


func _on_body_exited(body: Node2D) -> void:
	"""Triggered when a body exits the transition area"""
	# Check if it's the player
	if not body.is_in_group("player"):
		return

	player_in_area = false
	prompt_label.visible = false
	print("RoomTransition: Player left area")


func _trigger_transition() -> void:
	"""Start the scene transition"""
	# Check if target scene is set
	if target_scene.is_empty():
		push_warning("RoomTransition: Cannot transition - no target scene set")
		return

	# Disable further transitions temporarily
	can_transition = false
	prompt_label.visible = false

	print("RoomTransition: Triggering transition to '%s'" % target_scene)

	# Start transition
	if SceneTransition:
		SceneTransition.transition_to_scene(target_scene, target_spawn_point)
	else:
		push_error("RoomTransition: SceneTransition singleton not found!")

	# Re-enable after cooldown
	await get_tree().create_timer(transition_cooldown).timeout
	can_transition = true
