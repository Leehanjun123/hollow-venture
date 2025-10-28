extends CharacterBody2D
class_name FlyingEnemy

## 날아다니는 적 - 사인파 움직임

# 스탯
var max_health: float = 30.0
var current_health: float = 30.0
var move_speed: float = 80.0
var damage: float = 15.0

# 비행 패턴
var start_position: Vector2
var time_passed: float = 0.0
var wave_amplitude: float = 50.0  # 사인파 진폭
var wave_frequency: float = 2.0   # 사인파 주파수
var direction: int = 1  # 1 = 오른쪽, -1 = 왼쪽

# 플레이어 추적
var player: Node2D = null
var detection_range: float = 200.0
var chase_speed: float = 120.0

# 레퍼런스
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

func _ready():
	start_position = global_position
	# 파란색으로 표시 (임시)
	if sprite:
		sprite.modulate = Color(0.3, 0.5, 1.0)

func _physics_process(delta: float):
	time_passed += delta

	# 플레이어 찾기
	if not player:
		player = get_tree().get_first_node_in_group("player")

	# 플레이어 추적 or 사인파 비행
	if player and global_position.distance_to(player.global_position) < detection_range:
		_chase_player(delta)
	else:
		_fly_pattern(delta)

	move_and_slide()

func _fly_pattern(_delta: float):
	# 사인파 비행 패턴
	velocity.x = direction * move_speed

	# 사인파로 위아래 움직임
	var target_y = start_position.y + sin(time_passed * wave_frequency) * wave_amplitude
	var current_y = global_position.y
	velocity.y = (target_y - current_y) * 2.0  # 부드러운 이동

	# 화면 경계 체크 (좌우 반전)
	if abs(global_position.x - start_position.x) > 150:
		direction *= -1
		if sprite:
			sprite.flip_h = direction < 0

func _chase_player(_delta: float):
	# 플레이어를 향해 이동
	var direction_to_player = (player.global_position - global_position).normalized()
	velocity = direction_to_player * chase_speed

	# 스프라이트 방향
	if sprite:
		sprite.flip_h = direction_to_player.x < 0

# 피해 받음
func take_damage(amount: float):
	current_health -= amount
	current_health = max(0, current_health)  # 0 이하로 내려가지 않게
	print("Flying Enemy hit! Health: %.1f/%.1f" % [current_health, max_health])

	# 피격 효과
	_flash_damage()

	if current_health <= 0:
		_die()

func is_dead() -> bool:
	return current_health <= 0

func _die():
	print("Flying Enemy defeated!")
	queue_free()

func _flash_damage():
	# 흰색으로 깜빡임
	if sprite:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			sprite.modulate = Color(0.3, 0.5, 1.0)
