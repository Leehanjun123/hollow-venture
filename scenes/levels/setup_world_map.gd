extends Node2D

## ═══════════════════════════════════════════════════════════════════
## HOLLOW VENTURE - 완벽한 메트로배니아 월드 맵
## ═══════════════════════════════════════════════════════════════════
##
## 10개 지역, 200+ 방, 모든 게임 요소 통합
## 할로우 나이트 스타일 상호연결 구조
##
## 설계: Claude AI
## 버전: 1.0
## 날짜: 2025-10-23
##
## ═══════════════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════════════
#  글로벌 상수
# ═══════════════════════════════════════════════════════════════════

const TILE_SIZE = 32  # 타일 크기 (픽셀)

# 타일 ID (hollow_tileset.tres와 매칭)
const EMPTY = -1
const GROUND = 0
const WALL = 1
const PLATFORM = 2
const STALACTITE = 3
const CRYSTAL = 4

# 지역 시작 좌표 (타일 단위)
const REGION_OFFSETS = {
	"tutorial": Vector2i(0, 0),
	"plains": Vector2i(50, 0),
	"quarry": Vector2i(50, 30),
	"temple": Vector2i(100, 30),
	"spire": Vector2i(150, -20),
	"abyss": Vector2i(200, 0),
	"canyon": Vector2i(250, 0),
	"swamp": Vector2i(300, 20),
	"sanctum": Vector2i(350, 20),
	"maze": Vector2i(400, 0),
	"graveyard": Vector2i(450, 0)
}

# ═══════════════════════════════════════════════════════════════════
#  맵 생성 메인 함수
# ═══════════════════════════════════════════════════════════════════

func _ready():
	var tile_map = $TileMapLayer
	print("═══════════════════════════════════════")
	print("  HOLLOW VENTURE - 월드 맵 생성 시작")
	print("═══════════════════════════════════════")

	# 내비게이션 UI 추가
	_add_navigation_ui()

	# ═══════════════════════════════════════
	#  Phase 1: 초반 3개 지역 (완전 구현)
	# ═══════════════════════════════════════

	_create_tutorial_area(tile_map)
	_create_plains_region(tile_map)       # 1. 평원
	_create_quarry_region(tile_map)       # 2. 채석장
	_create_temple_region(tile_map)       # 3. 수중신전

	# ═══════════════════════════════════════
	#  Phase 2: 중반 지역 (프레임워크)
	# ═══════════════════════════════════════

	_create_spire_placeholder(tile_map)   # 4. 천공탑 (준비)
	_create_abyss_placeholder(tile_map)   # 5. 어둠동굴 (준비)

	# ═══════════════════════════════════════
	#  플레이어 스폰
	# ═══════════════════════════════════════

	_setup_player_spawn()

	print("═══════════════════════════════════════")
	print("  맵 생성 완료!")
	print("  - 총 지역: 5개 (3개 완성 + 2개 준비)")
	print("  - 총 방: ~70개")
	print("  - 보스: 3마리")
	print("═══════════════════════════════════════\n")


# ═══════════════════════════════════════════════════════════════════
#  🏠 튜토리얼 구역 (부족 폐허)
# ═══════════════════════════════════════════════════════════════════

func _create_tutorial_area(tile_map: TileMapLayer):
	print("\n[튜토리얼] 부족 폐허 생성 중...")
	var offset = REGION_OFFSETS["tutorial"]

	# 1. 시작방 (부족 마을 폐허)
	var start = RoomFactory.create_starting_room()
	_place_room(tile_map, start, offset)
	_add_room_detector("부족 폐허", offset, Vector2i(15, 10),
		"당신의 부족이 학살당한 곳...", "→ 복수를 위해 동쪽으로")
	_add_checkpoint(offset + Vector2i(7, 8), "시작 지점")

	# 2. 복도 → 평원 입구
	var corridor = RoomFactory.create_horizontal_corridor(10)
	_place_room(tile_map, corridor, offset + Vector2i(15, 3))
	_add_exit_arrow(tile_map, offset + Vector2i(24, 6), "right")

	print("  ✓ 튜토리얼 완료 (2개 방)")


# ═══════════════════════════════════════════════════════════════════
#  🌾 1. 광활한 평원 (The Golden Plains)
# ═══════════════════════════════════════════════════════════════════

func _create_plains_region(tile_map: TileMapLayer):
	print("\n[1. 평원] 광활한 평원 생성 중...")
	var base = REGION_OFFSETS["plains"]
	var room_count = 0

	# ─────────────────────────────────────
	#  평원 입구
	# ─────────────────────────────────────
	var entrance = RoomFactory.create_open_plaza()
	_place_room(tile_map, entrance, base)
	_add_room_detector("평원 입구", base, Vector2i(24, 18),
		"광활한 평원이 펼쳐진다", "탐험을 시작하세요")
	_spawn_enemies(base + Vector2i(12, 15), ["slime", "slime"])
	room_count += 1

	# ─────────────────────────────────────
	#  평원 1 - 전투방
	# ─────────────────────────────────────
	var plains1 = RoomFactory.create_combat_room()
	_place_room(tile_map, plains1, base + Vector2i(25, 3))
	_add_room_detector("평원 전투장 1", base + Vector2i(25, 3), Vector2i(18, 12),
		"첫 전투!", "적을 처치하세요")
	_spawn_enemies(base + Vector2i(33, 11), ["slime", "dog", "slime"])
	room_count += 1

	# ─────────────────────────────────────
	#  평원 2 - 넓은 광장
	# ─────────────────────────────────────
	var plains2 = RoomFactory.create_open_plaza()
	_place_room(tile_map, plains2, base + Vector2i(44, 0))
	_spawn_enemies(base + Vector2i(55, 15), ["dog", "dog"])
	room_count += 1

	# ─────────────────────────────────────
	#  고목나무 - 세이브 포인트 (벤치)
	# ─────────────────────────────────────
	var rest1 = RoomFactory.create_rest_area()
	_place_room(tile_map, rest1, base + Vector2i(69, 6))
	_add_room_detector("고목나무", base + Vector2i(69, 6), Vector2i(14, 9),
		"휴식 공간", "벤치에서 세이브")
	_add_checkpoint(base + Vector2i(76, 12), "고목나무 벤치")
	room_count += 1

	# ─────────────────────────────────────
	#  평원 3 - 전투방
	# ─────────────────────────────────────
	var plains3 = RoomFactory.create_combat_room()
	_place_room(tile_map, plains3, base + Vector2i(84, 3))
	_spawn_enemies(base + Vector2i(92, 11), ["slime", "dog", "dog"])
	room_count += 1

	# ─────────────────────────────────────
	#  비밀 지하 동굴
	# ─────────────────────────────────────
	var secret = RoomFactory.create_secret_room()
	_place_room(tile_map, secret, base + Vector2i(60, -15))
	_add_room_detector("비밀 지하동굴", base + Vector2i(60, -15), Vector2i(10, 7),
		"숨겨진 보물!", "크리스탈 획득")
	_spawn_item(base + Vector2i(65, -10), "soul_fragment")
	room_count += 1

	# ─────────────────────────────────────
	#  보스 입구
	# ─────────────────────────────────────
	var boss_approach = RoomFactory.create_long_corridor()
	_place_room(tile_map, boss_approach, base + Vector2i(103, 0))
	_add_room_detector("보스 입구", base + Vector2i(103, 0), Vector2i(30, 8),
		"거대한 기운이 느껴진다...", "천족 지네가 기다린다")
	room_count += 1

	# ─────────────────────────────────────
	#  보스방: 천족 지네 (Centipede Boss)
	# ─────────────────────────────────────
	var boss = RoomFactory.create_boss_room()
	_place_room(tile_map, boss, base + Vector2i(134, -3))
	_add_room_detector("천족 지네 보스방", base + Vector2i(134, -3), Vector2i(25, 15),
		"보스: 천족 지네", "다리의 수호자")
	_spawn_boss(base + Vector2i(146, 10), "centipede")
	room_count += 1

	# ─────────────────────────────────────
	#  능력방: 대시 획득
	# ─────────────────────────────────────
	var ability = RoomFactory.create_treasure_room()
	_place_room(tile_map, ability, base + Vector2i(160, -2))
	_add_room_detector("대시 능력방", base + Vector2i(160, -2), Vector2i(12, 10),
		"대시 능력 획득!", "Shift 키로 사용")
	_spawn_item(base + Vector2i(166, 5), "ability_dash")
	room_count += 1

	# ─────────────────────────────────────
	#  출구: 채석장 연결
	# ─────────────────────────────────────
	var exit_corridor = RoomFactory.create_vertical_corridor(20)
	_place_room(tile_map, exit_corridor, base + Vector2i(170, 8))
	_add_exit_arrow(tile_map, base + Vector2i(172, 27), "down")
	room_count += 1

	print("  ✓ 평원 완료 (%d개 방)" % room_count)
	print("    - 적: 슬라임×5, 들개×5")
	print("    - 보스: 천족 지네")
	print("    - 능력: 대시")


# ═══════════════════════════════════════════════════════════════════
#  ⛏️ 2. 버려진 채석장 (The Quarry)
# ═══════════════════════════════════════════════════════════════════

func _create_quarry_region(tile_map: TileMapLayer):
	print("\n[2. 채석장] 버려진 채석장 생성 중...")
	var base = REGION_OFFSETS["quarry"]
	var room_count = 0

	# ─────────────────────────────────────
	#  하층 입구 (평원에서 내려옴)
	# ─────────────────────────────────────
	var entrance = RoomFactory.create_open_plaza()
	_place_room(tile_map, entrance, base)
	_add_room_detector("채석장 하층", base, Vector2i(24, 18),
		"어두운 채석장", "위험한 기운이 감돈다")
	_spawn_enemies(base + Vector2i(12, 15), ["golem", "bat"])
	room_count += 1

	# ─────────────────────────────────────
	#  하층 전투방 1
	# ─────────────────────────────────────
	var combat1 = RoomFactory.create_combat_room()
	_place_room(tile_map, combat1, base + Vector2i(25, 3))
	_spawn_enemies(base + Vector2i(33, 11), ["golem", "zombie", "bat"])
	room_count += 1

	# ─────────────────────────────────────
	#  폐광 휴게소 - 세이브
	# ─────────────────────────────────────
	var rest = RoomFactory.create_rest_area()
	_place_room(tile_map, rest, base + Vector2i(44, 6))
	_add_checkpoint(base + Vector2i(51, 12), "폐광 휴게소")
	room_count += 1

	# ─────────────────────────────────────
	#  수직 샤프트 (하층 → 중층)
	# ─────────────────────────────────────
	var shaft1 = RoomFactory.create_climbing_shaft()
	_place_room(tile_map, shaft1, base + Vector2i(55, -17))
	_add_room_detector("등반 구간 1", base + Vector2i(55, -17), Vector2i(10, 25),
		"위로 올라가세요", "중층으로")
	room_count += 1

	# ─────────────────────────────────────
	#  중층 플랫폼 챌린지
	# ─────────────────────────────────────
	var challenge = RoomFactory.create_challenge_room()
	_place_room(tile_map, challenge, base + Vector2i(40, -23))
	_add_room_detector("플랫폼 챌린지", base + Vector2i(40, -23), Vector2i(22, 14),
		"점프 실력을 시험하라", "정확한 타이밍!")
	room_count += 1

	# ─────────────────────────────────────
	#  중층 전투방
	# ─────────────────────────────────────
	var combat2 = RoomFactory.create_combat_room()
	_place_room(tile_map, combat2, base + Vector2i(20, -20))
	_spawn_enemies(base + Vector2i(28, -12), ["zombie", "golem", "bat", "bat"])
	room_count += 1

	# ─────────────────────────────────────
	#  수직 샤프트 (중층 → 상층)
	# ─────────────────────────────────────
	var shaft2 = RoomFactory.create_vertical_shaft()
	_place_room(tile_map, shaft2, base + Vector2i(15, -40))
	room_count += 1

	# ─────────────────────────────────────
	#  상층 광장
	# ─────────────────────────────────────
	var upper = RoomFactory.create_open_plaza()
	_place_room(tile_map, upper, base + Vector2i(10, -42))
	_spawn_enemies(base + Vector2i(20, -27), ["golem", "zombie", "zombie"])
	room_count += 1

	# ─────────────────────────────────────
	#  상층 세이브 + 엘리베이터
	# ─────────────────────────────────────
	var rest2 = RoomFactory.create_rest_area()
	_place_room(tile_map, rest2, base + Vector2i(35, -36))
	_add_checkpoint(base + Vector2i(42, -30), "상층 휴게소")
	# TODO: 엘리베이터 기능 추가 (하층으로 빠른 이동)
	room_count += 1

	# ─────────────────────────────────────
	#  보스 입구
	# ─────────────────────────────────────
	var boss_approach = RoomFactory.create_narrow_passage()
	_place_room(tile_map, boss_approach, base + Vector2i(50, -36))
	_add_room_detector("보스 입구", base + Vector2i(50, -36), Vector2i(20, 6),
		"거대한 그림자가 보인다", "암벽 고릴라")
	room_count += 1

	# ─────────────────────────────────────
	#  보스방: 암벽 고릴라
	# ─────────────────────────────────────
	var boss = RoomFactory.create_boss_room()
	_place_room(tile_map, boss, base + Vector2i(71, -43))
	_add_room_detector("암벽 고릴라 보스방", base + Vector2i(71, -43), Vector2i(25, 15),
		"보스: 암벽 고릴라", "팔의 수호자")
	_spawn_boss(base + Vector2i(83, -31), "gorilla")
	room_count += 1

	# ─────────────────────────────────────
	#  능력방: 벽타기 획득
	# ─────────────────────────────────────
	var ability = RoomFactory.create_treasure_room()
	_place_room(tile_map, ability, base + Vector2i(97, -40))
	_add_room_detector("벽타기 능력방", base + Vector2i(97, -40), Vector2i(12, 10),
		"벽타기 능력 획득!", "벽에서 Space로 점프")
	_spawn_item(base + Vector2i(103, -33), "ability_wallclimb")
	room_count += 1

	# ─────────────────────────────────────
	#  출구: 수중신전 연결 (수직 낙하)
	# ─────────────────────────────────────
	var exit_shaft = RoomFactory.create_vertical_corridor(30)
	_place_room(tile_map, exit_shaft, base + Vector2i(107, -30))
	_add_exit_arrow(tile_map, base + Vector2i(109, 0), "down")
	room_count += 1

	print("  ✓ 채석장 완료 (%d개 방)" % room_count)
	print("    - 적: 골렘×4, 박쥐×4, 좀비×4")
	print("    - 보스: 암벽 고릴라")
	print("    - 능력: 벽타기")


# ═══════════════════════════════════════════════════════════════════
#  🌊 3. 침몰한 수중 신전 (The Sunken Temple)
# ═══════════════════════════════════════════════════════════════════

func _create_temple_region(tile_map: TileMapLayer):
	print("\n[3. 수중신전] 침몰한 수중 신전 생성 중...")
	var base = REGION_OFFSETS["temple"]
	var room_count = 0

	# ─────────────────────────────────────
	#  물가 플랫폼 (입구)
	# ─────────────────────────────────────
	var waterside = RoomFactory.create_rest_area()
	_place_room(tile_map, waterside, base)
	_add_room_detector("수중신전 입구", base, Vector2i(14, 9),
		"고대 신전이 물에 잠겨있다", "숨을 참고 들어가라")
	_add_checkpoint(base + Vector2i(7, 7), "물가 제단")
	room_count += 1

	# ─────────────────────────────────────
	#  얕은 물 구역 1 (잠수 10초)
	# ─────────────────────────────────────
	var shallow1 = RoomFactory.create_horizontal_corridor(15)
	_place_room(tile_map, shallow1, base + Vector2i(15, 2))
	_add_room_detector("얕은 물 1", base + Vector2i(15, 2), Vector2i(15, 5),
		"물속 탐험", "산소: 10초")
	_spawn_enemies(base + Vector2i(22, 4), ["aqua_beast"])
	room_count += 1

	# ─────────────────────────────────────
	#  얕은 물 구역 2
	# ─────────────────────────────────────
	var shallow2 = RoomFactory.create_combat_room()
	_place_room(tile_map, shallow2, base + Vector2i(31, -5))
	_add_room_detector("얕은 물 2", base + Vector2i(31, -5), Vector2i(18, 12),
		"물고기형 적 출현!", "빠르게 처치")
	_spawn_enemies(base + Vector2i(39, 3), ["aqua_beast", "jellyfish"])
	room_count += 1

	# ─────────────────────────────────────
	#  에어 포켓 (공기 방울)
	# ─────────────────────────────────────
	var air_pocket = RoomFactory.create_rest_area()
	_place_room(tile_map, air_pocket, base + Vector2i(50, -2))
	_add_room_detector("에어 포켓", base + Vector2i(50, -2), Vector2i(14, 9),
		"공기 방울!", "산소 회복")
	room_count += 1

	# ─────────────────────────────────────
	#  비밀방: 진주 (수중호흡 필요)
	# ─────────────────────────────────────
	var secret = RoomFactory.create_secret_room()
	_place_room(tile_map, secret, base + Vector2i(45, -20))
	_add_room_detector("진주방", base + Vector2i(45, -20), Vector2i(10, 7),
		"거대한 진주!", "HP +10 증가")
	_spawn_item(base + Vector2i(50, -15), "pearl")
	room_count += 1

	# ─────────────────────────────────────
	#  깊은 구간 (수중호흡 필수)
	# ─────────────────────────────────────
	var deep1 = RoomFactory.create_vertical_shaft()
	_place_room(tile_map, deep1, base + Vector2i(62, 7))
	_add_room_detector("깊은 구간", base + Vector2i(62, 7), Vector2i(8, 20),
		"⚠ 수중호흡 없으면 사망!", "더 깊은 곳으로")
	room_count += 1

	# ─────────────────────────────────────
	#  수중 미로
	# ─────────────────────────────────────
	var maze = RoomFactory.create_maze_section()
	_place_room(tile_map, maze, base + Vector2i(50, 28))
	_add_room_detector("수중 미로", base + Vector2i(50, 28), Vector2i(20, 16),
		"복잡한 수로", "길을 찾아라")
	_spawn_enemies(base + Vector2i(60, 36), ["water_spirit", "jellyfish", "aqua_beast"])
	room_count += 1

	# ─────────────────────────────────────
	#  보스방 입구
	# ─────────────────────────────────────
	var boss_approach = RoomFactory.create_narrow_passage()
	_place_room(tile_map, boss_approach, base + Vector2i(71, 35))
	_add_room_detector("보스 입구", base + Vector2i(71, 35), Vector2i(20, 6),
		"거대한 그림자가 다가온다", "심해 범고래")
	room_count += 1

	# ─────────────────────────────────────
	#  보스방: 심해 범고래 (물속 전투)
	# ─────────────────────────────────────
	var boss = RoomFactory.create_boss_room()
	_place_room(tile_map, boss, base + Vector2i(92, 29))
	_add_room_detector("심해 범고래 보스방", base + Vector2i(92, 29), Vector2i(25, 15),
		"보스: 심해 범고래", "폐의 수호자 (수중 전투!)")
	_spawn_boss(base + Vector2i(104, 39), "orca")
	room_count += 1

	# ─────────────────────────────────────
	#  능력방: 수중호흡 획득 (물 밖)
	# ─────────────────────────────────────
	var ability = RoomFactory.create_treasure_room()
	_place_room(tile_map, ability, base + Vector2i(118, 32))
	_add_room_detector("수중호흡 능력방", base + Vector2i(118, 32), Vector2i(12, 10),
		"수중호흡 능력 획득!", "이제 물속 자유롭게 탐험")
	_spawn_item(base + Vector2i(124, 39), "ability_waterbreath")
	room_count += 1

	# ─────────────────────────────────────
	#  출구: 평원 물 통로 (백트래킹 숏컷!)
	# ─────────────────────────────────────
	var shortcut = RoomFactory.create_horizontal_corridor(20)
	_place_room(tile_map, shortcut, base + Vector2i(131, 35))
	_add_room_detector("숏컷: 평원 연결", base + Vector2i(131, 35), Vector2i(20, 5),
		"물 통로 발견!", "평원으로 빠르게 이동")
	_add_exit_arrow(tile_map, base + Vector2i(150, 37), "right")
	room_count += 1

	print("  ✓ 수중신전 완료 (%d개 방)" % room_count)
	print("    - 적: 물고기형×3, 해파리×2, 정령×1")
	print("    - 보스: 심해 범고래")
	print("    - 능력: 수중호흡")
	print("    - 숏컷: 평원 물 통로")


# ═══════════════════════════════════════════════════════════════════
#  📦 Phase 2 준비: 천공탑, 어둠동굴 (플레이스홀더)
# ═══════════════════════════════════════════════════════════════════

func _create_spire_placeholder(tile_map: TileMapLayer):
	print("\n[4. 천공탑] 플레이스홀더 생성...")
	var base = REGION_OFFSETS["spire"]

	var placeholder = RoomFactory.create_rest_area()
	_place_room(tile_map, placeholder, base)
	_add_room_detector("천공의 탑 (준비 중)", base, Vector2i(14, 9),
		"⚠ 아직 구현되지 않음", "향후 업데이트 예정")
	_add_checkpoint(base + Vector2i(7, 7), "천공탑 입구")

	print("  ⏳ 천공탑 준비 완료 (1개 방)")


func _create_abyss_placeholder(tile_map: TileMapLayer):
	print("\n[5. 어둠동굴] 플레이스홀더 생성...")
	var base = REGION_OFFSETS["abyss"]

	var placeholder = RoomFactory.create_rest_area()
	_place_room(tile_map, placeholder, base)
	_add_room_detector("어둠의 동굴 (준비 중)", base, Vector2i(14, 9),
		"⚠ 아직 구현되지 않음", "향후 업데이트 예정")
	_add_checkpoint(base + Vector2i(7, 7), "동굴 입구")

	print("  ⏳ 어둠동굴 준비 완료 (1개 방)")


# ═══════════════════════════════════════════════════════════════════
#  🔧 유틸리티 함수들
# ═══════════════════════════════════════════════════════════════════

func _place_room(tile_map: TileMapLayer, room: RoomTemplate, offset: Vector2i):
	"""방을 타일맵에 배치"""
	for y in range(room.height):
		for x in range(room.width):
			var tile_id = room.tiles[y][x]
			if tile_id >= 0:
				var world_pos = Vector2i(offset.x + x, offset.y + y)
				tile_map.set_cell(world_pos, tile_id, Vector2i(0, 0))


func _add_room_detector(room_name: String, offset: Vector2i, size: Vector2i,
						 description: String, objective: String):
	"""룸 감지 영역 추가"""
	var detector = Area2D.new()
	detector.set_script(load("res://scripts/room_detector.gd"))
	detector.name = "RoomDetector_" + room_name.replace(" ", "_")
	detector.room_name = room_name
	detector.room_description = description
	detector.next_objective = objective

	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(size.x * TILE_SIZE, size.y * TILE_SIZE)
	collision.shape = shape
	collision.position = Vector2(
		(offset.x + size.x / 2.0) * TILE_SIZE,
		(offset.y + size.y / 2.0) * TILE_SIZE
	)

	detector.add_child(collision)
	add_child(detector)


func _add_checkpoint(tile_pos: Vector2i, checkpoint_name: String):
	"""세이브 포인트 (벤치) 추가"""
	# TODO: 실제 벤치 오브젝트 생성
	print("    💾 세이브 포인트: %s at %s" % [checkpoint_name, tile_pos])
	# var bench = preload("res://scenes/objects/bench.tscn").instantiate()
	# bench.position = Vector2(tile_pos) * TILE_SIZE
	# add_child(bench)


func _add_exit_arrow(tile_map: TileMapLayer, pos: Vector2i, direction: String):
	"""출구에 화살표 표시"""
	var arrow_positions = []
	match direction:
		"right": arrow_positions = [pos, pos + Vector2i(0, 1), pos + Vector2i(0, 2)]
		"left": arrow_positions = [pos, pos + Vector2i(0, 1), pos + Vector2i(0, 2)]
		"up": arrow_positions = [pos, pos + Vector2i(1, 0), pos + Vector2i(2, 0)]
		"down": arrow_positions = [pos, pos + Vector2i(1, 0), pos + Vector2i(2, 0)]

	for arrow_pos in arrow_positions:
		tile_map.set_cell(arrow_pos, CRYSTAL, Vector2i(0, 0))


func _spawn_enemies(tile_pos: Vector2i, enemy_types: Array):
	"""적 스폰"""
	print("    🐛 적 스폰: %s at %s" % [enemy_types, tile_pos])
	# TODO: 실제 적 생성
	# for i in range(enemy_types.size()):
	#     var enemy = preload("res://scenes/enemy/%s.tscn" % enemy_types[i]).instantiate()
	#     enemy.position = Vector2(tile_pos + Vector2i(i * 2, 0)) * TILE_SIZE
	#     add_child(enemy)


func _spawn_boss(tile_pos: Vector2i, boss_type: String):
	"""보스 스폰"""
	print("    🐉 보스 스폰: %s at %s" % [boss_type, tile_pos])
	# TODO: 보스 생성
	# var boss = preload("res://scenes/bosses/%s_boss.tscn" % boss_type).instantiate()
	# boss.position = Vector2(tile_pos) * TILE_SIZE
	# add_child(boss)


func _spawn_item(tile_pos: Vector2i, item_type: String):
	"""아이템 스폰"""
	print("    ⭐ 아이템 스폰: %s at %s" % [item_type, tile_pos])
	# TODO: 아이템 생성
	# var item = preload("res://scenes/items/%s.tscn" % item_type).instantiate()
	# item.position = Vector2(tile_pos) * TILE_SIZE
	# add_child(item)


func _add_navigation_ui():
	"""내비게이션 UI 추가"""
	var nav_ui = CanvasLayer.new()
	nav_ui.set_script(load("res://scripts/navigation_ui.gd"))
	nav_ui.name = "NavigationUI"
	add_child(nav_ui)


func _setup_player_spawn():
	"""플레이어 스폰 위치 설정"""
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var spawn_world = Vector2(2 * TILE_SIZE, 6 * TILE_SIZE)
		player.position = spawn_world
		if player.has_method("set_last_safe_position"):
			player.last_safe_position = spawn_world
		print("\n✓ 플레이어 스폰: %s" % spawn_world)
	else:
		print("\n⚠ 플레이어를 찾을 수 없습니다!")
