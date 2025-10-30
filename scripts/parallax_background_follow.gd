extends ParallaxBackground

## ParallaxBackground를 카메라가 따라가도록 함

var camera: Camera2D = null
var debug_counter = 0

func _ready():
	# 카메라 찾기
	await get_tree().process_frame
	camera = get_viewport().get_camera_2d()

	print("=== ParallaxBackground 디버깅 ===")
	print("ParallaxBackground visible: ", visible)
	print("ParallaxBackground scroll_offset: ", scroll_offset)
	print("자식 레이어 수: ", get_child_count())

	# 각 레이어 확인
	for i in range(get_child_count()):
		var layer = get_child(i)
		if layer is ParallaxLayer:
			print("  Layer %d: visible=%s, z_index=%d, 자식 수=%d" % [i, layer.visible, layer.z_index, layer.get_child_count()])

	if camera:
		print("✓ 카메라 감지됨: ", camera.global_position)
	else:
		print("⚠ 카메라를 찾을 수 없음")
	print("===============================")

func _process(_delta):
	if camera:
		# 카메라의 전역 위치를 scroll_offset으로 설정
		scroll_offset = camera.get_screen_center_position()

		# 5초마다 한 번씩 디버그 정보 출력
		debug_counter += 1
		if debug_counter % 300 == 0:  # 60fps 기준 5초
			print("[ParallaxBackground] scroll_offset: ", scroll_offset, " camera pos: ", camera.global_position)
