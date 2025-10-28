extends Node2D

## Room 06: Millipede Lair - 블록아웃
## 컨셉: "보스방 - 거대한 공간, 천족 지네"

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (in pixels)
const ROOM_WIDTH = 768   # 12 tiles × 64px
const ROOM_HEIGHT = 960   # 15 tiles × 64px

func _ready():
	_build_blockout()
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 12×15 타일 (보스방 - 넓고 높음)
	var width = 12
	var height = 15

	# 바닥 (Y=14, 중앙 약간 낮음 - 아레나 느낌)
	for x in range(width):
		if x >= 4 and x <= 7:
			_set_tile(x, 14, SOLID_SOURCE)
		else:
			_set_tile(x, 13, SOLID_SOURCE)

	# 천장 (Y=0, 매우 높음)
	for x in range(width):
		_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽 (입구 제외)
	for y in range(1, 14):
		if y < 12 or y > 13:  # Y=12-13는 입구
			_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽 (출구 제외)
	for y in range(1, 14):
		if y < 12 or y > 13:  # Y=12-13는 출구 (보스 처치 후)
			_set_tile(11, y, SOLID_SOURCE)

	# 플랫폼 최소 (보스전 집중)
	# 양쪽 작은 플랫폼만
	_set_tile(2, 11, PLATFORM_SOURCE)
	_set_tile(3, 11, PLATFORM_SOURCE)

	_set_tile(8, 11, PLATFORM_SOURCE)
	_set_tile(9, 11, PLATFORM_SOURCE)

	# 중앙 플랫폼
	_set_tile(5, 9, PLATFORM_SOURCE)
	_set_tile(6, 9, PLATFORM_SOURCE)

	# 벽에 등반 가능한 표면 (장식)
	# 왼쪽
	for y in range(5, 13):
		_set_tile(2, y, SOLID_SOURCE)

	# 오른쪽
	for y in range(5, 13):
		_set_tile(9, y, SOLID_SOURCE)

	# 바닥에 뼈 잔해 (장식용 솔리드)
	_set_tile(3, 13, SOLID_SOURCE)
	_set_tile(4, 13, SOLID_SOURCE)
	_set_tile(7, 13, SOLID_SOURCE)
	_set_tile(8, 13, SOLID_SOURCE)

	print("✓ Room 06: Millipede Lair 블록아웃 완료")


func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 06: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 06: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
