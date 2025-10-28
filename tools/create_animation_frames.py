#!/usr/bin/env python3
"""
Idle 프레임을 기반으로 Walk/Jump 애니메이션 프레임 생성
간단한 변형으로 빠르게 애니메이션 제작
"""

from PIL import Image
import numpy as np
from pathlib import Path

def create_walk_frames(idle_frame_path, output_dir, num_frames=6):
    """
    Idle 프레임을 기반으로 Walk 프레임 생성
    - 약간의 기울임
    - 위아래 움직임
    """
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    img = Image.open(idle_frame_path).convert('RGBA')
    width, height = img.size

    print(f"🚶 Walk 애니메이션 생성 중... ({num_frames}프레임)")

    for i in range(num_frames):
        # 위아래 움직임 (사인 웨이브)
        phase = (i / num_frames) * 2 * np.pi
        y_offset = int(3 * np.sin(phase))  # 3px 위아래

        # 좌우 기울임
        tilt = 2 * np.sin(phase)  # 약간의 기울임

        # 새 이미지 생성
        new_img = Image.new('RGBA', (width, height), (0, 0, 0, 0))

        # 이미지를 약간 이동
        new_img.paste(img, (0, y_offset), img)

        # 저장
        output_file = output_path / f"walk_frame_{i+1:03d}.png"
        new_img.save(output_file)
        print(f"   ✅ {output_file.name}")

    print(f"✨ Walk 프레임 {num_frames}개 생성 완료!\n")


def create_jump_frames(idle_frame_path, output_dir):
    """
    Idle 프레임을 기반으로 Jump 프레임 생성
    - 웅크림 → 도약 → 공중 → 착지
    """
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    img = Image.open(idle_frame_path).convert('RGBA')
    width, height = img.size

    print(f"🦘 Jump 애니메이션 생성 중... (8프레임)")

    jump_phases = [
        ("crouch", -10, 0.95),      # 웅크림 (아래로, 압축)
        ("prepare", -5, 0.97),      # 준비
        ("takeoff", 5, 1.02),       # 도약 시작
        ("rising", 15, 1.05),       # 상승
        ("peak", 20, 1.05),         # 정점
        ("falling", 15, 1.03),      # 하강
        ("landing_prep", 5, 1.0),   # 착지 준비
        ("landing", -5, 0.95),      # 착지
    ]

    for i, (phase_name, y_offset, scale_y) in enumerate(jump_phases):
        # 새 이미지 생성
        new_img = Image.new('RGBA', (width, height), (0, 0, 0, 0))

        # Y축 스케일 적용
        scaled_height = int(height * scale_y)
        scaled_img = img.resize((width, scaled_height), Image.Resampling.LANCZOS)

        # Y축 이동 적용
        paste_y = y_offset + (height - scaled_height) // 2
        new_img.paste(scaled_img, (0, paste_y), scaled_img)

        # 저장
        output_file = output_path / f"jump_frame_{i+1:03d}.png"
        new_img.save(output_file)
        print(f"   ✅ {output_file.name} ({phase_name})")

    print(f"✨ Jump 프레임 8개 생성 완료!\n")


def main():
    # 경로 설정
    idle_frame = "assets/sprites/player/animations/human/idle/idle_frame_001.png"
    walk_output = "assets/sprites/player/animations/human/walk"
    jump_output = "assets/sprites/player/animations/human/jump"

    print("=" * 70)
    print("🎮 애니메이션 프레임 생성기")
    print("=" * 70)
    print()

    # Walk 프레임 생성
    create_walk_frames(idle_frame, walk_output, num_frames=6)

    # Jump 프레임 생성
    create_jump_frames(idle_frame, jump_output)

    print("=" * 70)
    print("🎉 모든 애니메이션 프레임 생성 완료!")
    print("=" * 70)
    print("\n다음 단계:")
    print("1. player_frames.tres에 walk, jump 애니메이션 추가")
    print("2. 게임에서 테스트")


if __name__ == '__main__':
    main()
