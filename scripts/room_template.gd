extends Resource
class_name RoomTemplate

## 할로우 나이트 스타일 룸 템플릿
## 각 방의 레이아웃을 정의

# 룸 기본 정보
var room_name: String = ""
var width: int = 0  # 타일 단위
var height: int = 0

# 타일 데이터 (2D 배열)
# -1 = 빈 공간, 0 = ground, 1 = wall, 2 = platform, 3 = stalactite, 4 = crystal
var tiles: Array = []

# 플레이어 스폰 위치 (타일 좌표)
var spawn_point: Vector2i = Vector2i(0, 0)

# 출구/입구 정보
# [{direction: "left/right/up/down", tile_pos: Vector2i}, ...]
var exits: Array[Dictionary] = []

# 적 스폰 위치들
var enemy_spawns: Array[Vector2i] = []

# 수집 아이템 위치들
var item_spawns: Array[Vector2i] = []


func _init(name: String, w: int, h: int):
	room_name = name
	width = w
	height = h

	# 2D 배열 초기화 (빈 공간으로)
	tiles = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(-1)  # 빈 공간
		tiles.append(row)


# 타일 설정
func set_tile(x: int, y: int, tile_id: int):
	if x >= 0 and x < width and y >= 0 and y < height:
		tiles[y][x] = tile_id


# 사각형 영역 채우기
func fill_rect(x: int, y: int, w: int, h: int, tile_id: int):
	for dy in range(h):
		for dx in range(w):
			set_tile(x + dx, y + dy, tile_id)


# 가로선 그리기
func draw_horizontal_line(x: int, y: int, length: int, tile_id: int):
	for i in range(length):
		set_tile(x + i, y, tile_id)


# 세로선 그리기
func draw_vertical_line(x: int, y: int, length: int, tile_id: int):
	for i in range(length):
		set_tile(x, y + i, tile_id)


# 출구 추가
func add_exit(direction: String, tile_pos: Vector2i):
	exits.append({
		"direction": direction,
		"tile_pos": tile_pos
	})


# 적 스폰 추가
func add_enemy_spawn(tile_pos: Vector2i):
	enemy_spawns.append(tile_pos)


# 아이템 스폰 추가
func add_item_spawn(tile_pos: Vector2i):
	item_spawns.append(tile_pos)


# 디버그 출력
func print_layout():
	print("=== Room: %s (%dx%d) ===" % [room_name, width, height])
	for y in range(height):
		var line = ""
		for x in range(width):
			var tile = tiles[y][x]
			match tile:
				-1: line += "  "  # 빈 공간
				0: line += "##"   # ground
				1: line += "[]"   # wall
				2: line += "=="   # platform
				3: line += "vv"   # stalactite
				4: line += "<>"   # crystal
				_: line += "??"
		print(line)
	print("Spawn: %s" % spawn_point)
	print("Exits: %s" % exits)
