extends CharacterBody2D
class_name Tiktik

## Tiktik - 할로우 나이트 적
## 8 HP, 벽/천장/바닥 기어다님, 플레이어 무시

# === 할로우 나이트 스탯 ===
const MAX_HEALTH = 8
const WALK_SPEED = 120.0  # Crawlid보다 빠름
const GRAVITY = 1500.0
const ROTATION_SPEED = 10.0  # 표면 따라 회전 속도

# === 상태 ===
var current_health: int = MAX_HEALTH
var dead: bool = false
var facing_right: bool = true
var is_on_surface: bool = false
var surface_normal: Vector2 = Vector2.UP

# === 레퍼런스 ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var surface_detector: RayCast2D = $SurfaceDetector
@onready var forward_detector: RayCast2D = $ForwardDetector

func _ready():
	# 스프라이트 프레임 로드
	_load_sprite_frames()

	# 랜덤 방향으로 시작
	if randf() > 0.5:
		facing_right = false
		_flip_sprite()

	# 애니메이션 시작
	if animated_sprite:
		animated_sprite.play("walk")

	print("Tiktik 준비 완료 (HP: %d)" % current_health)


func _load_sprite_frames():
	"""스프라이트 프레임 동적 로드"""
	if not animated_sprite or not animated_sprite.sprite_frames:
		return

	var base_path = "res://assets/sprites/enemies/tiktik/"

	_load_animation_frames("idle", base_path + "idle_", 4)
	_load_animation_frames("walk", base_path + "walk_", 8)
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

	# 표면 감지
	_detect_surface()

	if is_on_surface:
		# 표면을 따라 이동
		_walk_on_surface()

		# 표면 법선에 맞춰 회전
		_align_to_surface(delta)

		# 앞쪽 체크 (벽 끝)
		_check_forward()
	else:
		# 표면 없으면 중력 적용
		velocity.y += GRAVITY * delta
		rotation = 0  # 떨어질 때는 수평

	move_and_slide()


func _detect_surface():
	"""표면 감지 (벽/천장/바닥)"""
	if not surface_detector:
		is_on_surface = is_on_floor()
		surface_normal = Vector2.UP
		return

	is_on_surface = surface_detector.is_colliding()

	if is_on_surface:
		surface_normal = surface_detector.get_collision_normal()


func _walk_on_surface():
	"""표면을 따라 이동"""
	# 표면의 접선 방향 (법선에 수직)
	var tangent = Vector2(-surface_normal.y, surface_normal.x)

	# 방향에 따라 이동
	if not facing_right:
		tangent = -tangent

	velocity = tangent * WALK_SPEED


func _align_to_surface(delta: float):
	"""표면 법선에 맞춰 회전"""
	# 목표 회전 (표면 법선 기준)
	var target_rotation = surface_normal.angle() + PI / 2

	# 부드럽게 회전
	rotation = lerp_angle(rotation, target_rotation, ROTATION_SPEED * delta)


func _check_forward():
	"""앞쪽 체크 - 표면이 끝나거나 코너면 방향 전환"""
	if not forward_detector:
		return

	# 앞쪽에 표면이 없으면 방향 전환
	if not forward_detector.is_colliding():
		_turn_around()


func _turn_around():
	"""방향 전환"""
	facing_right = not facing_right
	_flip_sprite()


func _flip_sprite():
	"""스프라이트 뒤집기"""
	if animated_sprite:
		animated_sprite.flip_h = not facing_right


func take_damage(damage: float):
	"""피격"""
	if dead:
		return

	current_health -= int(damage)
	print("Tiktik 피격! HP: %d/%d" % [current_health, MAX_HEALTH])

	if current_health <= 0:
		_die()


func _die():
	"""사망"""
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO
	rotation = 0

	print("Tiktik 사망!")

	if animated_sprite:
		animated_sprite.play("death")
		await animated_sprite.animation_finished

	queue_free()


func is_dead() -> bool:
	return dead
