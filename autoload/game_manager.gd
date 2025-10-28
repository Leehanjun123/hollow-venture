extends Node

# 싱글톤: GameManager (Autoload로 설정 필요)

enum PlayerMode { HUMAN, EVIL }

# 악신 모드 비활성화 (할로우 나이트 클론 모드)
# TODO: 나중에 독자적 게임으로 전환 시 악신 모드 재활성화
var current_mode: PlayerMode = PlayerMode.HUMAN  # 항상 HUMAN 고정
var ENABLE_MODE_SWITCHING: bool = false  # 모드 전환 비활성화 플래그

var current_room: String = "Starting Room"  # 현재 플레이어가 있는 룸
var unlocked_abilities: Dictionary = {
	"double_jump": false,
	"dash": false,
	"wall_jump": false,
}

signal mode_switched(new_mode: PlayerMode)

func switch_mode():
	# 할로우 나이트 클론 모드: 모드 전환 비활성화
	if not ENABLE_MODE_SWITCHING:
		print("GameManager: 모드 전환 비활성화 (할로우 나이트 클론 모드)")
		return

	# 악신 모드 코드 (비활성화됨)
	if current_mode == PlayerMode.HUMAN:
		current_mode = PlayerMode.EVIL
	else:
		current_mode = PlayerMode.HUMAN

	mode_switched.emit(current_mode)
	print("GameManager: 모드 전환 - %s" % ("악신" if current_mode == PlayerMode.EVIL else "인간"))

func on_enemy_killed():
	print("GameManager: 적 처치 기록")

func on_rage_activated():
	print("GameManager: 광폭화 발동 기록")

func on_parry_success():
	print("GameManager: 패링 성공 기록")

func print_debug_stats():
	print("=== 게임 통계 ===")
	print("현재 모드: %s" % ("악신" if current_mode == PlayerMode.EVIL else "인간"))
	print("해금된 능력: ", unlocked_abilities)
