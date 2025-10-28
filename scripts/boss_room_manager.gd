extends Node2D

## 보스방 연출 매니저
## 입장 연출, 카메라 워크, BGM 전환 등 담당

@export var boss_name: String = "천족 지네\n(Centipede of a Thousand Legs)"

@onready var boss: Node2D = $CentipedeBoss
@onready var player: Node2D = $Player
@onready var camera: Camera2D = $Player/Camera2D if $Player.has_node("Camera2D") else null

var entrance_played: bool = false

func _ready():
	# 보스방 입장 연출 시작
	await get_tree().create_timer(0.1).timeout  # 씬 로드 대기
	_play_entrance_cutscene()

func _play_entrance_cutscene():
	if entrance_played:
		return
	entrance_played = true

	# 1. 페이드 인
	await _fade_in()

	# 2. 플레이어 컨트롤 비활성화
	if player and player.has_method("set_can_move"):
		player.set_can_move(false)

	# 3. 카메라 보스에게 줌
	if camera and boss:
		await _camera_focus_boss()

	# 4. 보스 이름 표시
	await _show_boss_title()

	# 5. 카메라 플레이어로 복귀
	if camera:
		await _camera_return_to_player()

	# 6. 플레이어 컨트롤 활성화
	if player and player.has_method("set_can_move"):
		player.set_can_move(true)

	print("Boss fight start!")

func _fade_in() -> void:
	# 페이드 인 효과
	var fade_layer = CanvasLayer.new()
	fade_layer.layer = 200
	add_child(fade_layer)

	var fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK
	fade_rect.size = Vector2(1920, 1080)
	fade_layer.add_child(fade_rect)

	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.5)
	await tween.finished

	fade_layer.queue_free()

func _camera_focus_boss() -> void:
	if not camera or not boss:
		return

	var original_zoom = camera.zoom
	var boss_pos = boss.global_position

	# 보스 위치로 카메라 이동 + 줌인
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camera, "global_position", boss_pos, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 1.0).set_trans(Tween.TRANS_CUBIC)

	await tween.finished
	await get_tree().create_timer(0.5).timeout  # 보스 보기

func _show_boss_title() -> void:
	# 보스 타이틀 UI 생성
	var title_ui = CanvasLayer.new()
	title_ui.layer = 100
	add_child(title_ui)

	var label = Label.new()
	label.text = boss_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.offset_left = -400
	label.offset_top = -50
	label.offset_right = 400
	label.offset_bottom = 50
	label.add_theme_font_size_override("font_size", 48)
	label.modulate = Color(1, 1, 1, 0)
	title_ui.add_child(label)

	# 타이틀 애니메이션
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	await tween.finished

	await get_tree().create_timer(2.0).timeout  # 2초 표시

	tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	await tween.finished

	title_ui.queue_free()

func _camera_return_to_player() -> void:
	if not camera or not player:
		return

	# 플레이어 위치로 카메라 복귀
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camera, "global_position", player.global_position, 0.8).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "zoom", Vector2(2.0, 2.0), 0.8).set_trans(Tween.TRANS_CUBIC)

	await tween.finished
