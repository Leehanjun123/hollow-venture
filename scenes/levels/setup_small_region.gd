extends Node2D

## ═══════════════════════════════════════════════════════════════════
## 작은 지역 (평원 프로토타입) - 7개 방
## ═══════════════════════════════════════════════════════════════════
##
## 구조: 시작방 → 광장 → 전투1 → 세이브 → 전투2 → 보스 → 능력
##
## 목표: 완결된 게임 루프 체험
##   - 탐험
##   - 전투
##   - 세이브
##   - 보스 전투
##   - 보상 (능력 획득)
##
## ═══════════════════════════════════════════════════════════════════

const TILE_SIZE = 32
const FLOOR_Y = 10  # 모든 방의 바닥을 Y=10에 맞춤

# 적 스폰 위치 저장
var enemy_spawn_positions: Array[Vector2] = []

func _ready():
	var tile_map = $TileMapLayer
	var bg_layer = $BackgroundLayer

	print("═══════════════════════════════════════")
	print("  작은 지역 (평원 프로토타입) 생성")
	print("═══════════════════════════════════════\n")

	var current_x = 0  # 현재 X 좌표 (자동 계산)

	# ═══════════════════════════════════════
	#  배경 레이어 채우기 (먼 동굴 벽)
	# ═══════════════════════════════════════
	_setup_background(bg_layer)

	# ═══════════════════════════════════════
	#  중간 레이어 (구조물 실루엣)
	# ═══════════════════════════════════════
	_setup_midground($MidgroundLayer)

	# ═══════════════════════════════════════
	#  방 1: 시작방 (Starting Room)
	# ═══════════════════════════════════════

	print("1. 시작방 생성...")
	var room1 = RoomFactory.create_starting_room()
	# 시작방은 특별: 오른쪽 평지(로컬 Y=10)를 월드 FLOOR_Y=10에 맞춤
	var room1_offset = Vector2i(current_x, 0)
	_place_room(tile_map, room1, room1_offset)
	_add_room_label(room1_offset, "동굴 입구")
	current_x += room1.width
	print("   크기: %dx%d, 출구 Y=%d, 다음 X: %d\n" % [room1.width, room1.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  방 2: 평원 광장 (Open Plaza)
	# ═══════════════════════════════════════

	print("2. 평원 광장 생성...")
	var room2 = RoomFactory.create_open_plaza()
	var room2_offset = Vector2i(current_x, FLOOR_Y - (room2.height - 1))
	_place_room(tile_map, room2, room2_offset)
	_add_room_label(room2_offset, "평원 광장")
	_connect_rooms(tile_map, room1_offset, room1.width, room2_offset)  # 방 1-2 연결
	current_x += room2.width
	print("   크기: %dx%d, 바닥 Y=%d, 다음 X: %d\n" % [room2.width, room2.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  방 3: 전투방 1 (Combat Arena)
	# ═══════════════════════════════════════

	print("3. 전투방 1 생성...")
	var room3 = RoomFactory.create_combat_room()
	var room3_offset = Vector2i(current_x, FLOOR_Y - (room3.height - 1))
	_place_room(tile_map, room3, room3_offset)
	_add_room_label(room3_offset, "전투방 1")
	_connect_rooms(tile_map, room2_offset, room2.width, room3_offset)  # 방 2-3 연결

	# 적 마커 (바닥에 스폰)
	_add_enemy_marker(tile_map, Vector2i(room3_offset.x + 9, FLOOR_Y))
	_add_enemy_marker(tile_map, Vector2i(room3_offset.x + 12, FLOOR_Y))
	_add_enemy_marker(tile_map, Vector2i(room3_offset.x + 15, FLOOR_Y))

	current_x += room3.width
	print("   크기: %dx%d, 바닥 Y=%d, 다음 X: %d\n" % [room3.width, room3.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  방 4: 세이브 포인트 (Rest Area)
	# ═══════════════════════════════════════

	print("4. 세이브 포인트 생성...")
	var room4 = RoomFactory.create_rest_area()
	var room4_offset = Vector2i(current_x, FLOOR_Y - (room4.height - 1))
	_place_room(tile_map, room4, room4_offset)
	_add_room_label(room4_offset, "세이브")
	_connect_rooms(tile_map, room3_offset, room3.width, room4_offset)  # 방 3-4 연결
	_add_save_marker(tile_map, room4_offset + Vector2i(7, room4.height - 2))

	current_x += room4.width
	print("   크기: %dx%d, 바닥 Y=%d, 다음 X: %d\n" % [room4.width, room4.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  방 5: 전투방 2 (Combat Arena)
	# ═══════════════════════════════════════

	print("5. 전투방 2 생성...")
	var room5 = RoomFactory.create_combat_room()
	var room5_offset = Vector2i(current_x, FLOOR_Y - (room5.height - 1))
	_place_room(tile_map, room5, room5_offset)
	_add_room_label(room5_offset, "전투방 2")
	_connect_rooms(tile_map, room4_offset, room4.width, room5_offset)  # 방 4-5 연결

	# 적 마커 (바닥에 스폰)
	_add_enemy_marker(tile_map, Vector2i(room5_offset.x + 9, FLOOR_Y))
	_add_enemy_marker(tile_map, Vector2i(room5_offset.x + 12, FLOOR_Y))
	_add_enemy_marker(tile_map, Vector2i(room5_offset.x + 15, FLOOR_Y))

	current_x += room5.width
	print("   크기: %dx%d, 바닥 Y=%d, 다음 X: %d\n" % [room5.width, room5.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  방 6: 보스방 (Boss Arena)
	# ═══════════════════════════════════════

	print("6. 보스방 생성...")
	var room6 = RoomFactory.create_boss_room()
	var room6_offset = Vector2i(current_x, FLOOR_Y - (room6.height - 1))
	_place_room(tile_map, room6, room6_offset)
	_add_room_label(room6_offset, "보스: 천족 지네")
	_connect_rooms(tile_map, room5_offset, room5.width, room6_offset)  # 방 5-6 연결

	# 보스 마커
	_add_boss_marker(tile_map, room6_offset + Vector2i(12, room6.height - 4))

	current_x += room6.width
	print("   크기: %dx%d, 바닥 Y=%d, 다음 X: %d\n" % [room6.width, room6.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  방 7: 능력방 (Treasure Room)
	# ═══════════════════════════════════════

	print("7. 능력방 생성...")
	var room7 = RoomFactory.create_treasure_room()
	var room7_offset = Vector2i(current_x, FLOOR_Y - (room7.height - 1))
	_place_room(tile_map, room7, room7_offset)
	_add_room_label(room7_offset, "대시 능력")
	_connect_rooms(tile_map, room6_offset, room6.width, room7_offset)  # 방 6-7 연결

	# 능력 마커
	_add_ability_marker(tile_map, room7_offset + Vector2i(6, room7.height - 3))

	current_x += room7.width
	print("   크기: %dx%d, 바닥 Y=%d, 최종 X: %d\n" % [room7.width, room7.height, FLOOR_Y, current_x])

	# ═══════════════════════════════════════
	#  바닥 구멍 메우기 (모든 방 연결)
	# ═══════════════════════════════════════

	print("바닥 구멍 메우는 중...")
	_fill_floor_gaps(tile_map, current_x)

	# ═══════════════════════════════════════
	#  플레이어 스폰
	# ═══════════════════════════════════════

	_setup_player_spawn(room1_offset + room1.spawn_point)

	# ═══════════════════════════════════════
	#  배경 파티클 효과 (할로우 나이트 스타일)
	# ═══════════════════════════════════════

	await get_tree().process_frame  # 타일맵 완성 대기
	_setup_ambient_effects(tile_map)

	# ═══════════════════════════════════════
	#  적 스폰 (타일맵 완성 후)
	# ═══════════════════════════════════════
	_spawn_enemies()

	print("═══════════════════════════════════════")
	print("  맵 생성 완료!")
	print("  - 총 방: 7개")
	print("  - 총 길이: %d타일 (%d픽셀)" % [current_x, current_x * TILE_SIZE])
	print("  - 전투방: 2개 (각 3마리)")
	print("  - 보스: 1마리")
	print("  - 세이브: 1개")
	print("═══════════════════════════════════════\n")
	print("→ 오른쪽으로 탐험을 시작하세요!")


# ═══════════════════════════════════════════════════════════════════
#  유틸리티 함수
# ═══════════════════════════════════════════════════════════════════

func _place_room(tile_map: TileMapLayer, room: RoomTemplate, offset: Vector2i):
	"""방을 타일맵에 배치"""
	for y in range(room.height):
		for x in range(room.width):
			var tile_id = room.tiles[y][x]
			if tile_id >= 0:
				var world_pos = Vector2i(offset.x + x, offset.y + y)
				tile_map.set_cell(world_pos, tile_id, Vector2i(0, 0))


func _add_room_label(offset: Vector2i, label_text: String):
	"""방 라벨 표시 (디버그)"""
	print("   '%s' at %s" % [label_text, offset])


func _add_enemy_marker(tile_map: TileMapLayer, pos: Vector2i):
	"""적 스폰 위치 저장 (나중에 스폰)"""
	# 월드 좌표로 변환
	var world_pos = tile_map.map_to_local(pos)
	enemy_spawn_positions.append(world_pos)
	print("  → Enemy spawn queued at %s" % world_pos)


func _add_save_marker(tile_map: TileMapLayer, pos: Vector2i):
	"""세이브 포인트 (크리스탈 제거, 나중에 세이브 오브젝트 배치)"""
	# 크리스탈 마커 제거
	# TODO: 세이브 벤치 오브젝트 배치
	print("  → Save point at %s" % tile_map.map_to_local(pos))


func _add_boss_marker(tile_map: TileMapLayer, pos: Vector2i):
	"""보스 스폰 (크리스탈 제거, 나중에 보스 배치)"""
	# 크리스탈 마커 제거
	# TODO: 천족 지네 보스 배치
	print("  → Boss spawn at %s" % tile_map.map_to_local(pos))


func _add_ability_marker(tile_map: TileMapLayer, pos: Vector2i):
	"""능력 아이템 (크리스탈 제거, AbilityItem 배치)"""
	# 크리스탈 마커 제거

	# 능력 아이템 배치
	var ability_scene = preload("res://scenes/items/ability_item.tscn")
	var ability = ability_scene.instantiate()
	var world_pos = tile_map.map_to_local(pos)
	ability.global_position = world_pos
	add_child(ability)

	print("  → Ability item at %s" % world_pos)


func _connect_rooms(tile_map: TileMapLayer, left_offset: Vector2i, left_width: int, right_offset: Vector2i):
	"""두 방 사이의 벽을 제거하여 할로우 나이트 스타일 통로 생성"""
	# 왼쪽 방의 오른쪽 벽 X 좌표
	var left_wall_x = left_offset.x + left_width - 1
	# 오른쪽 방의 왼쪽 벽 X 좌표
	var right_wall_x = right_offset.x

	print("   연결: X %d → %d (거리: %d)" % [left_wall_x, right_wall_x, right_wall_x - left_wall_x])

	# 방 사이의 모든 X 좌표 처리
	for x in range(left_wall_x, right_wall_x + 1):
		# 1. 바닥 타일 확실히 연결 (FLOOR_Y=10)
		tile_map.set_cell(Vector2i(x, FLOOR_Y), 0, Vector2i(0, 0))  # 바닥 타일

		# 2. 통로 높이 만들기 (4타일 높이: Y: 6, 7, 8, 9)
		for dy in range(-4, 0):  # FLOOR_Y - 4부터 FLOOR_Y - 1까지
			tile_map.set_cell(Vector2i(x, FLOOR_Y + dy), -1, Vector2i(0, 0))  # 공기

		# 3. 천장 없애기 (더 높은 공간)
		for dy in range(-8, -4):  # 위쪽도 비우기
			tile_map.set_cell(Vector2i(x, FLOOR_Y + dy), -1, Vector2i(0, 0))


func _fill_floor_gaps(tile_map: TileMapLayer, total_width: int):
	"""맵 전체의 바닥(FLOOR_Y) 구멍을 메움"""
	var filled_count = 0

	# 맵 전체 X 범위에서 Y=FLOOR_Y에 바닥 타일 확인 및 채우기
	for x in range(-5, total_width + 5):  # 양쪽 여유 공간 포함
		var current_tile = tile_map.get_cell_source_id(Vector2i(x, FLOOR_Y))

		# 바닥이 비어있으면 채우기 (source_id == -1은 빈 타일)
		if current_tile == -1:
			tile_map.set_cell(Vector2i(x, FLOOR_Y), 0, Vector2i(0, 0))  # 바닥 타일
			filled_count += 1

	print("✓ 바닥 구멍 %d개 메움 (X: -5 ~ %d)" % [filled_count, total_width + 5])


func _setup_player_spawn(spawn_tile: Vector2i):
	"""플레이어 스폰"""
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.position = Vector2(spawn_tile.x * TILE_SIZE, spawn_tile.y * TILE_SIZE)
		if player.has_method("set_last_safe_position"):
			player.last_safe_position = player.position
		print("\n✓ 플레이어 스폰: 타일 %s, 월드 %s" % [spawn_tile, player.position])
	else:
		print("\n⚠ 플레이어 없음!")


func _setup_background(bg_layer: TileMapLayer):
	"""배경 레이어 설정 - 먼 동굴 벽"""
	const BG_TILE_ID = 1  # 벽 타일

	print("배경 레이어 생성 중...")

	# 더 자연스러운 노이즈 패턴
	for y in range(-10, 25):
		for x in range(-10, 160):
			# Perlin-like 노이즈 (더 자연스러운 패턴)
			var noise1 = (x * 3 + y * 5) % 100
			var noise2 = (x * 11 + y * 7) % 100
			var combined = (noise1 + noise2) / 2

			# 위쪽으로 갈수록 더 희미하게
			var y_factor = max(0, (25 - y)) / 35.0  # 0.0 ~ 1.0

			if combined < 40 + (y_factor * 30):  # 상단은 더 많이 배치
				bg_layer.set_cell(Vector2i(x, y), BG_TILE_ID, Vector2i(0, 0))

	# 그라디언트 효과 (위→아래 어두워짐)
	# 더 어둡고 청록색 톤 강화
	bg_layer.modulate = Color(0.15, 0.2, 0.25, 0.5)  # 매우 어두운 청록, 50% 투명

	print("✓ 배경 레이어 완료 (그라디언트 동굴 벽)")


func _setup_midground(midground: Node2D):
	"""중간 레이어 - 큰 구조물 실루엣"""
	print("중간 레이어 생성 중...")

	# 큰 기둥/유적 실루엣을 랜덤 위치에 배치
	var pillar_positions = [20, 50, 85, 120]  # X 위치

	for x_pos in pillar_positions:
		# ColorRect로 기둥 실루엣 생성
		var pillar = ColorRect.new()
		pillar.size = Vector2(64, 400)  # 넓고 높은 기둥
		pillar.position = Vector2(x_pos * TILE_SIZE, -100)
		pillar.color = Color(0.08, 0.12, 0.15, 0.3)  # 매우 어두운 청록, 30% 투명
		pillar.z_index = -1
		midground.add_child(pillar)

		# 변형 (약간 회전, 크기 변화)
		pillar.rotation_degrees = randf_range(-3, 3)
		pillar.scale.x = randf_range(0.8, 1.3)

	# 큰 암석 실루엣
	var rock_positions = [35, 70, 100, 135]

	for x_pos in rock_positions:
		var rock = ColorRect.new()
		rock.size = Vector2(96, 300)
		rock.position = Vector2(x_pos * TILE_SIZE, 0)
		rock.color = Color(0.1, 0.13, 0.16, 0.25)  # 더 옅은 실루엣
		rock.z_index = -1
		midground.add_child(rock)

		rock.rotation_degrees = randf_range(-5, 5)
		rock.scale.y = randf_range(0.7, 1.1)

	print("✓ 중간 레이어 완료 (구조물 실루엣 %d개)" % (pillar_positions.size() + rock_positions.size()))


func _setup_ambient_effects(tile_map: TileMapLayer):
	"""배경 파티클 효과 (할로우 나이트 스타일)"""
	print("\n배경 효과 설정 중...")

	const CRYSTAL_TILE_ID = 4
	var crystal_count = 0

	# 타일맵을 스캔해서 크리스탈 찾기
	for cell in tile_map.get_used_cells():
		var tile_data = tile_map.get_cell_tile_data(cell)
		if tile_map.get_cell_source_id(cell) == CRYSTAL_TILE_ID:
			# 할로우 나이트 스타일: 크리스탈 파티클 완전 제거
			# 크리스탈 타일 자체만으로 충분 (타일이 이미 밝은 청록색)
			crystal_count += 1

	print("✓ 크리스탈 마커 확인 완료 (%d개)" % crystal_count)

	# 3. 배경 먼지 파티클 추가
	_add_ambient_particles()


func _add_ambient_particles():
	"""배경 먼지 파티클 (할로우 나이트 분위기)"""
	print("배경 먼지 파티클 추가 중...")

	# 여러 위치에 먼지 파티클 배치
	var dust_positions = [
		Vector2(640, 240),   # 광장
		Vector2(1280, 240),  # 전투방1
		Vector2(1920, 240),  # 세이브
		Vector2(2560, 240),  # 전투방2
		Vector2(3200, 240),  # 보스방
	]

	for pos in dust_positions:
		var dust = GPUParticles2D.new()
		dust.position = pos
		dust.amount = 20  # 30 → 20 (감소)
		dust.lifetime = 10.0  # 8 → 10 (더 느리게)
		dust.preprocess = 2.0
		dust.explosiveness = 0.0

		var material = ParticleProcessMaterial.new()
		material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		material.emission_box_extents = Vector3(400, 300, 0)  # 넓은 영역
		material.direction = Vector3(0.1, -0.3, 0)  # 더 느리게
		material.spread = 20.0  # 30 → 20
		material.initial_velocity_min = 3.0  # 5 → 3
		material.initial_velocity_max = 8.0  # 15 → 8
		material.gravity = Vector3(0, 0, 0)  # 중력 없음
		material.scale_min = 0.08  # 0.1 → 0.08 (더 작게)
		material.scale_max = 0.2  # 0.3 → 0.2

		# 먼지 색상 (더욱 희미)
		var gradient = Gradient.new()
		gradient.add_point(0.0, Color(0.8, 0.8, 0.9, 0.05))  # 0.1 → 0.05 (매우 희미)
		gradient.add_point(0.5, Color(0.8, 0.8, 0.9, 0.08))  # 0.15 → 0.08
		gradient.add_point(1.0, Color(0.8, 0.8, 0.9, 0.0))  # 끝: 투명
		var gradient_texture = GradientTexture1D.new()
		gradient_texture.gradient = gradient
		material.color_ramp = gradient_texture

		dust.process_material = material
		dust.texture = preload("res://addons/kenney_particle_pack/dirt_02.png")
		dust.z_index = -1  # 배경 뒤에

		add_child(dust)

	print("✓ 배경 먼지 파티클 완료 (%d개 영역)" % dust_positions.size())


func _spawn_enemies():
	"""저장된 위치에 적 스폰 (타일맵 완성 후)"""
	print("\n적 스폰 시작...")

	var enemy_scene = preload("res://scenes/enemy/rock_beetle.tscn")

	for spawn_pos in enemy_spawn_positions:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_pos
		add_child(enemy)
		print("  → Rock Beetle: pos=%s, z_index=%d, visible=%s" % [spawn_pos, enemy.z_index, enemy.visible])

	print("✓ 적 스폰 완료 (%d마리)" % enemy_spawn_positions.size())

	# 디버그: 실제 자식 노드 확인
	await get_tree().process_frame
	var enemies = get_tree().get_nodes_in_group("enemy")
	print("  → 실제 적 수: %d" % enemies.size())
