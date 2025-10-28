extends Node2D

## Room 03: Crawlid Nest - 블록아웃
## 컨셉: "전투장 - 딱정벌레들의 서식지"

@onready var tilemap: TileMapLayer = $TileMap
@onready var camera: Camera2D = $Camera2D

const SOLID_TILE = Vector2i(0, 0)
const PLATFORM_TILE = Vector2i(0, 0)
const SOLID_SOURCE = 0
const PLATFORM_SOURCE = 1

# Room dimensions (in pixels)
const ROOM_WIDTH = 1152  # 18 tiles × 64px
const ROOM_HEIGHT = 768  # 12 tiles × 64px

func _ready():
	# _build_blockout()  # TileMap 에디터로 직접 그리기로 변경
	_setup_camera()
	_spawn_player()

func _build_blockout():
	# Room 크기: 18×12 타일
	var width = 18
	var height = 12

	# 바닥 (메인 Y=10, 웅덩이 Y=11)
	for x in range(width):
		# 웅덩이 1 (X=4-6)
		if x >= 4 and x <= 6:
			_set_tile(x, 11, SOLID_SOURCE)
		# 웅덩이 2 (X=11-13)
		elif x >= 11 and x <= 13:
			_set_tile(x, 11, SOLID_SOURCE)
		# 일반 바닥
		else:
			_set_tile(x, 10, SOLID_SOURCE)

	# 천장 (Y=0, 낮은 부분 Y=2)
	for x in range(width):
		# 낮은 천장 (압박감)
		if x >= 7 and x <= 10:
			_set_tile(x, 2, SOLID_SOURCE)
		else:
			_set_tile(x, 0, SOLID_SOURCE)

	# 왼쪽 벽
	for y in range(0, 11):
		_set_tile(0, y, SOLID_SOURCE)

	# 오른쪽 벽
	for y in range(0, 11):
		_set_tile(17, y, SOLID_SOURCE)

	# 플랫폼 3층
	# 1층 (Y=8)
	_set_tile(3, 8, PLATFORM_SOURCE)
	_set_tile(4, 8, PLATFORM_SOURCE)
	_set_tile(13, 8, PLATFORM_SOURCE)
	_set_tile(14, 8, PLATFORM_SOURCE)

	# 2층 (Y=6)
	_set_tile(7, 6, PLATFORM_SOURCE)
	_set_tile(8, 6, PLATFORM_SOURCE)
	_set_tile(9, 6, PLATFORM_SOURCE)

	# 3층 (Y=4)
	_set_tile(2, 4, PLATFORM_SOURCE)
	_set_tile(15, 4, PLATFORM_SOURCE)

	# 중앙 돌출 벽 (전술 요소)
	_set_tile(9, 9, SOLID_SOURCE)
	_set_tile(9, 8, SOLID_SOURCE)
	_set_tile(9, 7, SOLID_SOURCE)

	print("✓ Room 03: Crawlid Nest 블록아웃 완료")

func _setup_camera():
	"""Setup camera bounds for this room"""
	if camera and camera.has_method("set_room_bounds"):
		var room_rect = Rect2(0, 0, ROOM_WIDTH, ROOM_HEIGHT)
		camera.set_room_bounds(room_rect)
		print("✓ Room 03: Camera bounds set to %s" % room_rect)

func _spawn_player():
	"""Spawn player at the designated spawn point"""
	# Use PlayerSpawner singleton to spawn player
	if PlayerSpawner:
		var spawn_point = PlayerSpawner.current_spawn_point
		PlayerSpawner.spawn_player_at_marker(spawn_point, self)
		print("✓ Room 03: Player spawned at '%s'" % spawn_point)

func _set_tile(x: int, y: int, source_id: int):
	tilemap.set_cell(Vector2i(x, y), source_id, SOLID_TILE if source_id == SOLID_SOURCE else PLATFORM_TILE)
