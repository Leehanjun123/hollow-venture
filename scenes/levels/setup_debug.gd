extends Node2D

## 최소한의 디버그 - 타일 하나라도 보이는지 확인

func _ready():
	print("========================================")
	print("디버그 시작!")
	print("========================================")

	var tile_map = $TileMapLayer
	print("1. TileMapLayer 찾기: %s" % tile_map)

	if not tile_map:
		print("❌ TileMapLayer를 찾을 수 없음!")
		return

	# 타일 1개 배치 (0, 0)
	print("2. 타일 배치 시도: (0, 0)")
	tile_map.set_cell(Vector2i(0, 0), 0, Vector2i(0, 0))
	print("   ✓ set_cell 실행됨")

	# 타일 10x10 영역 채우기 (확실히 보이게)
	print("3. 10x10 영역 채우기")
	for y in range(10):
		for x in range(10):
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	print("   ✓ 100개 타일 배치 완료")

	# 플레이어 찾기
	print("4. 플레이어 찾기")
	var player = get_tree().get_first_node_in_group("player")

	if player:
		print("   ✓ 플레이어 발견: %s" % player.name)
		print("   - 위치: %s" % player.position)

		# 플레이어를 (160, 160)으로 이동 (타일 (5,5) 위치)
		player.position = Vector2(160, 160)
		print("   - 새 위치: %s" % player.position)

		# 카메라 확인
		if player.has_node("Camera2D"):
			var camera = player.get_node("Camera2D")
			print("   ✓ 카메라 발견")
			print("   - 줌: %s" % camera.zoom)
			print("   - 활성화: %s" % camera.enabled)
		else:
			print("   ⚠ 플레이어에게 Camera2D 없음!")
	else:
		print("   ❌ 플레이어를 찾을 수 없음!")
		print("   - 'player' 그룹에 아무도 없음")

	print("========================================")
	print("디버그 완료!")
	print("========================================")
	print("")
	print("화면에 회색 사각형(10x10 타일)이 보여야 합니다")
	print("만약 안 보이면:")
	print("  1. 카메라가 다른 곳을 보고 있거나")
	print("  2. 타일셋이 제대로 로드되지 않았거나")
	print("  3. 타일맵 레이어가 비활성화되어 있습니다")
