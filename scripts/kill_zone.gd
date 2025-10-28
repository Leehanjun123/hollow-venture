extends Area2D

## KillZone - 맵 경계 밖으로 떨어진 플레이어/적 리스폰

@export var respawn_position: Vector2 = Vector2(200, -50)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		print("플레이어가 맵 밖으로 떨어짐 - 리스폰")
		# 플레이어 위치 리셋
		body.global_position = respawn_position
		body.velocity = Vector2.ZERO

		# 데미지 (선택적)
		if body.has_method("take_damage"):
			body.take_damage(10.0)

	elif body.has_method("queue_free"):
		# 적은 그냥 삭제
		body.queue_free()
