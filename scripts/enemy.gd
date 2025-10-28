extends CharacterBody2D
class_name Enemy

## 기본 적 클래스

# 스탯
var max_health: float = 50.0
var current_health: float = 50.0
var move_speed: float = 50.0
var damage: float = 10.0

# 이동 패턴
var direction: int = 1  # 1 = 오른쪽, -1 = 왼쪽
var patrol_distance: float = 100.0
var start_position: Vector2

# 레퍼런스
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

func _ready():
	start_position = global_position
	# 빨간색 사각형 (임시)
	if sprite:
		sprite.modulate = Color(1, 0.3, 0.3)

func _physics_process(delta: float):
	# 간단한 좌우 순찰
	velocity.x = direction * move_speed

	# 순찰 범위 체크
	var distance_from_start = global_position.x - start_position.x
	if abs(distance_from_start) > patrol_distance:
		direction *= -1
		if sprite:
			sprite.flip_h = direction < 0

	# 중력
	velocity.y += 980 * delta

	move_and_slide()

# 플레이어 공격으로 피해 받음
func take_damage(amount: float):
	current_health -= amount
	current_health = max(0, current_health)  # 0 이하로 내려가지 않게
	print("Enemy hit! Health: %.1f/%.1f" % [current_health, max_health])

	# 피격 효과 (깜빡임)
	_flash_damage()

	if current_health <= 0:
		_die()

func is_dead() -> bool:
	return current_health <= 0

func _die():
	print("Enemy defeated!")
	queue_free()

func _flash_damage():
	# 흰색으로 깜빡임
	if sprite:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			sprite.modulate = Color(1, 0.3, 0.3)
