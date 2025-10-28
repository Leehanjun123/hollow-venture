extends CharacterBody2D
class_name Crawlid

## Crawlid - 할로우 나이트 적
## 8 HP, 느린 순찰, 플레이어 무시, 벽에 닿으면 방향 전환

# === 할로우 나이트 스탯 (정확한 수치) ===
const MAX_HEALTH = 8
const WALK_SPEED = 50.0  # 느림
const GRAVITY = 1500.0

# === 상태 ===
var current_health: int = MAX_HEALTH
var dead: bool = false
var facing_right: bool = true

# === 레퍼런스 ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector_right: RayCast2D = $WallDetectorRight
@onready var wall_detector_left: RayCast2D = $WallDetectorLeft
@onready var floor_detector_right: RayCast2D = $FloorDetectorRight
@onready var floor_detector_left: RayCast2D = $FloorDetectorLeft

func _ready():
	# 스프라이트 프레임 로드
	_load_sprite_frames()

	# 랜덤 방향으로 시작
	if randf() > 0.5:
		facing_right = true
	else:
		facing_right = false
		_flip_sprite()

	# 애니메이션 시작
	if animated_sprite:
		animated_sprite.play("walk")

	print("Crawlid 준비 완료 (HP: %d)" % current_health)


func _load_sprite_frames():
	"""스프라이트 프레임 동적 로드"""
	if not animated_sprite or not animated_sprite.sprite_frames:
		return

	var base_path = "res://assets/sprites/enemies/crawlid/"

	# Idle 애니메이션 로드
	_load_animation_frames("idle", base_path + "idle_", 4)

	# Walk 애니메이션 로드
	_load_animation_frames("walk", base_path + "walk_", 6)

	# Death 애니메이션 로드
	_load_animation_frames("death", base_path + "death_", 4)


func _load_animation_frames(anim_name: String, prefix: String, count: int):
	"""특정 애니메이션의 프레임들 로드"""
	if not animated_sprite.sprite_frames.has_animation(anim_name):
		return

	# 기존 프레임 제거
	var old_count = animated_sprite.sprite_frames.get_frame_count(anim_name)
	for i in range(old_count - 1, -1, -1):
		animated_sprite.sprite_frames.remove_frame(anim_name, i)

	# 새 프레임 추가
	for i in range(count):
		var path = "%s%02d.png" % [prefix, i]
		if ResourceLoader.exists(path):
			var texture = load(path)
			if texture:
				animated_sprite.sprite_frames.add_frame(anim_name, texture)


func _physics_process(delta: float):
	if dead:
		return

	# 중력 적용
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# 순찰 이동
	_patrol()

	# 벽 감지 및 방향 전환
	_check_walls()

	# 바닥 끝 감지 (떨어지지 않게)
	_check_floor_edge()

	move_and_slide()


func _patrol():
	"""느린 순찰 - 할로우 나이트 Crawlid"""
	if facing_right:
		velocity.x = WALK_SPEED
	else:
		velocity.x = -WALK_SPEED


func _check_walls():
	"""벽에 닿으면 방향 전환"""
	if not wall_detector_right or not wall_detector_left:
		return

	if facing_right and wall_detector_right.is_colliding():
		_turn_around()
	elif not facing_right and wall_detector_left.is_colliding():
		_turn_around()


func _check_floor_edge():
	"""바닥 끝에 도달하면 방향 전환 (떨어지지 않게)"""
	if not floor_detector_right or not floor_detector_left:
		return

	if facing_right and not floor_detector_right.is_colliding():
		_turn_around()
	elif not facing_right and not floor_detector_left.is_colliding():
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
	print("Crawlid 피격! HP: %d/%d" % [current_health, MAX_HEALTH])

	if current_health <= 0:
		_die()


func _die():
	"""사망"""
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO

	print("Crawlid 사망!")

	# 사망 애니메이션
	if animated_sprite:
		animated_sprite.play("death")
		await animated_sprite.animation_finished

	# 제거
	queue_free()


func is_dead() -> bool:
	return dead
