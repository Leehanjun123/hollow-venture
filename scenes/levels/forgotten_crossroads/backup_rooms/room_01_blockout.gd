extends Node2D

## Room 01: King's Pass Entry - 블록아웃
## 컨셉: "게임 시작 - 긴 수평 복도"
## 할로우 나이트 스타일: HALLWAY 타입
## 연결: 오른쪽 → Room 02 (Central Hub)

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (할로우 나이트 기준)
const ROOM_WIDTH = 1920   # 30 tiles × 64px (긴 복도)
const ROOM_HEIGHT = 768   # 12 tiles × 64px

func _ready():
	_build_blockout()
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 30×12 타일 (1920×768 픽셀)
	# 할로우 나이트 스타일: 긴 수평 복도 (HALLWAY)
	var width = 30
	var height = 12

	# 바닥 (Y=11, 평평한 복도)
	for x in range(width):
		_set_tile(x, 11, SOLID_SOURCE)

	# 천장 (Y=0)
	for x in range(width):
		_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽 (입구 제외 - 플레이어 시작점)
	for y in range(1, 11):
		if y < 8 or y > 10:  # Y=8~10은 입구 (높이 3타일)
			_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽 (출구 제외 - Room 02로 연결)
	for y in range(1, 11):
		if y < 8 or y > 10:  # Y=8~10은 출구 (높이 3타일)
			_set_tile(29, y, SOLID_SOURCE)

	# 플랫폼들 (탐험 요소)
	# 왼쪽 구역
	_set_tile(5, 8, PLATFORM_SOURCE)
	_set_tile(6, 8, PLATFORM_SOURCE)
	_set_tile(7, 8, PLATFORM_SOURCE)

	# 중앙 왼쪽
	_set_tile(10, 6, PLATFORM_SOURCE)
	_set_tile(11, 6, PLATFORM_SOURCE)
	_set_tile(12, 6, PLATFORM_SOURCE)

	# 중앙 오른쪽
	_set_tile(17, 6, PLATFORM_SOURCE)
	_set_tile(18, 6, PLATFORM_SOURCE)
	_set_tile(19, 6, PLATFORM_SOURCE)

	# 오른쪽 구역 (높음)
	_set_tile(23, 4, PLATFORM_SOURCE)
	_set_tile(24, 4, PLATFORM_SOURCE)
	_set_tile(25, 4, PLATFORM_SOURCE)

	print("✓ Room 01: King's Pass Entry 블록아웃 완료 (30x12)")

func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 01: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 01: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
