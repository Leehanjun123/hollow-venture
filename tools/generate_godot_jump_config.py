#!/usr/bin/env python3
"""
Godot player_frames.tres 파일에 36개 점프 프레임 설정 생성
"""

def generate_jump_config():
    """
    36개 점프 프레임을 위한 Godot 설정 생성
    """
    print("=" * 70)
    print("📝 Godot 점프 애니메이션 설정 생성 (36 프레임)")
    print("=" * 70)

    # ExtResource 섹션 생성
    print("\n## ExtResource 섹션 (player_frames.tres 상단에 추가):\n")
    for i in range(1, 37):
        print(f'[ext_resource type="Texture2D" path="res://assets/sprites/player/animations/human/jump/jump_frame_{i:03d}.png" id="3_jump_{i}"]')

    # Animation 프레임 섹션 생성
    print("\n\n## Animation 프레임 섹션 (human_jump 애니메이션):\n")
    print('"frames": [', end='')
    for i in range(1, 37):
        print('{\n"duration": 1.0,')
        print(f'"texture": ExtResource("3_jump_{i}")')
        if i < 36:
            print('}, ', end='')
        else:
            print('}')
    print('],')
    print('"loop": false,')
    print('"name": &"human_jump",')
    print('"speed": 36.0')

    print("\n" + "=" * 70)
    print("✅ 설정 생성 완료!")
    print("=" * 70)
    print("\n💡 사용 방법:")
    print("   1. ExtResource 섹션을 player_frames.tres 상단에 복사")
    print("   2. Animation 프레임 섹션을 human_jump 애니메이션에 복사")
    print("   3. Speed를 조절해서 원하는 속도로 설정 (36-45 권장)\n")

if __name__ == '__main__':
    generate_jump_config()
