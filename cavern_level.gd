extends Node2D

# 필요한 스크립트와 플레이어 씬 경로 불러오기
const RoomFactory = preload("res://scripts/room_factory.gd")
const PlayerScene = preload("res://scenes/player/player.tscn")


const TILE_SIZE = 32.0

# Gameplay_Container 노드 경로 가져오기 (씬 트리에 맞게 수정 필요)
@onready var gameplay_container = $Gameplay_Container


func _ready():
	# 1. 플레이어 씬 인스턴스화
	var player_instance = PlayerScene.instantiate()

	# --- 수정 시작 ---
	# 2. 플레이어 캐릭터를 Gameplay_Container 아래에 먼저 추가
	gameplay_container.add_child(player_instance)

	# 3. call_deferred를 사용하여 위치 설정을 한 프레임 뒤로 미룸
	# 이렇게 하면 PlayerSpawner가 먼저 위치를 설정하더라도, 이 코드가 마지막에 덮어씁니다.
	player_instance.call_deferred("set_global_position", Vector2(-24.0, -31.0))
	
	print("✅ 플레이어 스폰 예약! 사용자 지정 위치: (-24.0, -31.0)")
	# --- 수정 끝 ---

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
