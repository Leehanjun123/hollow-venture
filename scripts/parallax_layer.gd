extends Sprite2D
class_name ParallaxLayer2D

## 할로우나이트 스타일 패럴랙스 레이어
## depth 값으로 깊이 제어: 0.0 = 고정, 1.0 = 카메라와 완전 동일

@export var depth: float = 0.5  # 깊이 계수 (0.0 ~ 1.0)
@export var use_parallax: bool = true  # 패럴랙스 효과 사용 여부

var camera: Camera2D
var initial_position: Vector2
var screen_center: Vector2

func _ready():
	# 게임 화면 중앙
	screen_center = Vector2(960, 540)
	initial_position = global_position

	# 카메라 찾기 (플레이어의 자식 카메라)
	await get_tree().process_frame
	_find_camera()

func _find_camera():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		camera = player.get_node_or_null("Camera2D")

func _process(_delta):
	if not use_parallax or not camera:
		return

	# 카메라의 화면 중앙으로부터의 오프셋 계산
	var camera_offset = camera.global_position - screen_center

	# depth 값에 따라 배경 위치 조정
	# depth가 작을수록 느리게 움직임 (멀리 있는 것처럼)
	global_position = initial_position + (camera_offset * depth)
