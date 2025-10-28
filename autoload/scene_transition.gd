extends CanvasLayer
## Scene Transition Manager - Hollow Knight style
## Handles fade in/out effects and scene transitions

# Transition settings
const FADE_DURATION: float = 0.5  # Hollow Knight uses quick fades
const FADE_COLOR: Color = Color.BLACK

# Nodes
var color_rect: ColorRect

# State
var is_transitioning: bool = false


func _ready() -> void:
	# Set layer to be on top of everything
	layer = 1000

	# Create ColorRect for fade effect
	color_rect = ColorRect.new()
	color_rect.color = FADE_COLOR
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_rect)

	# Make it cover the entire screen
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)

	# Start transparent (no fade)
	color_rect.color.a = 0.0

	print("SceneTransition: Initialized")


func transition_to_scene(scene_path: String, spawn_point: String = "DefaultSpawn") -> void:
	"""Transition to a new scene with fade effect"""

	if is_transitioning:
		push_warning("SceneTransition: Already transitioning, ignoring request")
		return

	is_transitioning = true
	print("SceneTransition: Transitioning to '%s' (spawn: %s)" % [scene_path, spawn_point])

	# Set the spawn point for next scene
	if PlayerSpawner:
		PlayerSpawner.set_next_spawn_point(spawn_point)

	# Fade out, change scene, fade in
	await fade_out()
	_change_scene(scene_path)
	await fade_in()

	is_transitioning = false
	print("SceneTransition: Transition complete")


func fade_out() -> void:
	"""Fade to black"""
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(color_rect, "color:a", 1.0, FADE_DURATION).from(0.0)

	await tween.finished
	print("SceneTransition: Fade out complete")


func fade_in() -> void:
	"""Fade from black to transparent"""
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)

	tween.tween_property(color_rect, "color:a", 0.0, FADE_DURATION).from(1.0)

	await tween.finished
	print("SceneTransition: Fade in complete")


func _change_scene(scene_path: String) -> void:
	"""Change the current scene"""
	var result = get_tree().change_scene_to_file(scene_path)

	if result != OK:
		push_error("SceneTransition: Failed to load scene '%s'" % scene_path)
		is_transitioning = false
		return

	# Wait for new scene to be ready
	await get_tree().process_frame
	print("SceneTransition: Scene changed to '%s'" % scene_path)
