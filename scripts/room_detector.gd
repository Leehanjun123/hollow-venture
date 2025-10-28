extends Area2D

## 룸 감지 시스템
## 플레이어가 들어오면 현재 룸 정보 전달

@export var room_name: String = ""
@export var room_description: String = ""
@export var next_objective: String = ""

signal player_entered_room(room_name: String, description: String, objective: String)

func _ready():
	# 플레이어만 감지
	collision_layer = 0
	collision_mask = 1  # 플레이어 레이어 (layer 1)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	print("RoomDetector 준비됨: %s" % room_name)

	# 이미 영역 안에 있는 플레이어 감지
	await get_tree().process_frame  # 물리 업데이트 대기
	_check_initial_overlap()


func _on_body_entered(body):
	# Player 클래스 대신 그룹으로 확인
	if body.is_in_group("player"):
		print("→ 플레이어 진입: %s" % room_name)
		player_entered_room.emit(room_name, room_description, next_objective)

		# GameManager에 현재 룸 알림
		if has_node("/root/GameManager"):
			get_node("/root/GameManager").current_room = room_name


func _on_body_exited(body):
	if body.is_in_group("player"):
		print("← 플레이어 퇴장: %s" % room_name)


func _check_initial_overlap():
	"""이미 영역 안에 있는 플레이어 체크"""
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			print("→ [초기] 플레이어 이미 영역 내: %s" % room_name)
			player_entered_room.emit(room_name, room_description, next_objective)

			# GameManager에 현재 룸 알림
			if has_node("/root/GameManager"):
				get_node("/root/GameManager").current_room = room_name
			break
