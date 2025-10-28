extends CanvasLayer
class_name GameUI

## 할로우나이트 스타일 UI

# UI 요소 레퍼런스
@onready var health_container: HBoxContainer = $HealthContainer
@onready var soul_gauge: ProgressBar = $SoulGauge
@onready var geo_amount: Label = $GeoContainer/GeoAmount
@onready var boss_health_bar: Control = $BossHealthBar
@onready var boss_hp: ProgressBar = $BossHealthBar/BossHP
@onready var boss_name: Label = $BossHealthBar/BossNameLabel

# 플레이어 레퍼런스
var player: Node2D = null
var boss: Node2D = null

# HP 마스크 아이콘들
var health_masks: Array[Label] = []  # Label로 수정
const MAX_HEALTH_DISPLAY = 10

func _ready():
	# HP 마스크 생성
	_create_health_masks()

	# 초기 Soul 게이지
	soul_gauge.value = 0

	print("Hollow Knight style UI loaded")

func _process(_delta: float):
	# 플레이어 찾기
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return

	# UI 업데이트
	_update_health_display()
	_update_soul_gauge()
	_update_boss_health()

func _create_health_masks():
	# HP를 마스크로 표시 (할로우나이트 스타일)
	for i in range(MAX_HEALTH_DISPLAY):
		var mask = Label.new()
		mask.text = "♥"  # 임시 하트 아이콘 (나중에 이미지로 교체)
		mask.add_theme_font_size_override("font_size", 24)
		mask.add_theme_color_override("font_color", Color.WHITE)
		health_container.add_child(mask)
		health_masks.append(mask)

func _update_health_display():
	if not player or not player.has_method("get_health"):
		return

	var current_hp = player.current_health if "current_health" in player else 100
	var _max_hp = player.max_health if "max_health" in player else 100

	# HP를 마스크 개수로 변환 (각 마스크 = 10 HP)
	var masks_to_show = int(ceil(current_hp / 10.0))

	for i in range(health_masks.size()):
		if i < masks_to_show:
			health_masks[i].modulate = Color.WHITE
		else:
			health_masks[i].modulate = Color(0.3, 0.3, 0.3, 0.5)

func _update_soul_gauge():
	if not player:
		return

	var current_soul = player.current_soul if "current_soul" in player else 0
	var max_soul = player.max_soul if "max_soul" in player else 100

	soul_gauge.max_value = max_soul
	soul_gauge.value = current_soul

func _update_boss_health():
	# 보스 찾기
	if not boss:
		boss = get_tree().get_first_node_in_group("boss")
		if boss:
			# 보스 발견 - HP 바 표시
			boss_health_bar.visible = true
			var boss_max_hp = boss.max_health if "max_health" in boss else 100
			boss_hp.max_value = boss_max_hp
			boss_hp.value = boss.current_health if "current_health" in boss else boss_max_hp
			print("Boss health bar initialized: %.1f/%.1f" % [boss_hp.value, boss_hp.max_value])
		return

	# 보스 HP 업데이트
	if is_instance_valid(boss):
		var current_hp = boss.current_health if "current_health" in boss else 0
		boss_hp.value = current_hp

		# 보스 죽으면 HP 바 숨김
		if boss.is_dead() if boss.has_method("is_dead") else false:
			boss_health_bar.visible = false
			boss = null
	else:
		boss_health_bar.visible = false
		boss = null

func update_geo(amount: int):
	geo_amount.text = str(amount)

func show_boss_health(boss_node: Node2D, boss_display_name: String):
	boss = boss_node
	boss_name.text = boss_display_name
	boss_health_bar.visible = true
	boss_hp.max_value = boss.max_health if "max_health" in boss else 300
	boss_hp.value = boss.current_health if "current_health" in boss else 300

func hide_boss_health():
	boss_health_bar.visible = false
	boss = null
