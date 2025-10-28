extends CharacterBody2D
class_name CentipedeBoss

## 천족 지네 - 첫 번째 보스 (다리의 수호자)
## 레퍼런스: 할로우 나이트 노스크
## 패턴: 빠른 돌진, 땅속 잠수, 튀어오르기

# 스탯
var max_health: float = 200.0
var current_health: float = 200.0
var move_speed: float = 200.0
var damage: float = 25.0

# 중력
const GRAVITY = 1500.0

# 보스 상태
enum BossState { IDLE, DASH, BURROW, EMERGE, WALL_CLIMB, STUNNED }
var current_state: BossState = BossState.IDLE
var state_timer: float = 0.0

# Phase 관리
var is_phase_2: bool = false

# 패턴 쿨타임
var pattern_cooldown: float = 0.0
const PATTERN_COOLDOWN_TIME = 1.5

# 플레이어 레퍼런스
var player: Node2D = null

# 돌진 공격
var dash_direction: Vector2 = Vector2.ZERO
var dash_speed: float = 600.0
var dash_duration: float = 0.8
var dash_count: int = 0
const MAX_DASH_COUNT = 2  # 연속 돌진 횟수

# 땅속 잠수
var burrow_position: Vector2 = Vector2.ZERO
var burrow_duration: float = 1.5
var is_underground: bool = false

# 튀어오르기
var emerge_force: float = -700.0

# 레퍼런스
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null
@onready var hit_particles: CPUParticles2D = $HitParticles if has_node("HitParticles") else null

# 애니메이션 변수
var idle_bob_time: float = 0.0
var idle_bob_speed: float = 2.0
var idle_bob_amount: float = 5.0

# 대쉬 트레일 파티클
var dash_trail_timer: float = 0.0
const DASH_TRAIL_INTERVAL: float = 0.08

func _ready():
	# 주황색 보스 (임시)
	if sprite:
		sprite.modulate = Color(1.0, 0.5, 0.0)  # 주황색

	print("Boss spawned: Centipede of a Thousand Legs")

func _physics_process(delta: float):
	# 플레이어 찾기
	if not player:
		player = get_tree().get_first_node_in_group("player")

	# Phase 전환 체크
	if not is_phase_2 and current_health < max_health * 0.5:
		_enter_phase_2()

	# 상태 머신
	_update_state(delta)

	# 중력 (땅속이 아닐 때)
	if not is_underground and current_state != BossState.DASH:
		if not is_on_floor():
			velocity.y += GRAVITY * delta

	# 패턴 쿨타임
	if pattern_cooldown > 0:
		pattern_cooldown -= delta

	move_and_slide()

func _update_state(delta: float):
	state_timer += delta

	match current_state:
		BossState.IDLE:
			_state_idle(delta)

		BossState.DASH:
			_state_dash(delta)

		BossState.BURROW:
			_state_burrow(delta)

		BossState.EMERGE:
			_state_emerge(delta)

		BossState.STUNNED:
			_state_stunned(delta)

func _state_idle(delta: float):
	velocity.x = 0

	# Idle 애니메이션 (위아래로 천천히 흔들림)
	idle_bob_time += delta * idle_bob_speed
	if sprite:
		sprite.position.y = sin(idle_bob_time) * idle_bob_amount
		sprite.rotation_degrees = sin(idle_bob_time * 0.5) * 3.0  # 약간 회전

	# 패턴 선택 (쿨타임 끝나면)
	if pattern_cooldown <= 0 and player:
		_choose_pattern()

func _state_dash(delta: float):
	# 빠른 돌진 공격 (노스크 스타일)
	velocity = dash_direction * dash_speed

	# 대쉬 트레일 파티클
	_spawn_dash_trail(delta)

	# 지속시간 체크
	if state_timer > dash_duration:
		dash_count += 1

		# 연속 돌진 체크
		if dash_count < MAX_DASH_COUNT and player:
			# 다시 돌진 준비
			state_timer = 0
			dash_direction = (player.global_position - global_position).normalized()
			if sprite:
				sprite.flip_h = dash_direction.x < 0
			print("Centipede: Dash again!")
		else:
			# 돌진 종료
			current_state = BossState.IDLE
			state_timer = 0
			pattern_cooldown = PATTERN_COOLDOWN_TIME
			dash_count = 0
			velocity = Vector2.ZERO

func _state_burrow(_delta: float):
	# 땅속으로 잠수
	velocity = Vector2.ZERO

	if state_timer < 0.3:
		# 잠수 준비 (아래로 조금씩)
		velocity.y = 200
	elif state_timer < 0.5:
		# 완전히 땅속으로
		is_underground = true
		if sprite:
			sprite.modulate.a = 0.3  # 반투명
		if collision:
			collision.disabled = true

		# 플레이어 아래로 이동 (땅속)
		if player:
			burrow_position = player.global_position + Vector2(randf_range(-100, 100), 0)
	elif state_timer < burrow_duration:
		# 땅속 이동
		global_position = global_position.lerp(burrow_position, 0.1)
	else:
		# 튀어나오기
		current_state = BossState.EMERGE
		state_timer = 0

func _state_emerge(_delta: float):
	# 땅에서 튀어나오기

	if state_timer < 0.1:
		# 튀어오름 애니메이션
		velocity.y = emerge_force
		is_underground = false
		if sprite:
			sprite.modulate.a = 1.0  # 불투명
			sprite.rotation_degrees = 0  # 회전 리셋
			# 확대되며 등장
			var tween = create_tween()
			tween.tween_property(sprite, "scale", Vector2(0.28, 0.22), 0.2)  # 세로로 눌림
			tween.tween_property(sprite, "scale", Vector2(0.25, 0.25), 0.2)  # 원상복구
		if collision:
			collision.disabled = false
	elif is_on_floor() and state_timer > 0.3:
		# 착지
		current_state = BossState.STUNNED
		state_timer = 0
		velocity = Vector2.ZERO
		_create_shockwave()

func _state_stunned(_delta: float):
	# 짧은 경직 시간 (공격 가능)
	velocity.x = 0

	if state_timer > 0.8:
		current_state = BossState.IDLE
		state_timer = 0
		pattern_cooldown = PATTERN_COOLDOWN_TIME

func _choose_pattern():
	if not player:
		return

	# Phase 1: 돌진, 잠수
	# Phase 2: 더 빠르고 공격적

	var pattern = randi() % 2

	match pattern:
		0:  # 연속 돌진
			_start_dash()
		1:  # 땅속 잠수
			_start_burrow()

func _start_dash():
	current_state = BossState.DASH
	state_timer = 0
	dash_count = 0

	# 플레이어 방향 계산
	dash_direction = (player.global_position - global_position).normalized()

	# 스프라이트 방향 및 애니메이션
	if sprite:
		sprite.flip_h = dash_direction.x < 0
		sprite.position.y = 0  # Idle bob 리셋
		# 돌진 준비 애니메이션 (움츠리기)
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(0.22, 0.28), 0.1)
		tween.tween_property(sprite, "scale", Vector2(0.25, 0.25), 0.1)

	print("Centipede: Dash Attack!")

func _start_burrow():
	current_state = BossState.BURROW
	state_timer = 0

	# 잠수 애니메이션 (회전하며 사라짐)
	if sprite:
		sprite.position.y = 0  # Idle bob 리셋
		var tween = create_tween()
		tween.tween_property(sprite, "rotation_degrees", 360.0, 0.5)
		tween.parallel().tween_property(sprite, "scale", Vector2(0.15, 0.15), 0.5)

	print("Centipede: Burrowing underground!")

func _create_shockwave():
	# 튀어나올 때 충격파
	_spawn_shockwave_particles()

	if player and global_position.distance_to(player.global_position) < 150:
		if player.has_method("take_damage"):
			player.take_damage(damage)
			print("Centipede emerge hit player!")

func _enter_phase_2():
	is_phase_2 = true
	print("Centipede Phase 2!")

	# Phase 2 강화
	dash_speed *= 1.4
	move_speed *= 1.3
	burrow_duration *= 0.7  # 더 빠르게

	# 색상 변화
	if sprite:
		sprite.modulate = Color(1.0, 0.3, 0.0)  # 더 진한 주황색

# 피해 받음
func take_damage(amount: float):
	current_health -= amount
	current_health = max(0, current_health)  # 0 이하로 내려가지 않게
	print("Centipede hit! Health: %.1f/%.1f" % [current_health, max_health])

	# 피격 효과
	_flash_damage()

	if current_health <= 0:
		_die()

func is_dead() -> bool:
	return current_health <= 0

func _die():
	print("Centipede defeated! 다리의 파편 획득...")

	# 죽음 애니메이션 (회전하며 사라짐)
	if sprite and hit_particles:
		hit_particles.amount = 50  # 더 많은 파티클
		hit_particles.emitting = true

		var tween = create_tween()
		tween.tween_property(sprite, "rotation_degrees", 720.0, 1.0)  # 2바퀴 회전
		tween.parallel().tween_property(sprite, "scale", Vector2(0, 0), 1.0)  # 축소
		tween.parallel().tween_property(sprite, "modulate:a", 0.0, 1.0)  # 페이드 아웃

	# 능력 아이템 드롭
	_drop_ability_item()

	# 애니메이션 후 삭제
	await get_tree().create_timer(1.1).timeout
	queue_free()

func _drop_ability_item():
	# 능력 아이템 생성
	var ability_item_scene = load("res://scenes/items/ability_item.tscn")
	if not ability_item_scene:
		print("ERROR: Could not load ability item scene!")
		return

	var item = ability_item_scene.instantiate()
	item.ability_type = 0  # DASH
	item.ability_name = "다리의 파편"
	item.global_position = global_position

	# Main 노드에 추가 (get_parent()가 Enemies 노드이므로)
	var main_node = get_tree().current_scene
	if main_node:
		main_node.add_child(item)
		print("Dropped ability item at position: %v" % item.global_position)
	else:
		print("ERROR: Could not find main scene!")

func _flash_damage():
	# 흰색으로 깜빡임 + 파티클
	if sprite:
		sprite.modulate = Color.WHITE
		# 피격 파티클 발생
		if hit_particles:
			hit_particles.emitting = true
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			if is_phase_2:
				sprite.modulate = Color(1.0, 0.3, 0.0)
			else:
				sprite.modulate = Color(1.0, 0.5, 0.0)


# === 파티클 효과 ===
func _spawn_dash_trail(delta: float):
	# 대쉬 중 트레일 파티클 생성
	dash_trail_timer -= delta
	if dash_trail_timer <= 0:
		dash_trail_timer = DASH_TRAIL_INTERVAL

		# 트레일 파티클 생성
		var trail_particle = CPUParticles2D.new()
		get_parent().add_child(trail_particle)

		trail_particle.global_position = global_position
		trail_particle.emitting = true
		trail_particle.one_shot = true
		trail_particle.amount = 12
		trail_particle.lifetime = 0.4
		trail_particle.explosiveness = 1.0

		# 파티클 색상 (Phase별)
		if is_phase_2:
			trail_particle.color = Color(1.0, 0.3, 0.0, 0.8)  # 진한 주황
		else:
			trail_particle.color = Color(1.0, 0.5, 0.0, 0.6)  # 주황

		# 파티클 설정
		trail_particle.direction = Vector2(0, 0)
		trail_particle.spread = 180.0
		trail_particle.gravity = Vector2(0, 200)
		trail_particle.initial_velocity_min = 50.0
		trail_particle.initial_velocity_max = 150.0
		trail_particle.scale_amount_min = 4.0
		trail_particle.scale_amount_max = 8.0

		# 자동 삭제
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(trail_particle):
			trail_particle.queue_free()


func _spawn_shockwave_particles():
	# 충격파 파티클 효과
	var shockwave = CPUParticles2D.new()
	get_parent().add_child(shockwave)

	shockwave.global_position = global_position + Vector2(0, 20)
	shockwave.emitting = true
	shockwave.one_shot = true
	shockwave.amount = 40
	shockwave.lifetime = 0.6
	shockwave.explosiveness = 1.0

	# 충격파 색상 (흙먼지 + 주황 에너지)
	shockwave.color = Color(0.6, 0.4, 0.2, 0.8)  # 갈색 먼지

	# 원형으로 퍼져나가는 효과
	shockwave.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	shockwave.emission_sphere_radius = 10.0
	shockwave.direction = Vector2(0, -1)
	shockwave.spread = 180.0
	shockwave.gravity = Vector2(0, 300)
	shockwave.initial_velocity_min = 200.0
	shockwave.initial_velocity_max = 400.0
	shockwave.scale_amount_min = 6.0
	shockwave.scale_amount_max = 12.0
	shockwave.angular_velocity_min = -180.0
	shockwave.angular_velocity_max = 180.0

	# 카메라 흔들림 (플레이어에게서)
	if player and player.has_method("_shake_camera"):
		player._shake_camera(6.0, 0.2)

	# 자동 삭제
	await get_tree().create_timer(0.7).timeout
	if is_instance_valid(shockwave):
		shockwave.queue_free()
