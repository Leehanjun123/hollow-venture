extends CharacterBody2D
class_name Player

## 플레이어 캐릭터 컨트롤러
## 할로우 나이트 시스템 (Nail 업그레이드)

# === 할로우 나이트 Nail 스탯 (정확한 수치) ===

# Nail 데미지 (할로우 나이트와 정확히 동일)
const OLD_NAIL_DAMAGE = 5        # Lv1 (시작) - 인간 모드 외형
const SHARPENED_NAIL_DAMAGE = 9  # Lv2
const CHANNELLED_NAIL_DAMAGE = 13  # Lv3
const COILED_NAIL_DAMAGE = 17    # Lv4
const PURE_NAIL_DAMAGE = 21      # Lv5 (최종) - 악신 모드 외형

# 공격 속도 (할로우 나이트와 정확히 동일)
const ATTACK_COOLDOWN = 0.41  # 0.41초 쿨다운
const ATTACK_DURATION = 0.35  # 0.35초 지속

# 체력 (할로우 나이트와 정확히 동일)
const STARTING_MASKS = 5  # 시작 마스크
const MAX_MASKS = 9       # 최대 마스크

# === 공통 물리 (할로우 나이트와 정확히 동일) ===
const WALK_SPEED = 300.0      # 8.3 Unity units ≈ 300px/s
const JUMP_VELOCITY = -750.0  # 할로우 나이트 점프
const GRAVITY = 1500.0
const AIR_CONTROL = 1.0       # 할로우 나이트: 공중 완전 제어 (0.8 → 1.0)

# === 현재 상태 (할로우 나이트 시스템) ===
var current_masks: int = 5        # 현재 마스크 (체력)
var max_masks: int = 5            # 최대 마스크
var current_soul: float = 0.0     # Soul (할로우 나이트와 동일)
var max_soul: float = 99.0        # 99 (할로우 나이트와 정확히 동일)
var nail_level: int = 1           # 1=Old, 2=Sharpened, 3=Channelled, 4=Coiled, 5=Pure
var is_attacking: bool = false
var can_attack: bool = true
var attack_timer: float = 0.0

# === Safety Timeout (상태가 영원히 안 풀리는 것 방지) ===
var attack_safety_timer: float = 0.0
const MAX_ATTACK_DURATION = 0.5  # 공격은 최대 0.5초
var dash_safety_timer: float = 0.0
const MAX_DASH_DURATION = 0.5  # 대쉬 안전장치 (0.4초 애니메이션 + 여유)

# 점프
var can_double_jump: bool = false
var has_double_jumped: bool = false
var platform_drop_timer: float = 0.0
const PLATFORM_DROP_DURATION = 0.2

# 할로우 나이트: 콤보 시스템 제거 (없음)
# 할로우 나이트: Rage 모드 제거 (없음)

# 대시 (Mothwing Cloak - 할로우 나이트)
var can_dash: bool = true
var is_dashing: bool = false
const DASH_SPEED = 750.0       # 할로우 나이트 대쉬 속도 (원본: 720 px/s)
const DASH_DURATION = 0.4      # 애니메이션 재생 시간 (36프레임, 90 FPS)
const DASH_COOLDOWN = 0.6      # 할로우 나이트 쿨다운
var dash_cooldown_timer: float = 0.0
var dash_direction: float = 0.0  # 대쉬 방향 (1 or -1)

# 능력 해금 (보스 처치 보상)
var has_dash_ability: bool = false  # 다리의 파편 - 대쉬
var has_wall_jump: bool = false     # 팔의 파편 - 벽 점프
var has_swim: bool = false          # 폐의 파편 - 수영
# ... 나머지 능력들

# 패링
var parry_window: bool = false
var parry_timer: float = 0.0
const PARRY_WINDOW_DURATION = 0.3

# 잔상 효과
var afterimage_spawn_timer: float = 0.0
const AFTERIMAGE_SPAWN_INTERVAL: float = 0.05  # 0.05초마다 잔상 생성

# === 애니메이션 상태 ===
enum AnimState { IDLE, WALK, JUMP, FALL, ATTACK, DASH, HURT }
var current_anim_state: AnimState = AnimState.IDLE

# === 방향 ===
var facing_right: bool = true

# === 레퍼런스 ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var attack_area: Area2D = $AttackArea if has_node("AttackArea") else null
@onready var attack_hitbox: CollisionShape2D = $AttackArea/AttackHitbox if has_node("AttackArea/AttackHitbox") else null
@onready var camera: Camera2D = $Camera2D if has_node("Camera2D") else null
@onready var hit_particles: CPUParticles2D = $HitParticles if has_node("HitParticles") else null
@onready var sword_trail: Line2D = $SwordTrail if has_node("SwordTrail") else null

# 애니메이션 관련
var idle_tween: Tween
var original_y_position: float = 0.0

# 공격 판정
var hit_enemies: Array = []  # 이번 공격에서 이미 맞은 적들

# 타격감 (Juiciness)
var hitstop_active: bool = false
const HITSTOP_DURATION = 0.08  # 히트스톱 지속시간 (초)

# 움직임 제어 (컷씬용)
var can_move: bool = true

# 무한 낙하 방지
var last_safe_position: Vector2 = Vector2.ZERO
const FALL_DEATH_Y = 150  # 이 높이 이상 떨어지면 리스폰 (타일 기준)
var respawn_timer: float = 0.0


func _ready():
	# GameManager 시그널 연결
	GameManager.mode_switched.connect(_on_mode_switched)

	# 애니메이션 완료 시그널 연결
	if animated_sprite:
		animated_sprite.animation_finished.connect(_on_animation_finished)

	# 닷지 애니메이션 동적 로드 (배경제거 후 파일명이 바뀌어도 동작)
	_load_dash_animation()

	# 능력 확인 (이단점프 기본 활성화)
	can_double_jump = true  # GameManager.unlocked_abilities.get("double_jump", false)

	# 할로우 나이트: 초기 체력 설정 (Mask 시스템)
	current_masks = STARTING_MASKS
	max_masks = STARTING_MASKS

	# Soul 초기화
	current_soul = 0

	# 초기 외형 설정
	_update_appearance()

	# 스프라이트 초기 위치 저장
	if animated_sprite:
		original_y_position = animated_sprite.position.y

	print("플레이어 준비 완료")


# === 대쉬 애니메이션 동적 로드 (Mothwing Cloak) ===
func _load_dash_animation():
	if not animated_sprite or not animated_sprite.sprite_frames:
		print("애니메이션 스프라이트가 없습니다 (무시)")
		return

	var dash_folder = "res://assets/sprites/player/animations/human/dodge/"
	var dir = DirAccess.open(dash_folder)

	if not dir:
		print("대쉬 폴더를 열 수 없습니다: ", dash_folder)
		return

	# 폴더 내 모든 PNG 파일 찾기
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			files.append(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
	files.sort()

	print("대쉬 프레임 파일 발견: %d개" % files.size())

	# human_dodge 애니메이션 프레임 교체
	if animated_sprite.sprite_frames.has_animation("human_dodge"):
		# 기존 프레임 모두 제거
		var old_count = animated_sprite.sprite_frames.get_frame_count("human_dodge")
		for i in range(old_count - 1, -1, -1):
			animated_sprite.sprite_frames.remove_frame("human_dodge", i)

		# 실제 파일로 프레임 추가
		var loaded_count = 0
		for file in files:
			var texture = load(dash_folder + file)
			if texture:
				animated_sprite.sprite_frames.add_frame("human_dodge", texture)
				loaded_count += 1

		# 속도 설정
		animated_sprite.sprite_frames.set_animation_speed("human_dodge", 90.0)
		animated_sprite.sprite_frames.set_animation_loop("human_dodge", false)

		print("대쉬 애니메이션 로드 완료: %d 프레임, 90 FPS" % loaded_count)
	else:
		print("경고: human_dodge 애니메이션을 찾을 수 없습니다!")


func _physics_process(delta: float):
	_update_timers(delta)

	# 대쉬 중 잔상 생성
	if is_dashing:
		_spawn_dash_afterimage(delta)

	_handle_input()
	_apply_gravity(delta)
	_apply_movement()
	_update_animation()

	# 공격 중이면 적 타격 체크 (최적화: attack_hitbox가 활성화되어있을 때만)
	if is_attacking and attack_hitbox and not attack_hitbox.disabled:
		_check_attack_hit()

	move_and_slide()

	# 대쉬 중 벽에 부딪히면 즉시 대쉬 중단 (할로우 나이트 동작)
	if is_dashing and is_on_wall():
		is_dashing = false
		dash_safety_timer = 0.0
		velocity.x = 0
		current_anim_state = AnimState.IDLE
		# 애니메이션 강제 중단 및 idle로 전환
		if animated_sprite:
			var prefix = "evil_" if _is_evil_mode() else "human_"
			animated_sprite.stop()
			animated_sprite.play(prefix + "idle")
		print("벽에 부딪혀 대쉬 중단!")

	# === 무한 낙하 방지 ===
	# 바닥에 있을 때 안전 위치 업데이트
	if is_on_floor():
		last_safe_position = position

	# 너무 아래로 떨어지면 리스폰
	if position.y > FALL_DEATH_Y * 32:  # 타일 크기 32px
		_respawn_from_fall()



# === 입력 처리 ===
func _handle_input():
	# 움직임 비활성화 (컷씬 중)
	if not can_move:
		velocity.x = 0
		return

	# 대쉬 중이면 입력 차단 (Mothwing Cloak)
	if is_dashing:
		return

	# 모드 전환 (Tab 또는 Q)
	if Input.is_action_just_pressed("switch_mode"):
		_switch_mode()

	# 이동 (할로우 나이트: 즉시 가속/감속, AIR_CONTROL = 1.0)
	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir != 0:
		# 할로우 나이트: 즉시 가속 (lerp 제거)
		velocity.x = input_dir * WALK_SPEED

		# 방향 전환
		if input_dir > 0 and not facing_right:
			_flip_sprite()
		elif input_dir < 0 and facing_right:
			_flip_sprite()
	else:
		# 할로우 나이트: 즉시 정지 (lerp 제거)
		velocity.x = 0

	# 점프 (아래 방향키를 누르고 있으면 플랫폼 뚫고 내려가기)
	if Input.is_action_just_pressed("jump"):
		if Input.is_action_pressed("move_down") and is_on_floor():
			_drop_through_platform()
		else:
			_try_jump()

	# 공격 (엄격한 조건 체크로 중복 실행 방지)
	if Input.is_action_just_pressed("attack") and can_attack and not is_attacking:
		_perform_attack()
		return  # 공격하면 다른 입력 무시

	# 대쉬 (Mothwing Cloak - 할로우 나이트 기본 능력)
	if Input.is_action_just_pressed("dodge") and dash_cooldown_timer <= 0 and not is_dashing:
		_perform_dash()
		return  # 대쉬하면 다른 입력 무시

	# 특수 능력
	if Input.is_action_just_pressed("special_ability"):
		_use_special_ability()
		return  # 특수 능력 사용하면 다른 입력 무시

	# 디버그: F 키로 통계 출력
	if Input.is_action_just_pressed("ui_focus_next"):  # F 키
		GameManager.print_debug_stats()

	# 디버그: R 키로 강제 상태 리셋 (키 눌러서 멈췄을 때 긴급 탈출용)
	if Input.is_action_just_pressed("ui_cancel"):  # R 키 (ESC)
		_emergency_reset()


# === 이동 ===
func _apply_gravity(delta: float):
	# 대쉬 중에는 중력 무시
	if is_dashing:
		return

	# dodge 중에는 바닥에 있을 때만 중력 무시 (공중에서는 중력 적용)
	if is_dashing and is_on_floor():
		velocity.y = 0
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, 1000.0)  # 최대 낙하 속도


func _apply_movement():
	# 대쉬 중에는 대쉬 방향으로 이동 (할로우 나이트: 수평만)
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0  # 할로우 나이트 대쉬는 수평으로만 이동


func _get_current_move_speed() -> float:
	# 할로우 나이트: 속도 고정 (모드 없음)
	return WALK_SPEED


# === 점프 ===
func _try_jump():
	if is_on_floor():
		# 즉시 점프 발동 (준비 동작 제거)
		velocity.y = JUMP_VELOCITY
		has_double_jumped = false
		print("점프!")
	elif can_double_jump and not has_double_jumped:
		# 2단 점프
		velocity.y = JUMP_VELOCITY * 0.8
		has_double_jumped = true
		print("2단 점프!")


func _drop_through_platform():
	# 일방통행 플랫폼(layer 4)과의 충돌 일시적으로 비활성화
	set_collision_mask_value(3, false)  # layer 4는 비트 3
	platform_drop_timer = PLATFORM_DROP_DURATION
	print("플랫폼 뚫고 내려가기!")


# === 전투 ===
func _perform_attack():
	if not can_attack:
		return

	is_attacking = true
	can_attack = false
	hit_enemies.clear()  # 새 공격 시작 시 적 리스트 초기화

	# 할로우 나이트: 0.41초 쿨다운 (콤보/레이지 시스템 제거)
	attack_timer = ATTACK_COOLDOWN

	# Safety timeout 시작 (최대 0.5초 후 강제 해제)
	attack_safety_timer = MAX_ATTACK_DURATION

	# 공격 애니메이션 재생
	if animated_sprite:
		var prefix = "evil_" if _is_evil_mode() else "human_"
		animated_sprite.play(prefix + "attack")
		print("공격 애니메이션 재생: %s" % (prefix + "attack"))

	# print("공격! (Nail Lv%d)" % nail_level)

	# 공격 판정 영역 활성화 (칼을 휘두를 때까지 딜레이)
	_activate_attack_hitbox_delayed()


func _calculate_damage() -> float:
	# 할로우 나이트 Nail 업그레이드 시스템 (크리티컬/레이지 제거)
	match nail_level:
		1: return OLD_NAIL_DAMAGE         # 5
		2: return SHARPENED_NAIL_DAMAGE   # 9
		3: return CHANNELLED_NAIL_DAMAGE  # 13
		4: return COILED_NAIL_DAMAGE      # 17
		5: return PURE_NAIL_DAMAGE        # 21
		_: return OLD_NAIL_DAMAGE         # 기본값


# === 대쉬 (Mothwing Cloak) ===
func _activate_iframes():
	# 충돌 레이어 변경으로 진짜 무적 구현
	var original_collision_layer = collision_layer
	var original_collision_mask = collision_mask

	# 무적 상태: 적 공격 못 받음
	collision_layer = 0
	collision_mask = 1   # 땅만 감지 (떨어지지 않게)

	print("무적 프레임 시작!")

	# 엘든링 스타일: 0.3초간 무적 (전체 0.4초 중)
	await get_tree().create_timer(0.3).timeout

	# 무적 해제
	if is_instance_valid(self):
		collision_layer = original_collision_layer
		collision_mask = original_collision_mask
		print("무적 프레임 종료!")


# === 특수 능력 ===
func _use_special_ability():
	if _is_evil_mode():
		# 악신 모드: 회전 베기 (쿨타임 체크 필요)
		_spin_attack()
	else:
		# 인간 모드: 패링
		_activate_parry()


func _activate_rage():
	# 할로우 나이트: 레이지 시스템 제거
	pass


func _spin_attack():
	print("회전 베기!")
	# TODO: 360도 범위 공격 구현


func _activate_parry():
	parry_window = true
	parry_timer = PARRY_WINDOW_DURATION
	print("패링 준비!")
	# TODO: 적 공격 타이밍 체크


func _on_parry_success():
	# 할로우 나이트: 패링 시스템 없음 (Sharp Shadow 등 Charm으로 구현 예정)
	parry_window = false
	GameManager.on_parry_success()

	# TODO: Charm 시스템 구현 시 추가


# === 모드 전환 ===
func _switch_mode():
	GameManager.switch_mode()
	# _on_mode_switched는 시그널로 자동 호출됨


func _on_mode_switched(new_mode):
	# 할로우 나이트: 모드 전환 비활성화됨
	print("플레이어: 모드 전환 감지 - %s (비활성화됨)" % ("악신" if new_mode == GameManager.PlayerMode.EVIL else "인간"))

	# 시각 효과 변경
	_update_appearance()


func _update_health_from_mode():
	pass  # 할로우 나이트: 모드 없음


func _get_max_health() -> int:
	# 할로우 나이트: Mask 시스템
	return max_masks


func _is_evil_mode() -> bool:
	return GameManager.current_mode == GameManager.PlayerMode.EVIL


# === 피격 ===
func take_damage(damage: float):
	# 할로우 나이트: 대쉬 중 무적 없음 (Shade Cloak 필요)
	# TODO: Shade Cloak 획득 시 대쉬 중 무적 추가

	# 할로우 나이트: Mask 시스템 (1 damage = 1 mask)
	current_masks -= int(damage)
	print("피격! Mask: %d/%d" % [current_masks, max_masks])

	if current_masks <= 0:
		_die()


func _die():
	print("사망!")
	# TODO: 사망 애니메이션, 리스폰


func _respawn_from_fall():
	"""무한 낙하 시 마지막 안전 위치로 리스폰"""
	print("무한 낙하 감지! 리스폰...")

	# 마지막 안전 위치로 텔레포트
	position = last_safe_position
	velocity = Vector2.ZERO

	# 약간의 데미지 (선택사항)
	take_damage(10)

	print("✓ 리스폰 완료: %s" % last_safe_position)


# === 적 처치 시 (외부에서 호출) ===
func on_kill_enemy():
	GameManager.on_enemy_killed()
	# 할로우 나이트: 적 처치 시 체력 회복 없음 (Charm 시스템으로 구현 예정)


# === 애니메이션 이벤트 ===
func _on_animation_finished():
	if not animated_sprite:
		return

	var anim_name = animated_sprite.animation

	# 공격 애니메이션이 끝나면 is_attacking 해제
	if anim_name == "human_attack" or anim_name == "evil_attack":
		is_attacking = false
		_deactivate_attack_hitbox()  # hitbox 비활성화
		attack_safety_timer = 0.0  # safety timer 리셋
		_update_animation()  # 다음 애니메이션으로 즉시 전환
		# print("공격 애니메이션 완료!")

	# 대쉬 애니메이션이 끝나면 is_dashing 해제 (Mothwing Cloak)
	if anim_name == "human_dodge" or anim_name == "evil_dodge":
		is_dashing = false
		dash_safety_timer = 0.0  # safety timer 리셋
		velocity.x = 0  # 대쉬 종료 시 수평 속도 초기화
		current_anim_state = AnimState.IDLE  # 상태 리셋하여 강제로 애니메이션 전환
		# 애니메이션 강제 중단 및 idle로 전환
		if animated_sprite:
			var prefix = "evil_" if _is_evil_mode() else "human_"
			animated_sprite.play(prefix + "idle")
		print("Mothwing Cloak 대쉬 완료!")


# === 타이머 업데이트 ===
func _update_timers(delta: float):
	# === Safety Timers (상태 강제 해제) ===
	# 공격이 너무 오래 지속되면 강제 해제
	if is_attacking:
		attack_safety_timer -= delta
		if attack_safety_timer <= 0:
			print("[SAFETY] 공격 상태 강제 해제!")
			is_attacking = false
			_deactivate_attack_hitbox()
			attack_safety_timer = 0.0

	# 대쉬가 너무 오래 지속되면 강제 해제 (안전장치)
	if is_dashing:
		dash_safety_timer -= delta
		if dash_safety_timer <= 0:
			print("[SAFETY] 대쉬 상태 강제 해제!")
			is_dashing = false
			dash_safety_timer = 0.0
			velocity.x = 0  # 속도 초기화
			current_anim_state = AnimState.IDLE  # 상태 리셋
			# 애니메이션 강제 중단 및 idle로 전환
			if animated_sprite:
				var prefix = "evil_" if _is_evil_mode() else "human_"
				animated_sprite.stop()
				animated_sprite.play(prefix + "idle")

	# 공격 쿨타임 (다음 공격까지의 쿨타임만 관리)
	if not can_attack:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true
			# is_attacking은 애니메이션 완료 시그널에서 처리

	# 할로우 나이트: 콤보/광폭화 타이머 제거

	# 대쉬 쿨다운 타이머만 관리 (is_dashing은 애니메이션 완료 시그널에서 처리)
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# 패링 타이머
	if parry_window:
		parry_timer -= delta
		if parry_timer <= 0:
			parry_window = false

	# 플랫폼 뚫고 내려가기 타이머
	if platform_drop_timer > 0:
		platform_drop_timer -= delta
		if platform_drop_timer <= 0:
			set_collision_mask_value(3, true)  # layer 4 충돌 다시 활성화

	# 대쉬 쿨다운 타이머만 관리 (is_dashing은 애니메이션 완료 시그널에서 처리)
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta


# === 애니메이션 ===
func _update_animation():
	# 공격이나 대쉬 중에는 애니메이션 덮어쓰지 않음
	if is_attacking or is_dashing:
		return

	var target_state = AnimState.IDLE

	if not is_on_floor():
		# 점프/낙하 구분을 부드럽게
		if velocity.y < -50:  # 충분히 위로 올라갈 때만 점프 애니메이션
			target_state = AnimState.JUMP
		else:  # 낙하 시작 또는 낙하 중
			target_state = AnimState.FALL
	elif abs(velocity.x) > 10:
		target_state = AnimState.WALK
	else:
		target_state = AnimState.IDLE

	if target_state != current_anim_state:
		current_anim_state = target_state
		_play_animation(target_state)


func _play_animation(state: AnimState):
	if not animated_sprite:
		return

	# 모드에 따라 애니메이션 이름 접두사 설정
	var prefix = "evil_" if _is_evil_mode() else "human_"

	var anim_name = ""
	match state:
		AnimState.IDLE: anim_name = prefix + "idle"
		AnimState.WALK: anim_name = prefix + "walk"
		AnimState.JUMP: anim_name = prefix + "jump"
		AnimState.FALL: anim_name = prefix + "fall"
		AnimState.ATTACK: anim_name = prefix + "attack"
		AnimState.DASH: anim_name = prefix + "dodge"
		AnimState.HURT: anim_name = prefix + "hurt"

	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)


func _flip_sprite():
	facing_right = not facing_right
	if animated_sprite:
		animated_sprite.flip_h = not facing_right


func _update_appearance():
	if not animated_sprite:
		return

	# 애니메이션이 자동으로 모드별 프리픽스(human_ / evil_)를 사용함
	# 현재 애니메이션을 다시 재생하여 모드 전환 반영
	if animated_sprite.is_playing():
		var _current_anim = animated_sprite.animation
		_play_animation(current_anim_state)

	print("외형 변경: %s 모드" % ("악신" if _is_evil_mode() else "인간"))

	# TODO: 오라 효과 추가
	# 악신: 붉은 오라
	# 인간: 하얀 오라


# === 공격 판정 ===
func _activate_attack_hitbox_delayed():
	# 즉시 활성화 (await 제거로 성능 개선)
	if not attack_hitbox:
		return

	# 공격 방향에 따라 hitbox 위치 조정
	var hitbox_offset = 35 if facing_right else -35
	attack_hitbox.position.x = hitbox_offset

	# Hitbox 즉시 활성화
	attack_hitbox.disabled = false
	attack_area.monitoring = true


func _activate_attack_hitbox():
	pass  # 사용 안 함


func _deactivate_attack_hitbox():
	if not attack_hitbox:
		return

	attack_hitbox.disabled = true
	attack_area.monitoring = false
	# hit_enemies는 _perform_attack에서 초기화됨


func _check_attack_hit():
	if not attack_area:
		return

	# Area2D에 겹쳐진 모든 body 확인
	var bodies = attack_area.get_overlapping_bodies()

	for body in bodies:
		# 이미 이번 공격에 맞은 적은 스킵
		if body in hit_enemies:
			continue

		# Enemy 클래스인지 확인 (나중에 적 구현 후)
		if body.has_method("take_damage"):
			var damage = _calculate_damage()
			body.take_damage(damage)
			hit_enemies.append(body)

			# print("적 타격! 데미지: %.1f" % damage)

			# Soul 충전 (할로우 나이트: 타격 시 +11)
			_gain_soul(11)

			# 타격감 효과 (적 위치 전달)
			_trigger_hit_effects(body.global_position)

			# 적 처치 체크
			if body.has_method("is_dead") and body.is_dead():
				on_kill_enemy()


# === 타격감 효과 ===
func _trigger_hit_effects(_hit_position: Vector2):
	# 성능 문제로 타격감 효과 모두 비활성화
	pass


func _apply_hitstop():
	if hitstop_active:
		return

	hitstop_active = true
	Engine.time_scale = 0.05  # 시간을 거의 멈춤 (5%)

	# 실제 시간으로 대기 (process_mode를 변경)
	await get_tree().create_timer(HITSTOP_DURATION, true, false, true).timeout

	Engine.time_scale = 1.0
	hitstop_active = false


func _shake_camera(intensity: float, duration: float):
	if not camera:
		return

	var shake_timer = 0.0
	var original_offset = camera.offset

	while shake_timer < duration:
		# 랜덤 오프셋 적용
		camera.offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)

		# 실제 시간으로 대기
		await get_tree().create_timer(0.02, true, false, true).timeout
		shake_timer += 0.02

	# 원래 위치로 복귀
	camera.offset = original_offset


func _spawn_hit_particles(hit_position: Vector2):
	if not hit_particles:
		return

	# 파티클을 적 위치로 이동
	hit_particles.global_position = hit_position

	# 파티클 발생
	hit_particles.emitting = true


# === Soul 시스템 (할로우나이트 스타일) ===
func _gain_soul(amount: float):
	current_soul = min(current_soul + amount, max_soul)
	print("Soul +%.0f (%.0f/%.0f)" % [amount, current_soul, max_soul])


func can_use_soul(cost: float) -> bool:
	return current_soul >= cost


func use_soul(cost: float) -> bool:
	if not can_use_soul(cost):
		return false

	current_soul -= cost
	print("Soul 사용: -%.0f (%.0f/%.0f)" % [cost, current_soul, max_soul])
	return true


func get_health() -> float:
	# 할로우 나이트: Mask 반환
	return float(current_masks)


# === 능력 해금 시스템 ===
func unlock_ability(ability_type: int):
	match ability_type:
		0:  # DASH
			has_dash_ability = true
			print("능력 해금: 대쉬 (다리의 파편)")
		1:  # WALL_JUMP
			has_wall_jump = true
			print("능력 해금: 벽 점프 (팔의 파편)")
		2:  # SWIM
			has_swim = true
			print("능력 해금: 수영 (폐의 파편)")
		# TODO: 나머지 능력들 추가


func _perform_dash():
	is_dashing = true
	dash_cooldown_timer = DASH_COOLDOWN
	dash_safety_timer = MAX_DASH_DURATION  # 안전장치 시작

	# 대쉬 방향 설정 (할로우 나이트: 좌우만, float)
	dash_direction = 1.0 if facing_right else -1.0

	# 할로우 나이트 대쉬 애니메이션 재생
	if animated_sprite and animated_sprite.sprite_frames.has_animation("human_dodge"):
		animated_sprite.play("human_dodge")

	print("Mothwing Cloak 대쉬! 방향: %.0f, 거리: %.0f px" % [dash_direction, DASH_SPEED * DASH_DURATION])


# === 컷씬/연출용 ===
func set_can_move(value: bool):
	can_move = value
	if not value:
		velocity = Vector2.ZERO


# === 긴급 상태 리셋 (디버그용) ===
func _emergency_reset():
	print("[긴급 리셋] 모든 상태 초기화!")

	# 모든 액션 상태 해제
	is_attacking = false
	is_dashing = false

	# 타이머 리셋
	attack_safety_timer = 0.0
	dash_safety_timer = 0.0
	attack_timer = 0.0
	dash_cooldown_timer = 0.0

	# 공격 관련 정리
	_deactivate_attack_hitbox()
	hit_enemies.clear()

	# 쿨타임 해제
	can_attack = true

	print("✓ 상태 리셋 완료")


# === 검 궤적 효과 ===
func _start_sword_trail():
	if not sword_trail or not attack_hitbox:
		return

	# 검 궤적 시작 위치 (공격 히트박스 위치)
	var trail_start = attack_hitbox.global_position
	sword_trail.start_trail(trail_start)

	# 검 궤적 색상 (모드별)
	if _is_evil_mode():
		sword_trail.default_color = Color(1.0, 0.2, 0.2, 0.8)  # 붉은색
		sword_trail.width = 12.0  # 굵게
	else:
		sword_trail.default_color = Color(0.5, 0.8, 1.0, 0.8)  # 푸른색
		sword_trail.width = 8.0

	# 검 휘두르기 애니메이션 (0.2초 동안)
	_animate_sword_trail()


func _animate_sword_trail():
	if not sword_trail or not attack_hitbox:
		return

	var duration = 0.15
	var steps = 8
	var step_time = duration / steps

	for i in range(steps):
		await get_tree().create_timer(step_time).timeout
		if is_instance_valid(self) and sword_trail and attack_hitbox:
			sword_trail.update_trail_position(attack_hitbox.global_position)

	# 궤적 종료
	if is_instance_valid(self) and sword_trail:
		sword_trail.stop_trail()


func _spawn_dash_afterimage(delta: float):
	if not animated_sprite:
		return

	afterimage_spawn_timer -= delta
	if afterimage_spawn_timer <= 0:
		afterimage_spawn_timer = AFTERIMAGE_SPAWN_INTERVAL

		# 현재 스프라이트의 텍스처 가져오기
		var current_frame = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)

		if current_frame:
			# 잔상 생성 (afterimage.gd의 static 함수 사용)
			var afterimage_script = load("res://scripts/afterimage.gd")
			var afterimage = Sprite2D.new()
			afterimage.set_script(afterimage_script)

			# 씬에 추가
			get_parent().add_child(afterimage)

			# 설정
			afterimage.texture = current_frame
			afterimage.global_position = global_position
			afterimage.scale = animated_sprite.scale
			afterimage.flip_h = animated_sprite.flip_h

			# 모드별 색상
			if _is_evil_mode():
				afterimage.modulate = Color(1.0, 0.3, 0.3, 0.6)  # 붉은색
			else:
				afterimage.modulate = Color(0.3, 0.6, 1.0, 0.6)  # 푸른색
