extends Node2D

## 튜토리얼 지역 설정
## 플레이어 스폰: (-24, -31)

func _ready():
	print("=== 튜토리얼 지역 초기화 ===")

	# 튜토리얼 지역 좌표 (타일 좌표)
	var tutorial_spawn = Vector2(-24, -31)

	# 타일 좌표를 픽셀 좌표로 변환 (32픽셀 타일 기준)
	var spawn_position = tutorial_spawn * 32

	# PlayerSpawner 사용하여 플레이어 스폰
	if PlayerSpawner:
		PlayerSpawner.spawn_player(spawn_position, self)
		print("✓ 플레이어 스폰: 타일 %s, 픽셀 %s" % [tutorial_spawn, spawn_position])

		# 플레이어가 스폰된 후 카메라 위치 설정
		await get_tree().process_frame
		var player = PlayerSpawner.get_player()
		if player:
			# 카메라 찾기
			var camera = get_viewport().get_camera_2d()
			if camera:
				camera.position = spawn_position
				camera.reset_smoothing()
				print("✓ 카메라 위치 설정: %s" % spawn_position)
	else:
		print("⚠ PlayerSpawner를 찾을 수 없습니다")

	print("=== 튜토리얼 지역 준비 완료 ===")
