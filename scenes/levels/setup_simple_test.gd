extends Node2D

## 초간단 테스트 맵 - 실제로 작동하는지 확인용
## 떨어지지 않는 최소한의 맵

const TILE_SIZE = 32
const GROUND = 0
const WALL = 1
const PLATFORM = 2
const CRYSTAL = 4

func _ready():
	var tile_map = $TileMapLayer
	print("=== 초간단 테스트 맵 ===")

	# ═══════════════════════════════════════
	#  1. 평평한 바닥 (넓고 긴)
	# ═══════════════════════════════════════

	# 바닥 (Y=10, X=0~100) - GROUND 타일
	print("바닥 배치 중...")
	for x in range(100):
		tile_map.set_cell(Vector2i(x, 10), GROUND, Vector2i(0, 0))
	print("  ✓ 바닥 100개 배치 완료")

	# 왼쪽 벽 (시작 지점) - WALL 타일
	print("벽 배치 중...")
	for y in range(11):
		tile_map.set_cell(Vector2i(0, y), WALL, Vector2i(0, 0))

	print("  ✓ 벽 배치 완료")

	# ═══════════════════════════════════════
	#  2. 간단한 플랫폼 (점프 연습)
	# ═══════════════════════════════════════

	# 플랫폼 1 (X=20~25, Y=7) - PLATFORM 타일
	print("플랫폼 배치 중...")
	for x in range(20, 26):
		tile_map.set_cell(Vector2i(x, 7), PLATFORM, Vector2i(0, 0))

	# 플랫폼 2 (X=30~35, Y=5)
	for x in range(30, 36):
		tile_map.set_cell(Vector2i(x, 5), PLATFORM, Vector2i(0, 0))
	print("  ✓ 플랫폼 2개 배치 완료")

	# 크리스탈 마커 (눈에 잘 보이게)
	print("크리스탈 마커 배치 중...")
	tile_map.set_cell(Vector2i(5, 9), CRYSTAL, Vector2i(0, 0))  # 바닥 위
	tile_map.set_cell(Vector2i(10, 9), CRYSTAL, Vector2i(0, 0))
	tile_map.set_cell(Vector2i(15, 9), CRYSTAL, Vector2i(0, 0))
	print("  ✓ 크리스탈 3개 배치 완료")

	# ═══════════════════════════════════════
	#  3. 벽 (끝 지점)
	# ═══════════════════════════════════════

	# 오른쪽 벽 (X=100)
	for y in range(11):
		tile_map.set_cell(Vector2i(100, y), WALL, Vector2i(0, 0))

	print("✓ 벽 생성: 양쪽")

	# ═══════════════════════════════════════
	#  4. 플레이어 스폰
	# ═══════════════════════════════════════

	var player = get_tree().get_first_node_in_group("player")
	if player:
		# 바닥 위에 스폰 (안전한 위치)
		player.position = Vector2(3 * TILE_SIZE, 8 * TILE_SIZE)
		if player.has_method("set_last_safe_position"):
			player.last_safe_position = player.position
		print("✓ 플레이어 스폰: %s" % player.position)
	else:
		print("⚠ 플레이어 없음!")

	# ═══════════════════════════════════════
	#  타일 배치 검증
	# ═══════════════════════════════════════

	print("\n타일 배치 검증:")
	var test_tile = tile_map.get_cell_source_id(Vector2i(5, 10))
	print("  - (5, 10) 타일 ID: %d (예상: 0=GROUND)" % test_tile)

	var test_crystal = tile_map.get_cell_source_id(Vector2i(5, 9))
	print("  - (5, 9) 타일 ID: %d (예상: 4=CRYSTAL)" % test_crystal)

	print("\n=== 테스트 맵 완료 ===")
	print("→ 오른쪽으로 걸어보세요 (떨어지면 안 됨!)")
	print("\n만약 타일이 안 보이면:")
	print("  1. 타일셋 이미지가 너무 크거나 (1024x1024)")
	print("  2. 타일 레이어 z-index 문제")
	print("  3. 타일 이미지 자체가 배경과 비슷한 색")
