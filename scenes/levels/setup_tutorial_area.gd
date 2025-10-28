extends Node2D

## 튜토리얼 지역 설정
## 플레이어 스폰: (-24, -31)

func _ready():
	print("=== 튜토리얼 지역 초기화 ===")

	# 튜토리얼 지역 좌표 (타일 좌표)
	var tutorial_spawn = Vector2(-24, -31)

	# 타일 좌표를 픽셀 좌표로 변환 (32픽셀 타일 기준)
	var spawn_position = tutorial_spawn * 32

	# Scene에 이미 있는 Player 노드 찾기
	var player = get_node_or_null("Gameplay_Container/Player")

	if player:
		# 플레이어 위치 설정
		player.position = spawn_position
		print("✓ 플레이어 위치 설정: 타일 %s, 픽셀 %s" % [tutorial_spawn, spawn_position])

		# 카메라가 플레이어의 자식 노드로 있는지 확인
		var camera = player.get_node_or_null("Camera2D2")
		if camera:
			camera.reset_smoothing()
			print("✓ 카메라 스무딩 리셋")
	else:
		print("⚠ Player 노드를 찾을 수 없습니다")

	print("=== 튜토리얼 지역 준비 완료 ===")
