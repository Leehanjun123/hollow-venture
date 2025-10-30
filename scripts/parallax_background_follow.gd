extends ParallaxBackground

## ParallaxBackground를 카메라가 따라가도록 함

var camera: Camera2D = null
var debug_counter = 0

func _ready():
	# scroll_offset을 0으로 초기화 (에디터 배치 기준)
	scroll_offset = Vector2.ZERO

	# 카메라 찾기
	await get_tree().process_frame
	camera = get_viewport().get_camera_2d()

	print("=== ParallaxBackground 디버깅 ===")
	print("ParallaxBackground visible: ", visible)
	print("ParallaxBackground scroll_offset (초기화 후): ", scroll_offset)
	print("자식 레이어 수: ", get_child_count())

	# 각 레이어 확인
	for i in range(get_child_count()):
		var layer = get_child(i)
		if layer is ParallaxLayer:
			print("  Layer %d: visible=%s, z_index=%d, motion_scale=%s, 자식 수=%d" % [i, layer.visible, layer.z_index, layer.motion_scale, layer.get_child_count()])

			# 레이어의 모든 스프라이트 확인
			for j in range(layer.get_child_count()):
				var sprite = layer.get_child(j)
				if sprite is Sprite2D:
					print("    Sprite %d: pos=%s, scale=%s, visible=%s, modulate=%s, texture=%s" % [
						j,
						sprite.position,
						sprite.scale,
						sprite.visible,
						sprite.modulate,
						"null" if sprite.texture == null else "loaded"
					])

	if camera:
		print("✓ 카메라 감지됨: ", camera.global_position)
	else:
		print("⚠ 카메라를 찾을 수 없음")
	print("===============================")

func _process(_delta):
	# ParallaxBackground는 자동으로 카메라를 따라감
	# scroll_offset을 수동으로 설정하면 안됨!
	pass
