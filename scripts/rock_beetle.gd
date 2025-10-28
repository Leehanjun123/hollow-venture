extends CharacterBody2D
class_name RockBeetle

## 바위 딱정벌레 - 탱크형 적 (평원 지역)
## 레퍼런스: 할로우 나이트 Baldur (딱정벌레)
## 패턴: 느린 이동, 돌진 공격, 높은 방어력

# 스탯
var max_health: float = 40.0
var current_health: float = 40.0
var move_speed: float = 50.0  # 느림
var damage: float = 15.0

# 중력
const GRAVITY = 1500.0

# 적 상태
enum EnemyState { IDLE, PATROL, CHARGE_PREPARE, CHARGING, STUNNED }
var current_state: EnemyState = EnemyState.PATROL
var state_timer: float = 0.0

# 이동
var direction: int = 1  # 1 = 오른쪽, -1 = 왼쪽
const EDGE_DETECTION_DISTANCE = 50.0

# 플레이어 감지
var player: Node2D = null
var detection_range: float = 250.0
var charge_range: float = 200.0

# 돌진 공격
var charge_speed: float = 350.0
var charge_duration: float = 1.2
var charge_direction: int = 1
var charge_prepare_time: float = 0.6  # 돌진 준비 시간

# 쿨타임
var charge_cooldown: float = 0.0
const CHARGE_COOLDOWN_TIME = 3.0

# 레퍼런스
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	# 빨간색으로 변경 (디버그용 - 눈에 잘 띄게)
	if sprite:
		sprite.modulate = Color(1.5, 0.3, 0.3)  # 밝은 빨간색

	print("Rock Beetle spawned at %s" % global_position)

func _physics_process(delta: float):
	# 플레이어 찾기
	if not player:
		player = get_tree().get_first_node_in_group("player")

	# 상태 머신
	_update_state(delta)

	# 중력 (돌진 중이 아닐 때)
	if current_state != EnemyState.CHARGING:
		if not is_on_floor():
			velocity.y += GRAVITY * delta

	# 쿨타임
	if charge_cooldown > 0:
		charge_cooldown -= delta

	move_and_slide()

func _update_state(delta: float):
	state_timer += delta

	match current_state:
		EnemyState.IDLE:
			_state_idle(delta)

		EnemyState.PATROL:
			_state_patrol(delta)

		EnemyState.CHARGE_PREPARE:
			_state_charge_prepare(delta)

		EnemyState.CHARGING:
			_state_charging(delta)

		EnemyState.STUNNED:
			_state_stunned(delta)

func _state_idle(_delta: float):
	velocity.x = 0

	# 플레이어 감지
	if player and charge_cooldown <= 0:
		var distance = global_position.distance_to(player.global_position)
		if distance < charge_range:
			_prepare_charge()

func _state_patrol(_delta: float):
	# 느리게 순찰
	velocity.x = direction * move_speed

	# 스프라이트 방향
	if sprite:
		sprite.flip_h = direction < 0

	# 벽 감지
	if is_on_wall():
		direction *= -1

	# 절벽 감지
	if is_on_floor() and not _check_floor_ahead():
		direction *= -1

	# 플레이어 감지
	if player and charge_cooldown <= 0:
		var distance = global_position.distance_to(player.global_position)
		if distance < charge_range:
			_prepare_charge()

func _state_charge_prepare(_delta: float):
	# 돌진 준비 (멈춤, 색상 변화)
	velocity.x = 0

	# 준비 완료
	if state_timer > charge_prepare_time:
		_start_charge()

func _state_charging(_delta: float):
	# 빠른 돌진
	velocity.x = charge_direction * charge_speed

	# 벽에 부딪히면 기절
	if is_on_wall():
		_stun()
		return

	# 지속시간 종료
	if state_timer > charge_duration:
		current_state = EnemyState.IDLE
		state_timer = 0
		charge_cooldown = CHARGE_COOLDOWN_TIME
		velocity.x = 0

func _state_stunned(_delta: float):
	# 기절 (공격 가능)
	velocity.x = 0

	if state_timer > 1.5:
		current_state = EnemyState.PATROL
		state_timer = 0

		# 방향 반대로
		direction *= -1

func _prepare_charge():
	if not player:
		return

	current_state = EnemyState.CHARGE_PREPARE
	state_timer = 0

	# 플레이어 방향으로
	charge_direction = 1 if player.global_position.x > global_position.x else -1

	if sprite:
		sprite.flip_h = charge_direction < 0

	print("Rock Beetle preparing charge!")

func _start_charge():
	current_state = EnemyState.CHARGING
	state_timer = 0

	print("Rock Beetle charging!")

func _stun():
	current_state = EnemyState.STUNNED
	state_timer = 0
	velocity.x = 0

	print("Rock Beetle stunned by wall!")

func _check_floor_ahead() -> bool:
	# 앞쪽에 바닥이 있는지 체크
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2(direction * EDGE_DETECTION_DISTANCE, EDGE_DETECTION_DISTANCE)
	)
	query.collision_mask = 4  # 환경(바닥) 레이어

	var result = space_state.intersect_ray(query)
	return result.size() > 0

# 피해 받음
func take_damage(amount: float):
	current_health -= amount
	current_health = max(0, current_health)  # 0 이하로 내려가지 않게
	print("Rock Beetle hit! Health: %.1f/%.1f" % [current_health, max_health])

	# 피격 효과
	_flash_damage()

	# 돌진 중에 맞으면 기절
	if current_state == EnemyState.CHARGING:
		_stun()

	if current_health <= 0:
		_die()

func is_dead() -> bool:
	return current_health <= 0

func _die():
	print("Rock Beetle defeated!")
	# TODO: 드랍 아이템, 사망 애니메이션
	queue_free()

func _flash_damage():
	# 흰색으로 깜빡임
	if sprite:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			sprite.modulate = Color(0.6, 0.4, 0.2)  # 갈색으로 복구
