extends CharacterBody2D
class_name PlainsMantis

## 평원 사마귀 - 중간 보스 (평원 지역)
## 레퍼런스: 할로우 나이트 Mantis Lords
## 패턴: 3연속 베기, 점프 내려찍기, 대쉬 슬래시

# 스탯
var max_health: float = 100.0
var current_health: float = 100.0
var move_speed: float = 180.0
var damage: float = 20.0

# 중력
const GRAVITY = 1500.0

# 적 상태
enum BossState { IDLE, PATROL, TRIPLE_SLASH, JUMP_STRIKE, DASH_SLASH, STUNNED }
var current_state: BossState = BossState.PATROL
var state_timer: float = 0.0

# 이동
var direction: int = 1  # 1 = 오른쪽, -1 = 왼쪽

# 플레이어 감지
var player: Node2D = null
var detection_range: float = 350.0
var attack_range: float = 200.0

# 3연속 베기
var slash_count: int = 0
const MAX_SLASH_COUNT = 3
var slash_interval: float = 0.3
var slash_range: float = 80.0

# 점프 내려찍기
var jump_force: float = -600.0
var is_jumping: bool = false
var plunge_speed: float = 800.0

# 대쉬 슬래시
var dash_speed: float = 500.0
var dash_duration: float = 0.4

# 패턴 쿨타임
var pattern_cooldown: float = 0.0
const PATTERN_COOLDOWN_TIME = 1.5

# 공격 히트박스
var attack_active: bool = false
var hit_targets: Array = []

# 레퍼런스
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var attack_area: Area2D = $AttackArea if has_node("AttackArea") else null

func _ready():
	# 녹색 사마귀 (우아한 전사)
	if sprite:
		sprite.modulate = Color(0.2, 0.8, 0.3)  # 선명한 녹색

	# 공격 영역 설정
	if not attack_area:
		_create_attack_area()

	print("Plains Mantis spawned (Mid-boss)")

func _create_attack_area():
	# 공격 판정 영역 생성
	attack_area = Area2D.new()
	attack_area.name = "AttackArea"
	attack_area.collision_layer = 0
	attack_area.collision_mask = 1  # 플레이어만
	add_child(attack_area)

	var attack_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(slash_range, 60)
	attack_shape.shape = rect_shape
	attack_shape.position = Vector2(slash_range / 2, 0)  # 앞쪽
	attack_area.add_child(attack_shape)

	attack_area.body_entered.connect(_on_attack_hit)

func _physics_process(delta: float):
	# 플레이어 찾기
	if not player:
		player = get_tree().get_first_node_in_group("player")

	# 상태 머신
	_update_state(delta)

	# 중력 (점프/대쉬 중이 아닐 때)
	if current_state != BossState.DASH_SLASH and current_state != BossState.JUMP_STRIKE:
		if not is_on_floor():
			velocity.y += GRAVITY * delta
	elif current_state == BossState.JUMP_STRIKE and is_jumping:
		# 내려찍기 중에는 빠른 낙하
		velocity.y = plunge_speed

	# 패턴 쿨타임
	if pattern_cooldown > 0:
		pattern_cooldown -= delta

	move_and_slide()

func _update_state(delta: float):
	state_timer += delta

	match current_state:
		BossState.IDLE:
			_state_idle(delta)

		BossState.PATROL:
			_state_patrol(delta)

		BossState.TRIPLE_SLASH:
			_state_triple_slash(delta)

		BossState.JUMP_STRIKE:
			_state_jump_strike(delta)

		BossState.DASH_SLASH:
			_state_dash_slash(delta)

		BossState.STUNNED:
			_state_stunned(delta)

func _state_idle(_delta: float):
	velocity.x = 0

	# 패턴 선택
	if pattern_cooldown <= 0 and player:
		_choose_attack_pattern()

func _state_patrol(_delta: float):
	# 우아하게 순찰
	velocity.x = direction * move_speed

	# 스프라이트 방향
	if sprite:
		sprite.flip_h = direction < 0

	# 벽 감지
	if is_on_wall():
		direction *= -1

	# 플레이어 감지
	if player and pattern_cooldown <= 0:
		var distance = global_position.distance_to(player.global_position)
		if distance < attack_range:
			_choose_attack_pattern()

func _state_triple_slash(_delta: float):
	# 3연속 베기
	velocity.x = 0

	# 각 베기마다 간격
	if state_timer > slash_interval * (slash_count + 1):
		_execute_slash()
		slash_count += 1

		if slash_count >= MAX_SLASH_COUNT:
			current_state = BossState.IDLE
			state_timer = 0
			slash_count = 0
			pattern_cooldown = PATTERN_COOLDOWN_TIME

func _state_jump_strike(_delta: float):
	# 점프 내려찍기
	if not is_jumping:
		# 점프 시작
		if is_on_floor():
			velocity.y = jump_force
			# 플레이어 방향으로 약간 이동
			if player:
				var dir_x = sign(player.global_position.x - global_position.x)
				velocity.x = dir_x * move_speed
			is_jumping = true
	else:
		# 최고점 도달 후 내려찍기
		if velocity.y > 0:
			velocity.y = plunge_speed
			velocity.x = 0

		# 착지
		if is_on_floor() and state_timer > 0.3:
			_execute_ground_slam()
			current_state = BossState.IDLE
			state_timer = 0
			is_jumping = false
			pattern_cooldown = PATTERN_COOLDOWN_TIME

func _state_dash_slash(_delta: float):
	# 빠른 대쉬 베기
	velocity.x = direction * dash_speed
	velocity.y = 0  # 공중 고정

	# 대쉬 중 공격 판정 활성화
	attack_active = true

	# 지속시간
	if state_timer > dash_duration:
		attack_active = false
		hit_targets.clear()
		current_state = BossState.IDLE
		state_timer = 0
		pattern_cooldown = PATTERN_COOLDOWN_TIME

func _state_stunned(_delta: float):
	velocity.x = 0

	if state_timer > 0.8:
		current_state = BossState.PATROL
		state_timer = 0

func _choose_attack_pattern():
	if not player:
		return

	var distance = global_position.distance_to(player.global_position)

	# 플레이어 방향 설정
	direction = 1 if player.global_position.x > global_position.x else -1
	if sprite:
		sprite.flip_h = direction < 0

	# 거리에 따른 패턴 선택
	if distance < 100:
		# 가까우면 3연속 베기
		_start_triple_slash()
	elif distance < 200:
		# 중거리면 점프 내려찍기 or 대쉬 슬래시
		if randf() < 0.6:
			_start_jump_strike()
		else:
			_start_dash_slash()
	else:
		# 멀면 대쉬 슬래시
		_start_dash_slash()

func _start_triple_slash():
	current_state = BossState.TRIPLE_SLASH
	state_timer = 0
	slash_count = 0
	print("Plains Mantis: Triple Slash!")

func _start_jump_strike():
	if not is_on_floor():
		return

	current_state = BossState.JUMP_STRIKE
	state_timer = 0
	is_jumping = false
	print("Plains Mantis: Jump Strike!")

func _start_dash_slash():
	current_state = BossState.DASH_SLASH
	state_timer = 0
	hit_targets.clear()
	print("Plains Mantis: Dash Slash!")

func _execute_slash():
	# 베기 공격 실행
	print("Slash #%d!" % (slash_count + 1))

	# 플레이어 히트 체크
	if player and attack_area:
		var bodies = attack_area.get_overlapping_bodies()
		for body in bodies:
			if body == player and body.has_method("take_damage"):
				body.take_damage(damage)
				print("Mantis slash hit player!")

func _execute_ground_slam():
	# 착지 충격파
	print("Ground Slam!")

	if not player:
		return

	var distance = global_position.distance_to(player.global_position)
	if distance < 120 and player.has_method("take_damage"):
		player.take_damage(damage * 1.5)  # 강한 데미지
		print("Ground slam hit player!")

func _on_attack_hit(body: Node2D):
	# 대쉬 슬래시 중 충돌
	if current_state == BossState.DASH_SLASH and attack_active:
		if body == player and not body in hit_targets:
			if body.has_method("take_damage"):
				body.take_damage(damage)
				hit_targets.append(body)
				print("Dash slash hit player!")

# 피해 받음
func take_damage(amount: float):
	current_health -= amount
	current_health = max(0, current_health)  # 0 이하로 내려가지 않게
	print("Plains Mantis hit! Health: %.1f/%.1f" % [current_health, max_health])

	# 피격 효과
	_flash_damage()

	# 공격 중에는 기절하지 않음 (우아함)
	if current_state == BossState.PATROL:
		if randf() < 0.3:  # 30% 확률로만 기절
			current_state = BossState.STUNNED
			state_timer = 0

	if current_health <= 0:
		_die()

func is_dead() -> bool:
	return current_health <= 0

func _die():
	print("Plains Mantis defeated!")

	# 짧은 딜레이 후 삭제 (사망 처리 보장)
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _flash_damage():
	# 흰색으로 깜빡임
	if sprite:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			sprite.modulate = Color(0.2, 0.8, 0.3)  # 녹색 복구
