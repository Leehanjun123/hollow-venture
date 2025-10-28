extends CanvasLayer
## Hollow Knight style UI system
## Displays health (masks) and soul vessel in top-left corner

# References
@onready var masks_container: HBoxContainer = $MarginContainer/VBoxContainer/MasksContainer
@onready var soul_vessel_outline: Sprite2D = $MarginContainer/VBoxContainer/SoulContainer/SoulVesselOutline
@onready var soul_fill: Sprite2D = $MarginContainer/VBoxContainer/SoulContainer/SoulVesselOutline/SoulFill

# Mask textures
var mask_full_texture: Texture2D = preload("res://assets/ui/mask_full.png")
var mask_empty_texture: Texture2D = preload("res://assets/ui/mask_empty.png")

# Player reference
var player: CharacterBody2D = null

# Current UI state (cached to avoid unnecessary updates)
var cached_current_masks: int = -1
var cached_max_masks: int = -1
var cached_soul_percent: float = -1.0


func _ready() -> void:
	# Find player in scene
	await get_tree().process_frame  # Wait for scene to be fully loaded
	player = get_tree().get_first_node_in_group("player")

	if not player:
		push_warning("UI: Player not found in scene!")
		return

	print("UI: Connected to player")

	# Initialize UI
	_update_masks()
	_update_soul()


func _process(_delta: float) -> void:
	if not player:
		return

	# Update masks if changed
	if player.current_masks != cached_current_masks or player.max_masks != cached_max_masks:
		_update_masks()

	# Update soul if changed
	var current_soul_percent = player.current_soul / player.max_soul
	if abs(current_soul_percent - cached_soul_percent) > 0.01:  # Update if changed by more than 1%
		_update_soul()


func _update_masks() -> void:
	"""Update health mask display"""
	if not player:
		return

	# Clear existing masks
	for child in masks_container.get_children():
		child.queue_free()

	# Create mask sprites
	for i in range(player.max_masks):
		var mask_sprite = Sprite2D.new()
		mask_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

		if i < player.current_masks:
			mask_sprite.texture = mask_full_texture
		else:
			mask_sprite.texture = mask_empty_texture

		masks_container.add_child(mask_sprite)

	# Cache values
	cached_current_masks = player.current_masks
	cached_max_masks = player.max_masks

	print("UI: Updated masks - %d/%d" % [player.current_masks, player.max_masks])


func _update_soul() -> void:
	"""Update soul vessel fill"""
	if not player:
		return

	# Calculate fill percentage (0.0 to 1.0)
	var soul_percent = clamp(player.current_soul / player.max_soul, 0.0, 1.0)

	# Update fill sprite scale (fill from bottom to top)
	soul_fill.scale.y = soul_percent

	# Position fill at bottom of vessel (offset upward as it fills)
	var vessel_height = soul_vessel_outline.texture.get_height()
	soul_fill.position.y = vessel_height * (1.0 - soul_percent) / 2.0

	# Cache value
	cached_soul_percent = soul_percent

	print("UI: Updated soul - %.1f/%.1f (%.0f%%)" % [player.current_soul, player.max_soul, soul_percent * 100])
