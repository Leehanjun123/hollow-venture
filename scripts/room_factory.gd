extends Node
class_name RoomFactory

## 미리 디자인된 룸 템플릿들을 생성하는 팩토리

# 타일 ID 상수
const EMPTY = -1
const GROUND = 0
const WALL = 1
const PLATFORM = 2
const STALACTITE = 3
const CRYSTAL = 4


## 1. 시작방 - 할로우 나이트 스타일 동굴 입구
static func create_starting_room() -> RoomTemplate:
	var room = RoomTemplate.new("Cave Entrance", 20, 14)

	# ═══════════════════════════════════════
	#  바닥 (불규칙한 동굴 형태)
	# ═══════════════════════════════════════

	# 왼쪽 낮은 구역 (Y=13)
	room.draw_horizontal_line(0, 13, 6, GROUND)

	# 중앙 계단 (점진적 상승)
	room.draw_horizontal_line(6, 12, 3, GROUND)
	room.draw_horizontal_line(9, 11, 3, GROUND)

	# 오른쪽 높은 평지 (Y=10)
	room.draw_horizontal_line(12, 10, 8, GROUND)

	# ═══════════════════════════════════════
	#  벽 (불규칙한 동굴 벽)
	# ═══════════════════════════════════════

	# 왼쪽 벽 (입구)
	room.draw_vertical_line(0, 6, 8, WALL)  # 낮은 천장

	# 오른쪽 벽 (출구)
	room.draw_vertical_line(19, 0, 11, WALL)

	# 중앙 돌출부 (동굴 느낌)
	room.draw_horizontal_line(8, 8, 2, WALL)
	room.set_tile(9, 7, WALL)

	# ═══════════════════════════════════════
	#  천장 (고저차)
	# ═══════════════════════════════════════

	# 왼쪽 낮은 천장 (좁은 입구)
	room.draw_horizontal_line(0, 6, 6, GROUND)

	# 중앙 높은 천장 (넓어지는 공간)
	room.draw_horizontal_line(6, 2, 4, GROUND)
	room.draw_horizontal_line(10, 1, 4, GROUND)

	# 오른쪽 중간 천장
	room.draw_horizontal_line(14, 0, 6, GROUND)

	# ═══════════════════════════════════════
	#  플랫폼 & 탐험 요소
	# ═══════════════════════════════════════

	# 작은 플랫폼 (위쪽 탐험)
	room.draw_horizontal_line(4, 10, 2, PLATFORM)
	room.draw_horizontal_line(11, 7, 2, PLATFORM)
	room.draw_horizontal_line(15, 5, 3, PLATFORM)

	# 고드름 장식 (천장)
	room.set_tile(7, 3, STALACTITE)
	room.set_tile(12, 2, STALACTITE)
	room.set_tile(17, 1, STALACTITE)

	# 크리스탈 (환경 조명 역할)
	room.set_tile(4, 11, CRYSTAL)
	room.set_tile(16, 4, CRYSTAL)

	# ═══════════════════════════════════════
	#  스폰 & 출구
	# ═══════════════════════════════════════

	# 스폰 위치 (왼쪽 낮은 입구, 바닥Y=13 위)
	room.spawn_point = Vector2i(2, 12)

	# 오른쪽 출구 (높은 평지, 바닥Y=10 위)
	room.add_exit("right", Vector2i(19, 9))

	print("✓ Cave Entrance (할로우 나이트 스타일) 생성됨")
	return room


## 2. 전투방 - 전술적 전투 공간
static func create_combat_room() -> RoomTemplate:
	var room = RoomTemplate.new("Combat Arena", 22, 14)

	# ═══════════════════════════════════════
	#  바닥 (전투 공간 - Y=10 기준)
	# ═══════════════════════════════════════

	# 메인 바닥
	room.draw_horizontal_line(0, 10, 22, GROUND)

	# 왼쪽 작은 웅덩이 (낮음)
	room.draw_horizontal_line(3, 11, 3, GROUND)

	# 오른쪽 작은 웅덩이
	room.draw_horizontal_line(16, 11, 3, GROUND)

	# ═══════════════════════════════════════
	#  벽
	# ═══════════════════════════════════════

	room.draw_vertical_line(0, 0, 11, WALL)
	room.draw_vertical_line(21, 0, 11, WALL)

	# 중앙 돌출 벽 (전술 요소)
	room.draw_vertical_line(11, 6, 3, WALL)

	# ═══════════════════════════════════════
	#  천장
	# ═══════════════════════════════════════

	room.draw_horizontal_line(0, 0, 22, GROUND)

	# 중앙 낮은 부분
	room.draw_horizontal_line(9, 1, 4, GROUND)

	# ═══════════════════════════════════════
	#  플랫폼 (전투 중 이동)
	# ═══════════════════════════════════════

	# 하층 플랫폼 (양쪽)
	room.draw_horizontal_line(2, 8, 3, PLATFORM)
	room.draw_horizontal_line(17, 8, 3, PLATFORM)

	# 중층 플랫폼
	room.draw_horizontal_line(6, 6, 3, PLATFORM)
	room.draw_horizontal_line(13, 6, 3, PLATFORM)

	# 상층 플랫폼 (중앙)
	room.draw_horizontal_line(9, 4, 4, PLATFORM)

	# ═══════════════════════════════════════
	#  장식
	# ═══════════════════════════════════════

	room.set_tile(5, 1, STALACTITE)
	room.set_tile(10, 2, STALACTITE)
	room.set_tile(16, 1, STALACTITE)

	room.set_tile(11, 9, CRYSTAL)

	# ═══════════════════════════════════════
	#  스폰 & 출구
	# ═══════════════════════════════════════

	room.spawn_point = Vector2i(2, 9)
	room.add_exit("left", Vector2i(0, 9))
	room.add_exit("right", Vector2i(21, 9))

	print("✓ Combat Arena 생성됨")
	return room


## 3. 수직 샤프트 - 위아래로 긴 통로
static func create_vertical_shaft() -> RoomTemplate:
	var room = RoomTemplate.new("Vertical Shaft", 8, 20)

	# 왼쪽 벽
	room.draw_vertical_line(0, 0, 20, WALL)

	# 오른쪽 벽
	room.draw_vertical_line(7, 0, 20, WALL)

	# 바닥
	room.draw_horizontal_line(0, 19, 8, GROUND)

	# 천장
	room.draw_horizontal_line(0, 0, 8, GROUND)

	# 중간 쉴 수 있는 플랫폼들 (지그재그)
	room.draw_horizontal_line(1, 5, 3, PLATFORM)   # 왼쪽 상단
	room.draw_horizontal_line(4, 8, 3, PLATFORM)   # 오른쪽 중상
	room.draw_horizontal_line(1, 11, 3, PLATFORM)  # 왼쪽 중하
	room.draw_horizontal_line(4, 14, 3, PLATFORM)  # 오른쪽 하단

	# 천장 장식
	room.set_tile(2, 1, STALACTITE)
	room.set_tile(5, 1, STALACTITE)
	room.set_tile(3, 2, STALACTITE)

	# 스폰 (위쪽 입구)
	room.spawn_point = Vector2i(4, 2)

	# 출구
	room.add_exit("up", Vector2i(4, 0))      # 위쪽 입구
	room.add_exit("down", Vector2i(4, 19))   # 아래쪽 출구

	print("✓ Vertical Shaft 생성됨")
	return room


## 4. 비밀 보물방 - 작고 숨겨진 공간
static func create_secret_room() -> RoomTemplate:
	var room = RoomTemplate.new("Secret Treasure", 10, 7)

	# 완전히 닫힌 방 (벽으로 둘러싸임)
	room.draw_horizontal_line(0, 0, 10, WALL)   # 천장
	room.draw_horizontal_line(0, 6, 10, GROUND) # 바닥
	room.draw_vertical_line(0, 0, 7, WALL)      # 왼쪽 벽
	room.draw_vertical_line(9, 0, 7, WALL)      # 오른쪽 벽

	# 중앙에 크리스탈 보상들
	room.set_tile(4, 5, CRYSTAL)
	room.set_tile(5, 5, CRYSTAL)
	room.set_tile(3, 4, CRYSTAL)
	room.set_tile(6, 4, CRYSTAL)

	# 작은 플랫폼 (크리스탈까지 점프)
	room.draw_horizontal_line(2, 3, 2, PLATFORM)
	room.draw_horizontal_line(6, 3, 2, PLATFORM)

	# 아이템 스폰
	room.add_item_spawn(Vector2i(5, 4))

	# 스폰 (비밀 입구로 들어옴)
	room.spawn_point = Vector2i(2, 5)

	# 출구 (숨겨진 입구 하나만)
	room.add_exit("left", Vector2i(0, 5))

	print("✓ Secret Treasure 생성됨")
	return room


## 5. 넓은 보스방 - 천족 지네 전투장
static func create_boss_room() -> RoomTemplate:
	var room = RoomTemplate.new("Centipede Lair", 30, 18)

	# ═══════════════════════════════════════
	#  바닥 (넓은 전투 공간)
	# ═══════════════════════════════════════

	# 메인 바닥 (Y=10)
	room.draw_horizontal_line(0, 10, 30, GROUND)

	# 중앙 낮은 함몰 (보스 등장 지점)
	room.draw_horizontal_line(13, 11, 4, GROUND)

	# ═══════════════════════════════════════
	#  벽 (거대한 공간)
	# ═══════════════════════════════════════

	room.draw_vertical_line(0, 0, 11, WALL)
	room.draw_vertical_line(29, 0, 11, WALL)

	# ═══════════════════════════════════════
	#  천장 (매우 높음 - 보스가 크므로)
	# ═══════════════════════════════════════

	room.draw_horizontal_line(0, 0, 30, GROUND)
	room.draw_horizontal_line(5, 1, 20, GROUND)
	room.draw_horizontal_line(10, 2, 10, GROUND)

	# ═══════════════════════════════════════
	#  플랫폼 (회피용)
	# ═══════════════════════════════════════

	# 양쪽 높은 플랫폼 (안전 지대)
	room.draw_horizontal_line(3, 7, 4, PLATFORM)
	room.draw_horizontal_line(23, 7, 4, PLATFORM)

	# 중앙 플랫폼들 (위험한 공격 위치)
	room.draw_horizontal_line(8, 8, 3, PLATFORM)
	room.draw_horizontal_line(19, 8, 3, PLATFORM)

	# 최상층 플랫폼 (긴급 회피)
	room.draw_horizontal_line(13, 5, 4, PLATFORM)

	# ═══════════════════════════════════════
	#  장식
	# ═══════════════════════════════════════

	# 천장 고드름 (보스 테마)
	room.set_tile(7, 1, STALACTITE)
	room.set_tile(15, 3, STALACTITE)
	room.set_tile(22, 1, STALACTITE)

	# 크리스탈 (약간의 조명)
	room.set_tile(5, 9, CRYSTAL)
	room.set_tile(24, 9, CRYSTAL)

	# ═══════════════════════════════════════
	#  스폰 & 출구
	# ═══════════════════════════════════════

	room.spawn_point = Vector2i(3, 9)
	room.add_exit("left", Vector2i(0, 9))
	room.add_exit("right", Vector2i(29, 9))

	print("✓ Centipede Lair (보스방) 생성됨")
	return room


## 6. 긴 복도 - 좌우 이동
static func create_long_corridor() -> RoomTemplate:
	var room = RoomTemplate.new("Long Corridor", 30, 8)

	# 바닥
	room.draw_horizontal_line(0, 7, 30, GROUND)

	# 천장
	room.draw_horizontal_line(0, 0, 30, GROUND)

	# 양쪽 벽
	room.draw_vertical_line(0, 0, 8, WALL)
	room.draw_vertical_line(29, 0, 8, WALL)

	# 중간에 플랫폼 (리듬감)
	room.draw_horizontal_line(8, 4, 3, PLATFORM)
	room.draw_horizontal_line(19, 4, 3, PLATFORM)

	# 천장 장식
	room.set_tile(5, 1, STALACTITE)
	room.set_tile(15, 1, STALACTITE)
	room.set_tile(24, 1, STALACTITE)

	# 크리스탈 (중간 지점 표시)
	room.set_tile(15, 6, CRYSTAL)

	room.spawn_point = Vector2i(2, 6)
	room.add_exit("left", Vector2i(0, 6))
	room.add_exit("right", Vector2i(29, 6))

	print("✓ Long Corridor 생성됨")
	return room


## 7. T자 교차로 - 3방향 선택
static func create_junction() -> RoomTemplate:
	var room = RoomTemplate.new("T-Junction", 20, 15)

	# 바닥 (T자 형태)
	room.draw_horizontal_line(0, 14, 20, GROUND)  # 하단 바닥

	# 벽 (T자 형태)
	room.draw_vertical_line(0, 7, 8, WALL)   # 왼쪽 하단 벽
	room.draw_vertical_line(19, 7, 8, WALL)  # 오른쪽 하단 벽

	# 중앙 수직 통로 벽
	room.draw_vertical_line(8, 0, 7, WALL)
	room.draw_vertical_line(11, 0, 7, WALL)

	# 천장 (부분)
	room.draw_horizontal_line(0, 0, 8, GROUND)
	room.draw_horizontal_line(12, 0, 8, GROUND)

	# 플랫폼 (각 방향으로 가는 길)
	room.draw_horizontal_line(3, 11, 3, PLATFORM)   # 왼쪽
	room.draw_horizontal_line(14, 11, 3, PLATFORM)  # 오른쪽

	# 위쪽으로 가는 등반 플랫폼 (지그재그)
	room.draw_horizontal_line(9, 10, 2, PLATFORM)   # 1층
	room.draw_horizontal_line(9, 7, 2, PLATFORM)    # 2층
	room.draw_horizontal_line(9, 4, 2, PLATFORM)    # 3층 (최상층)

	# 크리스탈 (방향 표시)
	room.set_tile(2, 13, CRYSTAL)   # 왼쪽
	room.set_tile(17, 13, CRYSTAL)  # 오른쪽
	room.set_tile(9, 3, CRYSTAL)    # 위쪽

	room.spawn_point = Vector2i(10, 13)
	room.add_exit("left", Vector2i(0, 13))
	room.add_exit("right", Vector2i(19, 13))
	room.add_exit("up", Vector2i(9, 0))

	print("✓ T-Junction 생성됨")
	return room


## 8. 함정방 - 고드름/가시
static func create_trap_room() -> RoomTemplate:
	var room = RoomTemplate.new("Trap Room", 16, 12)

	# 바닥
	room.draw_horizontal_line(0, 11, 16, GROUND)

	# 벽
	room.draw_vertical_line(0, 0, 12, WALL)
	room.draw_vertical_line(15, 0, 12, WALL)

	# 천장
	room.draw_horizontal_line(0, 0, 16, GROUND)

	# 플랫폼 (지그재그로 피해야 함)
	room.draw_horizontal_line(2, 8, 3, PLATFORM)
	room.draw_horizontal_line(7, 6, 3, PLATFORM)
	room.draw_horizontal_line(11, 8, 3, PLATFORM)

	# 위험! 많은 고드름
	room.set_tile(4, 1, STALACTITE)
	room.set_tile(5, 1, STALACTITE)
	room.set_tile(8, 1, STALACTITE)
	room.set_tile(9, 1, STALACTITE)
	room.set_tile(12, 1, STALACTITE)
	room.set_tile(13, 1, STALACTITE)

	# 바닥 가시 표시 (크리스탈로 경고)
	room.set_tile(6, 10, CRYSTAL)
	room.set_tile(10, 10, CRYSTAL)

	room.spawn_point = Vector2i(2, 10)
	room.add_exit("left", Vector2i(0, 10))
	room.add_exit("right", Vector2i(15, 10))

	print("✓ Trap Room 생성됨")
	return room


## 9. 보상방 - 대시 능력 획득
static func create_treasure_room() -> RoomTemplate:
	var room = RoomTemplate.new("Ability Shrine", 14, 14)

	# ═══════════════════════════════════════
	#  바닥
	# ═══════════════════════════════════════

	room.draw_horizontal_line(0, 10, 14, GROUND)

	# 중앙 제단 (계단식)
	room.draw_horizontal_line(5, 9, 4, GROUND)
	room.draw_horizontal_line(6, 8, 2, GROUND)

	# ═══════════════════════════════════════
	#  벽 (성스러운 공간)
	# ═══════════════════════════════════════

	room.draw_vertical_line(0, 2, 9, WALL)
	room.draw_vertical_line(13, 2, 9, WALL)

	# 아치형 입구
	room.set_tile(1, 4, WALL)
	room.set_tile(12, 4, WALL)

	# ═══════════════════════════════════════
	#  천장 (높고 장엄함)
	# ═══════════════════════════════════════

	room.draw_horizontal_line(1, 2, 12, GROUND)
	room.draw_horizontal_line(3, 1, 8, GROUND)
	room.draw_horizontal_line(5, 0, 4, GROUND)

	# ═══════════════════════════════════════
	#  플랫폼 (능력 획득용)
	# ═══════════════════════════════════════

	# 최상층 (능력 위치)
	room.draw_horizontal_line(6, 6, 2, PLATFORM)

	# 접근 플랫폼
	room.draw_horizontal_line(3, 8, 2, PLATFORM)
	room.draw_horizontal_line(9, 8, 2, PLATFORM)

	# ═══════════════════════════════════════
	#  장식 (성스러운 분위기)
	# ═══════════════════════════════════════

	# 능력 주변 크리스탈 (발광)
	room.set_tile(6, 5, CRYSTAL)  # 능력 위
	room.set_tile(7, 5, CRYSTAL)
	room.set_tile(5, 6, CRYSTAL)
	room.set_tile(8, 6, CRYSTAL)
	room.set_tile(6, 7, CRYSTAL)
	room.set_tile(7, 7, CRYSTAL)

	# 바닥 크리스탈
	room.set_tile(3, 9, CRYSTAL)
	room.set_tile(10, 9, CRYSTAL)

	# 천장 장식
	room.set_tile(4, 1, STALACTITE)
	room.set_tile(9, 1, STALACTITE)

	# ═══════════════════════════════════════
	#  스폰 & 출구
	# ═══════════════════════════════════════

	room.spawn_point = Vector2i(2, 9)
	room.add_exit("left", Vector2i(0, 9))

	print("✓ Ability Shrine (능력방) 생성됨")
	return room


## 10. 쉼터 - 평화로운 세이브 포인트
static func create_rest_area() -> RoomTemplate:
	var room = RoomTemplate.new("Safe Haven", 16, 12)

	# ═══════════════════════════════════════
	#  바닥 (평평하고 안전한 느낌)
	# ═══════════════════════════════════════

	room.draw_horizontal_line(0, 10, 16, GROUND)

	# 중앙 약간 높은 제단 (세이브 포인트)
	room.draw_horizontal_line(6, 9, 4, GROUND)
	room.draw_horizontal_line(7, 8, 2, GROUND)

	# ═══════════════════════════════════════
	#  벽 (부드러운 곡선)
	# ═══════════════════════════════════════

	room.draw_vertical_line(0, 2, 9, WALL)
	room.draw_vertical_line(15, 2, 9, WALL)

	# 둥근 느낌 (모서리)
	room.set_tile(1, 3, WALL)
	room.set_tile(14, 3, WALL)

	# ═══════════════════════════════════════
	#  천장 (높고 평화로움)
	# ═══════════════════════════════════════

	room.draw_horizontal_line(1, 2, 14, GROUND)
	room.draw_horizontal_line(3, 1, 10, GROUND)
	room.draw_horizontal_line(5, 0, 6, GROUND)

	# ═══════════════════════════════════════
	#  장식 (평화로운 분위기)
	# ═══════════════════════════════════════

	# 벤치 플랫폼
	room.draw_horizontal_line(3, 9, 2, PLATFORM)
	room.draw_horizontal_line(11, 9, 2, PLATFORM)

	# 발광 크리스탈 (세이브 포인트)
	room.set_tile(7, 7, CRYSTAL)  # 중앙 위
	room.set_tile(6, 8, CRYSTAL)
	room.set_tile(8, 8, CRYSTAL)
	room.set_tile(7, 9, CRYSTAL)  # 제단 주변

	# 부드러운 고드름 (위협적이지 않음)
	room.set_tile(4, 2, STALACTITE)
	room.set_tile(11, 2, STALACTITE)

	# ═══════════════════════════════════════
	#  스폰 & 출구
	# ═══════════════════════════════════════

	room.spawn_point = Vector2i(3, 9)
	room.add_exit("left", Vector2i(0, 9))
	room.add_exit("right", Vector2i(15, 9))

	print("✓ Safe Haven (세이브 포인트) 생성됨")
	return room


## 11. 좁은 통로 - 긴장감
static func create_narrow_passage() -> RoomTemplate:
	var room = RoomTemplate.new("Narrow Passage", 20, 6)

	# 바닥
	room.draw_horizontal_line(0, 5, 20, GROUND)

	# 천장 (낮음)
	room.draw_horizontal_line(0, 0, 20, GROUND)

	# 벽
	room.draw_vertical_line(0, 0, 6, WALL)
	room.draw_vertical_line(19, 0, 6, WALL)

	# 고드름 (머리 조심!)
	room.set_tile(5, 1, STALACTITE)
	room.set_tile(10, 1, STALACTITE)
	room.set_tile(15, 1, STALACTITE)

	# 작은 장애물 플랫폼
	room.set_tile(8, 4, PLATFORM)
	room.set_tile(12, 4, PLATFORM)

	room.spawn_point = Vector2i(2, 4)
	room.add_exit("left", Vector2i(0, 4))
	room.add_exit("right", Vector2i(19, 4))

	print("✓ Narrow Passage 생성됨")
	return room


## 12. 넓은 광장 - 거대한 동굴 공간 (평원 유적)
static func create_open_plaza() -> RoomTemplate:
	var room = RoomTemplate.new("Ruined Plaza", 28, 20)

	# ═══════════════════════════════════════
	#  바닥 (평평하지만 넓음 - 광장 느낌)
	# ═══════════════════════════════════════

	# 메인 바닥 (Y=10으로 통일)
	room.draw_horizontal_line(0, 10, 28, GROUND)

	# 왼쪽/오른쪽 약간 높은 부분 (유적 잔해)
	room.draw_horizontal_line(2, 9, 3, GROUND)
	room.draw_horizontal_line(23, 9, 3, GROUND)

	# ═══════════════════════════════════════
	#  벽 (넓은 공간)
	# ═══════════════════════════════════════

	# 왼쪽 벽
	room.draw_vertical_line(0, 0, 11, WALL)

	# 오른쪽 벽
	room.draw_vertical_line(27, 0, 11, WALL)

	# 무너진 기둥 (유적 느낌)
	room.draw_vertical_line(8, 7, 4, WALL)  # 왼쪽 기둥
	room.draw_vertical_line(19, 6, 5, WALL)  # 오른쪽 기둥

	# ═══════════════════════════════════════
	#  천장 (매우 높음 - 광장 느낌)
	# ═══════════════════════════════════════

	# 높은 천장
	room.draw_horizontal_line(0, 0, 8, GROUND)
	room.draw_horizontal_line(20, 0, 8, GROUND)

	# 중앙 더 높음 (돔 느낌)
	room.draw_horizontal_line(8, 1, 4, GROUND)
	room.draw_horizontal_line(16, 1, 4, GROUND)

	# ═══════════════════════════════════════
	#  플랫폼 (탐험 경로)
	# ═══════════════════════════════════════

	# 하층 플랫폼
	room.draw_horizontal_line(5, 8, 3, PLATFORM)
	room.draw_horizontal_line(20, 8, 3, PLATFORM)

	# 중층 플랫폼
	room.draw_horizontal_line(3, 6, 2, PLATFORM)
	room.draw_horizontal_line(11, 5, 4, PLATFORM)
	room.draw_horizontal_line(23, 6, 2, PLATFORM)

	# 상층 플랫폼 (높은 곳)
	room.draw_horizontal_line(13, 3, 3, PLATFORM)

	# ═══════════════════════════════════════
	#  장식 & 환경 요소
	# ═══════════════════════════════════════

	# 천장 고드름
	room.set_tile(6, 1, STALACTITE)
	room.set_tile(14, 2, STALACTITE)
	room.set_tile(22, 1, STALACTITE)

	# 크리스탈 (광장 조명)
	room.set_tile(10, 9, CRYSTAL)
	room.set_tile(17, 9, CRYSTAL)
	room.set_tile(14, 2, CRYSTAL)

	# ═══════════════════════════════════════
	#  스폰 & 출구
	# ═══════════════════════════════════════

	room.spawn_point = Vector2i(3, 9)
	room.add_exit("left", Vector2i(0, 9))
	room.add_exit("right", Vector2i(27, 9))

	print("✓ Ruined Plaza (넓은 광장) 생성됨")
	return room


## 13. 수직 등반 - 위로 올라가기
static func create_climbing_shaft() -> RoomTemplate:
	var room = RoomTemplate.new("Climbing Shaft", 10, 25)

	# 벽
	room.draw_vertical_line(0, 0, 25, WALL)
	room.draw_vertical_line(9, 0, 25, WALL)

	# 바닥
	room.draw_horizontal_line(0, 24, 10, GROUND)

	# 천장
	room.draw_horizontal_line(0, 0, 10, GROUND)

	# 등반용 플랫폼 (교차 배치)
	room.draw_horizontal_line(1, 22, 3, PLATFORM)
	room.draw_horizontal_line(6, 19, 3, PLATFORM)
	room.draw_horizontal_line(1, 16, 3, PLATFORM)
	room.draw_horizontal_line(6, 13, 3, PLATFORM)
	room.draw_horizontal_line(1, 10, 3, PLATFORM)
	room.draw_horizontal_line(6, 7, 3, PLATFORM)
	room.draw_horizontal_line(1, 4, 3, PLATFORM)

	# 크리스탈 (중간 지점)
	room.set_tile(2, 15, CRYSTAL)
	room.set_tile(7, 8, CRYSTAL)

	room.spawn_point = Vector2i(5, 23)
	room.add_exit("down", Vector2i(5, 24))
	room.add_exit("up", Vector2i(5, 0))

	print("✓ Climbing Shaft 생성됨")
	return room


## 14. 미로 구간 - 복잡한 경로
static func create_maze_section() -> RoomTemplate:
	var room = RoomTemplate.new("Maze Section", 20, 16)

	# 외벽
	room.draw_horizontal_line(0, 0, 20, GROUND)
	room.draw_horizontal_line(0, 15, 20, GROUND)
	room.draw_vertical_line(0, 0, 16, WALL)
	room.draw_vertical_line(19, 0, 16, WALL)

	# 내부 벽 (미로)
	room.draw_vertical_line(5, 3, 10, WALL)
	room.draw_vertical_line(10, 2, 8, WALL)
	room.draw_vertical_line(15, 5, 8, WALL)

	# 수평 벽
	room.draw_horizontal_line(5, 5, 6, WALL)
	room.draw_horizontal_line(10, 10, 6, WALL)

	# 플랫폼 (지름길)
	room.draw_horizontal_line(7, 7, 3, PLATFORM)
	room.draw_horizontal_line(12, 12, 3, PLATFORM)

	# 크리스탈 (힌트)
	room.set_tile(8, 14, CRYSTAL)
	room.set_tile(17, 6, CRYSTAL)

	room.spawn_point = Vector2i(2, 14)
	room.add_exit("left", Vector2i(0, 14))
	room.add_exit("right", Vector2i(19, 14))

	print("✓ Maze Section 생성됨")
	return room


## 15. 챌린지 룸 - 플랫폼 점프
static func create_challenge_room() -> RoomTemplate:
	var room = RoomTemplate.new("Challenge Room", 22, 14)

	# 바닥 (떨어지면 시작점)
	room.draw_horizontal_line(0, 13, 22, GROUND)

	# 벽
	room.draw_vertical_line(0, 0, 14, WALL)
	room.draw_vertical_line(21, 0, 14, WALL)

	# 천장
	room.draw_horizontal_line(0, 0, 22, GROUND)

	# 어려운 플랫폼 점프 (간격 넓음)
	room.draw_horizontal_line(2, 11, 2, PLATFORM)
	room.draw_horizontal_line(6, 9, 2, PLATFORM)
	room.draw_horizontal_line(10, 7, 2, PLATFORM)
	room.draw_horizontal_line(14, 5, 2, PLATFORM)
	room.draw_horizontal_line(18, 3, 2, PLATFORM)

	# 고드름 (난이도 증가)
	room.set_tile(8, 1, STALACTITE)
	room.set_tile(12, 1, STALACTITE)
	room.set_tile(16, 1, STALACTITE)

	# 보상 크리스탈 (끝)
	room.set_tile(19, 2, CRYSTAL)
	room.set_tile(20, 2, CRYSTAL)

	# 아이템 스폰 (보상)
	room.add_item_spawn(Vector2i(19, 2))

	room.spawn_point = Vector2i(2, 12)
	room.add_exit("left", Vector2i(0, 12))
	room.add_exit("right", Vector2i(21, 3))

	print("✓ Challenge Room 생성됨")
	return room


## 16. 수평 복도 - 룸 연결용
static func create_horizontal_corridor(length: int) -> RoomTemplate:
	var room = RoomTemplate.new("Corridor", length, 5)

	# 바닥
	room.draw_horizontal_line(0, 4, length, GROUND)

	# 천장
	room.draw_horizontal_line(0, 0, length, GROUND)

	# 양쪽 벽 (닫힌 복도)
	if length > 2:
		room.draw_vertical_line(0, 0, 5, WALL)
		room.draw_vertical_line(length - 1, 0, 5, WALL)

	room.add_exit("left", Vector2i(0, 3))
	room.add_exit("right", Vector2i(length - 1, 3))

	return room


## 17. 수직 복도 - 위아래 연결용
static func create_vertical_corridor(height: int) -> RoomTemplate:
	var room = RoomTemplate.new("Vertical Corridor", 5, height)

	# 왼쪽 벽
	room.draw_vertical_line(0, 0, height, WALL)

	# 오른쪽 벽
	room.draw_vertical_line(4, 0, height, WALL)

	# 플랫폼 (내려가거나 올라가기 위한 발판)
	var platform_interval = max(3, height / 5)
	for i in range(1, height, platform_interval):
		if i % 2 == 0:
			room.draw_horizontal_line(1, i, 2, PLATFORM)
		else:
			room.draw_horizontal_line(2, i, 2, PLATFORM)

	room.add_exit("up", Vector2i(2, 0))
	room.add_exit("down", Vector2i(2, height - 1))

	return room
