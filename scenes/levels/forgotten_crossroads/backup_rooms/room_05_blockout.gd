extends Node2D

## Room 05: Tiktik Den - 블록아웃
## 컨셉: "전투장 2 - 벽을 기어다니는 틱틱"

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (in pixels)
const ROOM_WIDTH = 1024   # 16 tiles × 64px
const ROOM_HEIGHT = 768   # 12 tiles × 64px

func _ready():
	_build_blockout()
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 16×14 타일 (복잡한 수직 구조)
	var width = 16
	var height = 14

	# 바닥 (불규칙)
	for x in range(width):
		if x < 4:
			_set_tile(x, 9, SOLID_SOURCE)
		elif x < 8:
			_set_tile(x, 11, SOLID_SOURCE)
		elif x < 12:
			_set_tile(x, 10, SOLID_SOURCE)
		else:
			_set_tile(x, 12, SOLID_SOURCE)

	# 천장 (낮고 높음 반복 - 역동적)
	for x in range(width):
		if x < 5:
			_set_tile(x, 1, SOLID_SOURCE)
		elif x < 10:
			_set_tile(x, 3, SOLID_SOURCE)
		else:
			_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽 (입구 제외)
	for y in range(1, 10):
		if y < 7 or y > 8:
			_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽 (출구 제외)
	for y in range(0, 13):
		if y < 10 or y > 11:
			_set_tile(15, y, SOLID_SOURCE)

	# 복잡한 플랫폼 배치 (수직 이동)
	# 왼쪽 계단식
	_set_tile(2, 8, PLATFORM_SOURCE)
	_set_tile(3, 8, PLATFORM_SOURCE)
	_set_tile(3, 6, PLATFORM_SOURCE)
	_set_tile(4, 6, PLATFORM_SOURCE)
	_set_tile(4, 4, PLATFORM_SOURCE)
	_set_tile(5, 4, PLATFORM_SOURCE)

	# 중앙 플랫폼
	_set_tile(7, 7, PLATFORM_SOURCE)
	_set_tile(8, 7, PLATFORM_SOURCE)
	_set_tile(9, 7, PLATFORM_SOURCE)

	_set_tile(8, 5, PLATFORM_SOURCE)
	_set_tile(9, 5, PLATFORM_SOURCE)

	# 오른쪽 플랫폼
	_set_tile(12, 9, PLATFORM_SOURCE)
	_set_tile(13, 9, PLATFORM_SOURCE)
	_set_tile(12, 7, PLATFORM_SOURCE)
	_set_tile(13, 7, PLATFORM_SOURCE)

	# 벽 장애물 (Tiktik이 기어다닐 표면)
	for y in range(4, 9):
		_set_tile(6, y, SOLID_SOURCE)

	for y in range(5, 11):
		_set_tile(11, y, SOLID_SOURCE)

	print("✓ Room 05: Tiktik Den 블록아웃 완료")


func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 05: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 05: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
