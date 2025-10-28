extends Area2D

## 보스방 입구 트리거
## 플레이어가 닿으면 보스방 씬으로 전환

@export var boss_room_scene: String = "res://scenes/levels/boss_room_centipede.tscn"
@export var boss_name: String = "천족 지네 (Centipede of a Thousand Legs)"

var player_in_area: bool = false
var was_in_area: bool = false
var player: Node2D = null
var debug_timer: float = 0.0
var enter_pressed_last_frame: bool = false

func _ready():
	print("[BossRoomEntrance] Ready! Position: ", global_position)
	print("[BossRoomEntrance] collision_mask: ", collision_mask)
	print("[BossRoomEntrance] monitoring: ", monitoring)

func _process(delta: float):
	# 플레이어 찾기 (최초 1회)
	if not player:
		player = get_tree().get_first_node_in_group("player")
		if player:
			print("[BossRoomEntrance] Player found at: ", player.global_position)
		return  # 플레이어 없으면 리턴

	# 거리 기반 체크 (Area2D 무시)
	var distance = global_position.distance_to(player.global_position)
	player_in_area = distance < 100.0  # 100픽셀 이내면 입장 가능

	# 디버그: 플레이어 거리 출력 (1초마다)
	debug_timer += delta
	if debug_timer > 1.0:
		print("[BossRoomEntrance] Player distance: %.1f, In area: %s" % [distance, player_in_area])
		debug_timer = 0.0

	# 상태 변화 시 메시지 출력
	if player_in_area and not was_in_area:
		print(">>> 보스방 입구 근처 - Enter 키를 눌러 입장 <<<")
	elif not player_in_area and was_in_area:
		print(">>> 보스방 입구에서 벗어남 <<<")

	was_in_area = player_in_area

	# Enter, Space, E, F 키 모두 허용
	var enter_pressed_now = (Input.is_key_pressed(KEY_ENTER) or
	                          Input.is_key_pressed(KEY_KP_ENTER) or
	                          Input.is_key_pressed(KEY_SPACE) or
	                          Input.is_key_pressed(KEY_E) or
	                          Input.is_key_pressed(KEY_F))

	# 디버그: 키 감지 로그
	if enter_pressed_now and not enter_pressed_last_frame:
		print("[DEBUG] Key detected! player_in_area=%s, distance=%.1f" % [player_in_area, distance])

	if player_in_area and enter_pressed_now and not enter_pressed_last_frame:
		print("[BossRoomEntrance] Key pressed! Entering boss room...")
		_enter_boss_room()

	enter_pressed_last_frame = enter_pressed_now

func _enter_boss_room():
	print("========================================")
	print("보스방 입장 시작: %s" % boss_name)
	print("씬 경로: %s" % boss_room_scene)
	print("========================================")

	# 씬 파일 존재 확인
	if not FileAccess.file_exists(boss_room_scene):
		print("ERROR: 보스방 씬 파일이 없습니다! %s" % boss_room_scene)
		return

	# 보스방 씬으로 전환
	var result = get_tree().change_scene_to_file(boss_room_scene)
	if result != OK:
		print("ERROR: 씬 전환 실패! Error code: %d" % result)
	else:
		print("씬 전환 성공!")
