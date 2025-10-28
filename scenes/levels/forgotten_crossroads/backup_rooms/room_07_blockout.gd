extends Node2D

## Room 07: Mothwing Shrine - 블록아웃
## 컨셉: "보물방 - 대시 능력 획득"

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (in pixels)
const ROOM_WIDTH = 1024   # 16 tiles × 64px
const ROOM_HEIGHT = 640   # 10 tiles × 64px

func _ready():
	_build_blockout()
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 16×10 타일 (작고 신성한 공간)
	var width = 16
	var height = 10

	# 바닥 (Y=9, 평평)
	for x in range(width):
		_set_tile(x, 9, SOLID_SOURCE)

	# 천장 (Y=0)
	for x in range(width):
		_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽 (입구 제외)
	for y in range(1, 9):
		if y < 7 or y > 8:
			_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽 (출구 제외)
	for y in range(1, 9):
		if y < 7 or y > 8:
			_set_tile(15, y, SOLID_SOURCE)

	# 중앙 높은 플랫폼 (능력 위치)
	# 대칭 구조 - 중앙에 배치 (X=7-8, 중심은 8타일)
	_set_tile(7, 4, PLATFORM_SOURCE)
	_set_tile(8, 4, PLATFORM_SOURCE)

	# 계단식 플랫폼 (왼쪽)
	_set_tile(4, 7, PLATFORM_SOURCE)
	_set_tile(5, 6, PLATFORM_SOURCE)
	_set_tile(6, 5, PLATFORM_SOURCE)

	# 계단식 플랫폼 (오른쪽 - 대칭)
	_set_tile(11, 7, PLATFORM_SOURCE)
	_set_tile(10, 6, PLATFORM_SOURCE)
	_set_tile(9, 5, PLATFORM_SOURCE)

	# 장식 기둥 (대칭)
	_set_tile(4, 8, SOLID_SOURCE)
	_set_tile(11, 8, SOLID_SOURCE)

	print("✓ Room 07: Mothwing Shrine 블록아웃 완료")


func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 07: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 07: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
