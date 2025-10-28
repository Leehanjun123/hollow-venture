extends Node2D

## Room 04: Ancient Bench - 블록아웃
## 컨셉: "쉼터 - 벤치가 있는 조용한 공간"

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (in pixels)
const ROOM_WIDTH = 896   # 14 tiles × 64px
const ROOM_HEIGHT = 640  # 10 tiles × 64px

func _ready():
	_build_blockout()
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 14×10 타일 (작은 방)
	var width = 14
	var height = 10

	# 바닥 (Y=9, 평평)
	for x in range(width):
		_set_tile(x, 9, SOLID_SOURCE)

	# 천장 (Y=0)
	for x in range(width):
		_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽 (입구 제외)
	for y in range(1, 9):
		if y < 7 or y > 8:  # Y=7-8는 입구
			_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽
	for y in range(1, 9):
		_set_tile(13, y, SOLID_SOURCE)

	# 작은 플랫폼 (장식)
	_set_tile(3, 7, PLATFORM_SOURCE)
	_set_tile(4, 7, PLATFORM_SOURCE)

	_set_tile(9, 7, PLATFORM_SOURCE)
	_set_tile(10, 7, PLATFORM_SOURCE)

	# 벤치는 별도 오브젝트로 추가 (나중에)

	print("✓ Room 04: Ancient Bench 블록아웃 완료")

func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 04: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 04: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
