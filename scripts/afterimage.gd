extends Sprite2D
class_name Afterimage

## 대시 잔상 효과
## 플레이어가 대시할 때 남기는 페이드 아웃 잔상

var fade_speed: float = 4.0
var lifetime: float = 0.3

func _ready():
	# 초기 알파값 설정
	modulate.a = 0.6

	# 자동 삭제 타이머
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)

func _process(delta: float):
	# 페이드 아웃
	modulate.a -= fade_speed * delta

	if modulate.a <= 0:
		queue_free()


## 정적 함수: 잔상 생성 헬퍼
static func create(parent: Node, sprite_texture: Texture2D, pos: Vector2, sprite_scale: Vector2, flip: bool, is_evil_mode: bool) -> Afterimage:
	var afterimage = Afterimage.new()
	parent.add_child(afterimage)

	afterimage.texture = sprite_texture
	afterimage.global_position = pos
	afterimage.scale = sprite_scale
	afterimage.flip_h = flip

	# 모드별 색상
	if is_evil_mode:
		afterimage.modulate = Color(1.0, 0.3, 0.3, 0.6)  # 붉은색
	else:
		afterimage.modulate = Color(0.3, 0.6, 1.0, 0.6)  # 푸른색

	return afterimage
