#!/usr/bin/env python3
"""
36개 점프 프레임을 포함한 완전한 player_frames.tres 생성
"""

def generate_full_config():
    output_file = "/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/player_frames_36.tres"

    # ExtResource 섹션 생성
    ext_resources = []

    # Idle (6프레임)
    ext_resources.append('[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/idle/idle_frame_001.png" id="1"]')
    for i in range(2, 7):
        ext_resources.append(f'[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/idle/idle_frame_{i:03d}.png" id="1_idle_{i}"]')

    # Walk (12프레임)
    for i in range(1, 13):
        ext_resources.append(f'[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/walk/walk_frame_{i:03d}.png" id="2_walk_{i}"]')

    # Jump (36프레임)
    for i in range(1, 37):
        ext_resources.append(f'[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/jump/jump_frame_{i:03d}.png" id="3_jump_{i}"]')

    # Attack, Dodge 등
    ext_resources.extend([
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/attack/attack_1.png" id="5"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/attack/attack_2.png" id="6"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/dodge/dodge_1.png" id="7"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/idle/idle_1.png" id="8"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/walk/walk_1.png" id="9"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/walk/walk_2.png" id="10"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/jump/jump_1.png" id="11"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/attack/attack_1.png" id="12"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/attack/attack_2.png" id="13"]',
        '[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/evil/dodge/dodge_1.png" id="14"]',
    ])

    # Jump 애니메이션 프레임 생성
    jump_frames = []
    for i in range(1, 37):
        jump_frames.append(f'{{"duration": 1.0, "texture": ExtResource("3_jump_{i}")}}')

    # 전체 파일 작성
    with open(output_file, 'w') as f:
        # 헤더
        total_resources = len(ext_resources) + 1  # +1 for the resource itself
        f.write(f'[gd_resource type="SpriteFrames" load_steps={total_resources} format=3]\n\n')

        # ExtResources
        for res in ext_resources:
            f.write(res + '\n')

        # Animations
        f.write('\n[resource]\n')
        f.write('animations = [{\n')

        # Idle animation
        f.write('"frames": [{"duration": 1.0, "texture": ExtResource("1")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("1_idle_2")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("1_idle_3")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("1_idle_4")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("1_idle_5")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("1_idle_6")}],\n')
        f.write('"loop": true, "name": &"human_idle", "speed": 6.0\n')

        # Walk animation
        f.write('}, {\n"frames": [')
        walk_frames = [f'{{"duration": 1.0, "texture": ExtResource("2_walk_{i}")}}' for i in range(1, 13)]
        f.write(', '.join(walk_frames))
        f.write('],\n"loop": true, "name": &"human_walk", "speed": 12.0\n')

        # Jump animation (36 frames!)
        f.write('}, {\n"frames": [')
        f.write(', '.join(jump_frames))
        f.write('],\n"loop": false, "name": &"human_jump", "speed": 36.0\n')

        # Fall animation
        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("3_jump_20")}],\n')
        f.write('"loop": false, "name": &"human_fall", "speed": 5.0\n')

        # Attack animation
        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("5")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("6")}],\n')
        f.write('"loop": false, "name": &"human_attack", "speed": 12.0\n')

        # Dodge animation
        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("7")}],\n')
        f.write('"loop": false, "name": &"human_dodge", "speed": 5.0\n')

        # Hurt animation
        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("7")}],\n')
        f.write('"loop": false, "name": &"human_hurt", "speed": 5.0\n')

        # Evil animations
        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("8")}],\n')
        f.write('"loop": true, "name": &"evil_idle", "speed": 5.0\n')

        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("9")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("10")}],\n')
        f.write('"loop": true, "name": &"evil_walk", "speed": 8.0\n')

        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("11")}],\n')
        f.write('"loop": false, "name": &"evil_jump", "speed": 5.0\n')

        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("11")}],\n')
        f.write('"loop": false, "name": &"evil_fall", "speed": 5.0\n')

        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("12")}, ')
        f.write('{"duration": 1.0, "texture": ExtResource("13")}],\n')
        f.write('"loop": false, "name": &"evil_attack", "speed": 12.0\n')

        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("14")}],\n')
        f.write('"loop": false, "name": &"evil_dodge", "speed": 5.0\n')

        f.write('}, {\n"frames": [{"duration": 1.0, "texture": ExtResource("14")}],\n')
        f.write('"loop": false, "name": &"evil_hurt", "speed": 5.0\n')

        f.write('}]\n')

    print("=" * 70)
    print("✅ 36프레임 점프 애니메이션 포함 player_frames.tres 생성 완료!")
    print("=" * 70)
    print(f"\n📂 생성된 파일: {output_file}")
    print("\n💡 사용 방법:")
    print("   1. 기존 player_frames.tres 백업")
    print("   2. player_frames_36.tres를 player_frames.tres로 이름 변경")
    print("   3. Godot에서 확인\n")
    print(f"📊 Jump animation: 36 frames @ 36 FPS = 1초 (매우 부드러움!)\n")

if __name__ == '__main__':
    generate_full_config()
