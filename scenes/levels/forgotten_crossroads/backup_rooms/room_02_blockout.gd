extends Node2D

## Room 02: Central Hub - 블록아웃
## 컨셉: "탐험의 중심 - 4방향 연결 허브"
## 할로우 나이트 스타일: HUB 타입
## 연결: 왼쪽 ← Room 01, 오른쪽 → Room 03, 아래 ↓ Room 04, 위 ↑ (나중에)

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (할로우 나이트 기준 - 4방향 허브)
const ROOM_WIDTH = 1408   # 22 tiles × 64px
const ROOM_HEIGHT = 1024  # 16 tiles × 64px (높이 증가)

func _ready():
	_build_blockout()
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 22×16 타일 (1408×1024 픽셀)
	# 할로우 나이트 스타일: 4방향 연결 HUB
	var width = 22
	var height = 16

	# 바닥 (Y=15, 중앙에 구멍 - 아래로 Room 04 연결)
	for x in range(width):
		if x < 9 or x > 12:  # 중앙 X=9~12는 구멍 (Room 04로 떨어짐)
			_set_tile(x, 15, SOLID_SOURCE)

	# 천장 (Y=0, 나중에 위쪽 연결 추가 가능)
	for x in range(width):
		_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽 (입구 - Room 01 연결)
	for y in range(1, 15):
		if y < 8 or y > 10:  # Y=8~10은 입구 (높이 3타일)
			_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽 (출구 - Room 03 연결)
	for y in range(1, 15):
		if y < 8 or y > 10:  # Y=8~10은 출구 (높이 3타일)
			_set_tile(21, y, SOLID_SOURCE)

	# 다층 플랫폼 구조 (복잡한 수직 탐험)

	# 1층 (바닥 근처)
	_set_tile(3, 13, PLATFORM_SOURCE)
	_set_tile(4, 13, PLATFORM_SOURCE)
	_set_tile(17, 13, PLATFORM_SOURCE)
	_set_tile(18, 13, PLATFORM_SOURCE)

	# 2층
	_set_tile(5, 11, PLATFORM_SOURCE)
	_set_tile(6, 11, PLATFORM_SOURCE)
	_set_tile(7, 11, PLATFORM_SOURCE)

	_set_tile(14, 11, PLATFORM_SOURCE)
	_set_tile(15, 11, PLATFORM_SOURCE)
	_set_tile(16, 11, PLATFORM_SOURCE)

	# 3층 (중앙 허브 - 주요 통로)
	_set_tile(8, 9, PLATFORM_SOURCE)
	_set_tile(9, 9, PLATFORM_SOURCE)
	_set_tile(12, 9, PLATFORM_SOURCE)
	_set_tile(13, 9, PLATFORM_SOURCE)

	# 4층 (높은 곳)
	_set_tile(10, 6, PLATFORM_SOURCE)
	_set_tile(11, 6, PLATFORM_SOURCE)

	# 5층 (최상층)
	_set_tile(5, 3, PLATFORM_SOURCE)
	_set_tile(6, 3, PLATFORM_SOURCE)
	_set_tile(15, 3, PLATFORM_SOURCE)
	_set_tile(16, 3, PLATFORM_SOURCE)

	print("✓ Room 02: Central Hub 블록아웃 완료 (22x16, 4방향)")

func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 02: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 02: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
