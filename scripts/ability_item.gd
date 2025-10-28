extends Area2D
class_name AbilityItem

## 능력 아이템 (보스 처치 후 획득)
## 할로우 나이트의 능력 획득 시스템

## 능력 타입 (int로 전달)
## 0: DASH, 1: WALL_JUMP, 2: SWIM, ...

@export var ability_type: int = 0  # 0 = DASH
@export var ability_name: String = "다리의 파편"
@export var ability_description: String = "빠른 대시로 적을 피하고 먼 거리를 뛰어넘으세요."

# 떠다니는 효과
var float_offset: float = 0.0
var float_speed: float = 2.0
var float_amplitude: float = 10.0

# 빛나는 효과
var glow_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	# Area2D 설정
	collision_layer = 0
	collision_mask = 1  # 플레이어만 충돌

	# 시그널 연결
	body_entered.connect(_on_body_entered)

	print("Ability item spawned: %s" % ability_name)

func _process(delta: float):
	# 떠다니는 효과
	float_offset += float_speed * delta
	if sprite:
		sprite.position.y = sin(float_offset) * float_amplitude

	# 빛나는 효과
	glow_timer += delta * 3
	if sprite:
		var glow = 0.8 + sin(glow_timer) * 0.2
		sprite.modulate = Color(glow, glow, 1.0)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		print("Player collected: %s" % ability_name)
		_grant_ability(body)
		queue_free()

func _grant_ability(player: Node2D):
	if not player.has_method("unlock_ability"):
		print("Warning: Player doesn't have unlock_ability method!")
		return

	player.unlock_ability(ability_type)

	# TODO: 능력 획득 연출
	# - 화면 멈춤
	# - 아이템 이름 표시
	# - 설명 텍스트
	print("Ability unlocked: %s" % ability_name)
