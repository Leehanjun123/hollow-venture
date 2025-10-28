extends Node2D

## 튜토리얼 지역 설정
## 플레이어 스폰: (-842.0, -1452.0)

func _ready():
	print("=== 튜토리얼 지역 초기화 ===")

	# 튜토리얼 지역 좌표에 플레이어 스폰
	var tutorial_spawn = Vector2(-842.0, -1452.0)

	# PlayerSpawner 사용하여 플레이어 스폰
	if PlayerSpawner:
		PlayerSpawner.spawn_player(tutorial_spawn, self)
		print("✓ 플레이어 스폰: %s" % tutorial_spawn)
	else:
		print("⚠ PlayerSpawner를 찾을 수 없습니다")

	print("=== 튜토리얼 지역 준비 완료 ===")
