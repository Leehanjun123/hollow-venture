extends Node2D

## 방 2개 연결 테스트 - RoomFactory 사용
## 이게 작동하면 확장 가능

const TILE_SIZE = 32

func _ready():
	var tile_map = $TileMapLayer
	print("=== 방 2개 연결 테스트 ===\n")

	# ═══════════════════════════════════════
	#  방 1: 시작방 (Starting Room)
	# ═══════════════════════════════════════

	var room1 = RoomFactory.create_starting_room()
	var room1_offset = Vector2i(0, 0)

	print("방 1 (Starting Room):")
	print("  - 크기: %dx%d" % [room1.width, room1.height])
	print("  - 오프셋: %s" % room1_offset)
	print("  - 출구: %s" % room1.exits)

	_place_room(tile_map, room1, room1_offset)

	# 출구 위치 계산 (right 출구)
	var exit_right = null
	for exit in room1.exits:
		if exit.direction == "right":
			exit_right = exit.tile_pos
			break

	if exit_right:
		var exit_world = room1_offset + exit_right
		print("  - 오른쪽 출구 월드 좌표: %s (Y=%d)" % [exit_world, exit_world.y])

	# ═══════════════════════════════════════
	#  방 2: 전투방 (Combat Room)
	# ═══════════════════════════════════════

	# 방 1의 오른쪽 출구와 방 2의 왼쪽 입구가 연결되도록 계산
	var room2 = RoomFactory.create_combat_room()

	# room1의 오른쪽 끝 X 좌표 + 1
	var room1_right_x = room1_offset.x + room1.width

	# room2의 왼쪽 입구 Y 좌표 찾기
	var entrance_left = null
	for exit in room2.exits:
		if exit.direction == "left":
			entrance_left = exit.tile_pos
			break

	# 방 2 오프셋 계산
	# X: 방 1 끝 바로 다음
	# Y: 방 1 출구 Y - 방 2 입구 Y (높이 맞추기)
	var room2_offset = Vector2i(
		room1_right_x,
		room1_offset.y + (exit_right.y if exit_right else room1.height - 2) - (entrance_left.y if entrance_left else room2.height - 2)
	)

	print("\n방 2 (Combat Room):")
	print("  - 크기: %dx%d" % [room2.width, room2.height])
	print("  - 오프셋: %s" % room2_offset)
	print("  - 입구: %s" % room2.exits)

	_place_room(tile_map, room2, room2_offset)

	# 입구 위치 확인
	if entrance_left:
		var entrance_world = room2_offset + entrance_left
		print("  - 왼쪽 입구 월드 좌표: %s (Y=%d)" % [entrance_world, entrance_world.y])

	# ═══════════════════════════════════════
	#  연결 검증
	# ═══════════════════════════════════════

	print("\n연결 검증:")
	if exit_right and entrance_left:
		var exit_world_y = (room1_offset + exit_right).y
		var entrance_world_y = (room2_offset + entrance_left).y

		if exit_world_y == entrance_world_y:
			print("  ✅ 출구-입구 높이 일치! (Y=%d)" % exit_world_y)
		else:
			print("  ❌ 높이 불일치! 출구 Y=%d, 입구 Y=%d" % [exit_world_y, entrance_world_y])

	var distance = room2_offset.x - (room1_offset.x + room1.width)
	if distance == 0:
		print("  ✅ 방들이 붙어있음 (간격=0)")
	else:
		print("  ⚠ 방 사이 간격: %d타일" % distance)

	# ═══════════════════════════════════════
	#  플레이어 스폰
	# ═══════════════════════════════════════

	var player = get_tree().get_first_node_in_group("player")
	if player:
		# 방 1의 스폰 포인트 사용
		var spawn_tile = room1_offset + room1.spawn_point
		player.position = Vector2(spawn_tile.x * TILE_SIZE, spawn_tile.y * TILE_SIZE)

		if player.has_method("set_last_safe_position"):
			player.last_safe_position = player.position

		print("\n✓ 플레이어 스폰: 타일=%s, 월드=%s" % [spawn_tile, player.position])
	else:
		print("\n⚠ 플레이어 없음!")

	print("\n=== 테스트 완료 ===")
	print("→ 오른쪽으로 걸어서 방 2까지 가보세요")


func _place_room(tile_map: TileMapLayer, room: RoomTemplate, offset: Vector2i):
	"""방을 타일맵에 배치"""
	for y in range(room.height):
		for x in range(room.width):
			var tile_id = room.tiles[y][x]
			if tile_id >= 0:
				var world_pos = Vector2i(offset.x + x, offset.y + y)
				tile_map.set_cell(world_pos, tile_id, Vector2i(0, 0))
