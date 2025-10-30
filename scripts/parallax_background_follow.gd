extends ParallaxBackground

## ParallaxBackground를 카메라가 따라가도록 함

var camera: Camera2D = null

func _ready():
	# 카메라 찾기
	await get_tree().process_frame
	camera = get_viewport().get_camera_2d()
	if camera:
		print("✓ ParallaxBackground: 카메라 감지됨")
	else:
		print("⚠ ParallaxBackground: 카메라를 찾을 수 없음")

func _process(_delta):
	if camera:
		# 카메라의 전역 위치를 scroll_offset으로 설정
		scroll_offset = camera.get_screen_center_position()
