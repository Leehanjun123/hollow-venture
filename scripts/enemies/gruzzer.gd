extends CharacterBody2D
class_name Gruzzer

## Gruzzer - 할로우 나이트 적
## 8 HP, 천천히 떠다니다가 플레이어 감지 시 돌진

# === 할로우 나이트 스탯 ===
const MAX_HEALTH = 8
const FLOAT_SPEED = 30.0  # 느린 부유
const CHARGE_SPEED = 300.0  # 빠른 돌진
const DETECT_RANGE = 200.0  # 플레이어 감지 범위
const STUN_DURATION = 1.5  # 기절 시간

# === 상태 ===
enum State { IDLE, CHARGE, STUNNED }
var current_state: State = State.IDLE
var current_health: int = MAX_HEALTH
var dead: bool = false

var float_direction: Vector2 = Vector2.RIGHT
var charge_direction: Vector2 = Vector2.ZERO
var stun_timer: float = 0.0

# === 레퍼런스 ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	# 스프라이트 프레임 로드
	_load_sprite_frames()

	# 랜덤 방향으로 시작
	float_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

	# 애니메이션 시작
	if animated_sprite:
		animated_sprite.play("idle")

	# Detection Area 설정
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered_detection)

	print("Gruzzer 준비 완료 (HP: %d)" % current_health)


func _load_sprite_frames():
	"""스프라이트 프레임 동적 로드"""
	if not animated_sprite or not animated_sprite.sprite_frames:
		return

	var base_path = "res://assets/sprites/enemies/gruzzer/"

	_load_animation_frames("idle", base_path + "idle_", 6)
	_load_animation_frames("charge", base_path + "charge_", 4)
	_load_animation_frames("stunned", base_path + "stunned_", 4)
	_load_animation_frames("death", base_path + "death_", 4)


func _load_animation_frames(anim_name: String, prefix: String, count: int):
	"""특정 애니메이션의 프레임들 로드"""
	if not animated_sprite.sprite_frames.has_animation(anim_name):
		return

	var old_count = animated_sprite.sprite_frames.get_frame_count(anim_name)
	for i in range(old_count - 1, -1, -1):
		animated_sprite.sprite_frames.remove_frame(anim_name, i)

	for i in range(count):
		var path = "%s%02d.png" % [prefix, i]
		if ResourceLoader.exists(path):
			var texture = load(path)
			if texture:
				animated_sprite.sprite_frames.add_frame(anim_name, texture)


func _physics_process(delta: float):
	if dead:
		return

	match current_state:
		State.IDLE:
			_idle_behavior()
		State.CHARGE:
			_charge_behavior()
		State.STUNNED:
			_stunned_behavior(delta)

	var collision = move_and_slide()
	if collision and current_state == State.CHARGE:
		# 벽에 부딪힘 -> 기절
		_stun()


func _idle_behavior():
	"""천천히 부유"""
	velocity = float_direction * FLOAT_SPEED

	# 랜덤하게 방향 전환
	if randf() < 0.01:  # 1% 확률로 방향 전환
		float_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()


func _charge_behavior():
	"""돌진"""
	velocity = charge_direction * CHARGE_SPEED


func _stunned_behavior(delta: float):
	"""기절 상태"""
	velocity = Vector2.ZERO

	stun_timer -= delta
	if stun_timer <= 0:
		# 기절 종료 -> IDLE로 복귀
		current_state = State.IDLE
		if animated_sprite:
			animated_sprite.play("idle")


func _on_body_entered_detection(body: Node2D):
	"""플레이어 감지"""
	if current_state != State.IDLE:
		return

	if body.is_in_group("player") or body.name == "Player":
		# 플레이어 방향으로 돌진
		charge_direction = (body.global_position - global_position).normalized()
		current_state = State.CHARGE

		if animated_sprite:
			animated_sprite.play("charge")

		print("Gruzzer 돌진!")


func _stun():
	"""기절"""
	current_state = State.STUNNED
	stun_timer = STUN_DURATION
	velocity = Vector2.ZERO

	if animated_sprite:
		animated_sprite.play("stunned")

	print("Gruzzer 기절!")


func take_damage(damage: float):
	"""피격"""
	if dead:
		return

	current_health -= int(damage)
	print("Gruzzer 피격! HP: %d/%d" % [current_health, MAX_HEALTH])

	if current_health <= 0:
		_die()


func _die():
	"""사망"""
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO

	print("Gruzzer 사망!")

	if animated_sprite:
		animated_sprite.play("death")
		await animated_sprite.animation_finished

	queue_free()


func is_dead() -> bool:
	return dead
