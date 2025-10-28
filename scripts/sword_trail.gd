extends Line2D

## 검 휘두르기 궤적 효과
## 공격 시 검이 지나간 자리에 잔상 표시

var trail_points: Array[Vector2] = []
var max_points: int = 8
var fade_speed: float = 5.0
var trail_active: bool = false

func _ready():
	width = 8.0
	default_color = Color(1, 1, 1, 0.8)
	joint_mode = Line2D.LINE_JOINT_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND

func _process(delta: float):
	if not trail_active:
		# 페이드 아웃
		if get_point_count() > 0:
			default_color.a = max(0, default_color.a - fade_speed * delta)
			if default_color.a <= 0:
				clear_points()
		return

	# Trail 업데이트
	_update_trail()

func start_trail(start_pos: Vector2):
	trail_active = true
	trail_points.clear()
	clear_points()
	default_color.a = 0.8
	trail_points.append(start_pos)
	add_point(start_pos)

func update_trail_position(new_pos: Vector2):
	if not trail_active:
		return

	# 마지막 포인트와 너무 가까우면 추가 안 함
	if trail_points.size() > 0:
		var last_pos = trail_points[-1]
		if last_pos.distance_to(new_pos) < 5.0:
			return

	trail_points.append(new_pos)
	add_point(new_pos)

	# 최대 포인트 초과 시 오래된 포인트 제거
	if trail_points.size() > max_points:
		trail_points.pop_front()
		remove_point(0)

func stop_trail():
	trail_active = false

func _update_trail():
	# 실시간으로 Line2D 포인트 업데이트
	clear_points()
	for point in trail_points:
		add_point(point)
