extends CanvasLayer

## 내비게이션 UI
## 현재 룸 이름 + 목표 표시

var room_label: Label
var objective_label: Label
var fade_timer: float = 0.0
const FADE_DURATION = 3.0

func _ready():
	# UI 생성
	_create_ui()

	# 모든 RoomDetector의 시그널 연결
	await get_tree().process_frame  # 씬이 완전히 로드될 때까지 대기
	_connect_room_detectors()


func _create_ui():
	# Room Name Label (상단 중앙)
	room_label = Label.new()
	room_label.name = "RoomLabel"
	room_label.text = "Starting Room"
	room_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	room_label.position = Vector2(0, 20)
	room_label.size = Vector2(1920, 100)  # 화면 너비
	room_label.add_theme_font_size_override("font_size", 36)
	room_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	room_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	room_label.add_theme_constant_override("outline_size", 8)
	add_child(room_label)

	# Objective Label (상단 중앙 아래)
	objective_label = Label.new()
	objective_label.name = "ObjectiveLabel"
	objective_label.text = "→ 오른쪽으로 이동"
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	objective_label.position = Vector2(0, 70)
	objective_label.size = Vector2(1920, 50)
	objective_label.add_theme_font_size_override("font_size", 24)
	objective_label.add_theme_color_override("font_color", Color(0.8, 0.8, 1, 1))
	objective_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	objective_label.add_theme_constant_override("outline_size", 4)
	add_child(objective_label)


func _connect_room_detectors():
	# 씬에 있는 모든 RoomDetector 찾기
	var detectors = get_tree().get_nodes_in_group("room_detector")

	if detectors.size() == 0:
		# RoomDetector 클래스로 직접 찾기
		var all_nodes = get_tree().root.get_children()
		for node in all_nodes:
			_find_room_detectors_recursive(node)
	else:
		for detector in detectors:
			if detector.has_signal("player_entered_room"):
				detector.player_entered_room.connect(_on_player_entered_room)


func _find_room_detectors_recursive(node):
	# RoomDetector 클래스 대신 시그널 존재 여부로 확인
	if node.has_signal("player_entered_room"):
		node.player_entered_room.connect(_on_player_entered_room)

	for child in node.get_children():
		_find_room_detectors_recursive(child)


func _on_player_entered_room(room_name: String, description: String, objective: String):
	# 룸 이름 업데이트
	room_label.text = room_name
	objective_label.text = objective if objective != "" else ""

	# 페이드 인 효과
	room_label.modulate = Color(1, 1, 1, 1)
	objective_label.modulate = Color(0.8, 0.8, 1, 1)
	fade_timer = FADE_DURATION


func _process(delta):
	# 페이드 아웃 (3초 후)
	if fade_timer > 0:
		fade_timer -= delta
		if fade_timer <= 0:
			# 천천히 사라지기
			var tween = create_tween()
			tween.tween_property(room_label, "modulate:a", 0.3, 1.0)
			tween.parallel().tween_property(objective_label, "modulate:a", 0.3, 1.0)
