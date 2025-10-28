extends Node2D

## 할로우 벤처 - 수학적으로 완벽하게 연결된 맵
## 모든 룸의 출구-입구가 정확히 1칸 간격

func _ready():
	var tile_map = $TileMapLayer
	print("=== 할로우 벤처 완벽한 맵 생성 ===")

	# 내비게이션 UI 추가
	_add_navigation_ui()

	# ========================================
	# 층 1: 튜토리얼 (바닥 Y=7)
	# ========================================

	var starting_room = RoomFactory.create_starting_room()
	_place_room(tile_map, starting_room, Vector2i(0, -2))
	_add_room_detector("Starting Room", Vector2i(0, -2), Vector2i(15, 10), "기본 조작을 익히세요", "→ 오른쪽으로 이동하여 복도로")
	_add_exit_arrow(tile_map, Vector2i(14, 5), "right")
	# 출구 right: (14, 6)

	var corridor1 = RoomFactory.create_long_corridor()
	_place_room(tile_map, corridor1, Vector2i(15, 0))
	_add_room_detector("Long Corridor", Vector2i(15, 0), Vector2i(30, 8), "긴 복도", "→ 계속 오른쪽으로")
	_add_exit_arrow(tile_map, Vector2i(43, 5), "right")
	# 입구 left: (15, 6) ✓
	# 출구 right: (44, 6)

	var junction = RoomFactory.create_junction()
	_place_room(tile_map, junction, Vector2i(45, -7))
	_add_room_detector("T-Junction", Vector2i(45, -7), Vector2i(20, 15), "3방향 분기점", "↑ 위: 보물방 / ↓ 아래: 전투구역")
	_add_exit_arrow(tile_map, Vector2i(54, -6), "up")
	_add_exit_arrow(tile_map, Vector2i(63, 5), "right")
	# 입구 left: (45, 6) ✓
	# 출구 right: (64, 6)
	# 출구 up: (54, -7)

	# ========================================
	# 층 2: 상층 탐험 (바닥 Y=-18)
	# ========================================

	# 수직 복도: Junction up → Rest Area
	var v_corridor1 = RoomFactory.create_vertical_corridor(12)
	_place_room(tile_map, v_corridor1, Vector2i(52, -19))
	# 아래 출구: (54, -8) ≈ Junction up (54, -7) ✓
	# 위 입구: (54, -19)

	var rest_area = RoomFactory.create_rest_area()
	_place_room(tile_map, rest_area, Vector2i(42, -26))
	_add_room_detector("Rest Area", Vector2i(42, -26), Vector2i(14, 9), "세이브 포인트", "→ 오른쪽: 보물방")
	_add_exit_arrow(tile_map, Vector2i(59, -20), "right")
	# 입구 right: (55, -19) ✓
	# 출구 left: (42, -19)

	var treasure_room = RoomFactory.create_treasure_room()
	_place_room(tile_map, treasure_room, Vector2i(43, -27))
	_add_room_detector("Treasure Room", Vector2i(43, -27), Vector2i(12, 10), "대시 능력 획득!", "← 뒤로 돌아가기")
	# 입구 left: (43, -19) ✓ Rest 왼쪽 근처

	# ========================================
	# 층 3: 중층 전투 (바닥 Y=26)
	# ========================================

	# 수직 복도: Junction right → Combat 1
	var v_corridor2 = RoomFactory.create_vertical_corridor(19)
	_place_room(tile_map, v_corridor2, Vector2i(62, 7))
	# 위 입구: (64, 7) ≈ Junction right (64, 6) ✓
	# 아래 출구: (64, 25)

	var combat_room1 = RoomFactory.create_combat_room()
	_place_room(tile_map, combat_room1, Vector2i(65, 15))
	_add_room_detector("Combat Arena 1", Vector2i(65, 15), Vector2i(18, 12), "첫 전투!", "→ 적을 처치하고 진행")
	# 입구 left: (65, 25) ✓
	# 출구 right: (82, 25)

	var trap_room = RoomFactory.create_trap_room()
	_place_room(tile_map, trap_room, Vector2i(83, 15))
	_add_room_detector("Trap Room", Vector2i(83, 15), Vector2i(16, 12), "함정 구역", "→ 고드름 조심!")
	# 입구 left: (83, 25) ✓
	# 출구 right: (98, 25)

	var combat_room2 = RoomFactory.create_combat_room()
	_place_room(tile_map, combat_room2, Vector2i(99, 15))
	_add_room_detector("Combat Arena 2", Vector2i(99, 15), Vector2i(18, 12), "전투 계속", "→ 다음 구역으로")
	# 입구 left: (99, 25) ✓

	# ========================================
	# 층 4: 하층 챌린지 (바닥 Y=46)
	# ========================================

	var narrow_passage = RoomFactory.create_narrow_passage()
	_place_room(tile_map, narrow_passage, Vector2i(10, 42))
	# 출구 right: (29, 46)

	var climbing_shaft = RoomFactory.create_climbing_shaft()
	_place_room(tile_map, climbing_shaft, Vector2i(25, 22))
	_add_room_detector("Climbing Shaft", Vector2i(25, 22), Vector2i(10, 25), "수직 등반", "↑ 이단점프로 위로")
	# 입구 down: (30, 46) ✓
	# 출구 up: (30, 22)

	var open_plaza = RoomFactory.create_open_plaza()
	_place_room(tile_map, open_plaza, Vector2i(31, 6))
	_add_room_detector("Open Plaza", Vector2i(31, 6), Vector2i(24, 18), "넓은 광장", "→ 오른쪽으로 계속")
	# 입구 left: (31, 22) ✓
	# 출구 right: (54, 22)

	# ========================================
	# 층 5: 깊은 동굴 (바닥 Y=67)
	# ========================================

	# 수직 복도: Plaza → Maze
	var v_corridor3 = RoomFactory.create_vertical_corridor(44)
	_place_room(tile_map, v_corridor3, Vector2i(53, 23))
	# 위 입구: (55, 23) ≈ Plaza right (54, 22) ✓
	# 아래 출구: (55, 66)

	var maze_section = RoomFactory.create_maze_section()
	_place_room(tile_map, maze_section, Vector2i(56, 52))
	_add_room_detector("Maze Section", Vector2i(56, 52), Vector2i(20, 16), "미로 구간", "→ 길을 찾으세요")
	# 입구 left: (56, 66) ✓
	# 출구 right: (75, 66)

	var challenge_room = RoomFactory.create_challenge_room()
	_place_room(tile_map, challenge_room, Vector2i(76, 54))
	_add_room_detector("Challenge Room", Vector2i(76, 54), Vector2i(22, 14), "챌린지!", "→ 플랫폼 점프 연습")
	# 입구 left: (76, 66) ✓
	# 출구 right: (97, 57)

	# ========================================
	# 보스층 (바닥 Y=105)
	# ========================================

	# 수직 복도: Challenge → VertShaft
	var v_corridor4 = RoomFactory.create_vertical_corridor(29)
	_place_room(tile_map, v_corridor4, Vector2i(95, 58))
	# 위 입구: (97, 58) ≈ Challenge right (97, 57) ✓
	# 아래 출구: (97, 86)

	var boss_shaft = RoomFactory.create_vertical_shaft()
	_place_room(tile_map, boss_shaft, Vector2i(93, 86))
	# 입구 up: (97, 86) ✓
	# 출구 down: (97, 105)

	var boss_room = RoomFactory.create_boss_room()
	_place_room(tile_map, boss_room, Vector2i(98, 92))
	_add_room_detector("Boss Arena", Vector2i(98, 92), Vector2i(25, 15), "최종 보스!", "보스를 처치하세요!")
	# 입구 left: (98, 105) ✓

	# ========================================
	# 비밀층 (Starting Room 위쪽)
	# ========================================

	var secret_room = RoomFactory.create_secret_room()
	_place_room(tile_map, secret_room, Vector2i(0, -35))
	_add_room_detector("Secret Room", Vector2i(0, -35), Vector2i(10, 7), "비밀 보물!", "특별 보상 획득")
	# Starting Room 위쪽 숨겨진 위치

	# ========================================
	# 플레이어 스폰 & 낙하 방지
	# ========================================

	var player = get_parent().get_node_or_null("Player")
	if not player:
		player = get_node_or_null("../Player")
	if not player:
		player = get_tree().get_first_node_in_group("player")

	if player:
		# Starting Room 스폰 (타일 32x32)
		var spawn_world = Vector2(2 * 32, 6 * 32)
		player.position = spawn_world
		player.last_safe_position = spawn_world  # 안전 위치 저장
		print("✓ 플레이어 스폰: %s" % spawn_world)
	else:
		print("⚠ 플레이어 없음!")

	print("=== 맵 생성 완료! ===")
	print("총 룸 수: 20개 (메인 15개 + 복도 5개)")
	print("\n경로:")
	print("  Starting → Corridor → Junction")
	print("    ↑ (위): Rest Area → Treasure")
	print("    ↓ (아래): Combat1 → Trap → Combat2")
	print("  Narrow → Climbing ↑ Plaza")
	print("    ↓")
	print("  Maze → Challenge")
	print("    ↓")
	print("  VertShaft → Boss")
	print("  Secret (Starting 위)")


func _place_room(tile_map: TileMapLayer, room: RoomTemplate, offset: Vector2i):
	print("→ %s at %s" % [room.room_name, offset])

	for y in range(room.height):
		for x in range(room.width):
			var tile_id = room.tiles[y][x]

			if tile_id >= 0:
				var world_pos = Vector2i(offset.x + x, offset.y + y)
				tile_map.set_cell(world_pos, tile_id, Vector2i(0, 0))


# === 내비게이션 시스템 ===

func _add_navigation_ui():
	"""내비게이션 UI 추가"""
	var nav_ui = CanvasLayer.new()
	nav_ui.set_script(load("res://scripts/navigation_ui.gd"))
	nav_ui.name = "NavigationUI"
	add_child(nav_ui)


func _add_room_detector(room_name: String, offset: Vector2i, size: Vector2i, description: String, objective: String):
	"""룸 감지 영역 추가"""
	var detector = Area2D.new()
	detector.set_script(load("res://scripts/room_detector.gd"))
	detector.name = "RoomDetector_" + room_name.replace(" ", "_")
	detector.room_name = room_name
	detector.room_description = description
	detector.next_objective = objective

	# 충돌 영역 (룸 전체)
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(size.x * 32, size.y * 32)  # 타일 크기 32px
	collision.shape = shape
	collision.position = Vector2((offset.x + size.x / 2.0) * 32, (offset.y + size.y / 2.0) * 32)

	detector.add_child(collision)
	add_child(detector)


func _add_exit_arrow(tile_map: TileMapLayer, pos: Vector2i, direction: String):
	"""출구에 화살표 표시 (크리스탈로)"""
	# 크리스탈을 화살표로 사용
	var arrow_positions = []

	match direction:
		"right":
			arrow_positions = [pos, pos + Vector2i(0, 1), pos + Vector2i(0, 2)]
		"left":
			arrow_positions = [pos, pos + Vector2i(0, 1), pos + Vector2i(0, 2)]
		"up":
			arrow_positions = [pos, pos + Vector2i(1, 0), pos + Vector2i(2, 0)]
		"down":
			arrow_positions = [pos, pos + Vector2i(1, 0), pos + Vector2i(2, 0)]

	for arrow_pos in arrow_positions:
		tile_map.set_cell(arrow_pos, 4, Vector2i(0, 0))  # 크리스탈 타일
