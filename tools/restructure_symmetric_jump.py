#!/usr/bin/env python3
"""
대칭적인 점프 애니메이션 생성
올라가는 프레임을 역순으로 사용해서 내려오는 동작 만들기
"""

from PIL import Image
from pathlib import Path
import shutil

def create_symmetric_jump():
    """
    점프 애니메이션을 대칭 구조로 재구성
    상승 (1-2-3-4-5-6) → 최고점 (7) → 하강 (6-5-4-3-2-1)
    """
    jump_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump")
    temp_dir = jump_dir.parent / "jump_symmetric_temp"
    temp_dir.mkdir(exist_ok=True)

    print("=" * 70)
    print("🔄 대칭 점프 애니메이션 생성")
    print("=" * 70)

    # 기존 12프레임 로드
    original_frames = []
    for i in range(1, 13):
        frame_path = jump_dir / f"jump_frame_{i:03d}.png"
        if frame_path.exists():
            original_frames.append(Image.open(frame_path).convert('RGBA'))

    print(f"\n✅ {len(original_frames)}개 원본 프레임 로드 완료\n")

    # 대칭 구조 생성
    # 상승: 1, 2, 3, 4, 5, 6
    # 최고점: 7, 7 (정점에서 잠시 유지)
    # 하강: 6, 5, 4, 3, 2, 1 (역순)

    symmetric_sequence = [
        (1, "준비"),
        (2, "크라우치 시작"),
        (3, "크라우치"),
        (4, "이륙 준비"),
        (5, "이륙"),
        (6, "상승"),
        (7, "최고점"),
        (7, "최고점 유지"),
        (6, "하강 시작"),
        (5, "하강"),
        (4, "착지 준비"),
        (3, "착지"),
        (2, "착지 완료"),
        (1, "대기"),
    ]

    print("📋 대칭 애니메이션 구조:")
    print("   상승 → 최고점 → 하강 (역순)\n")

    # 새로운 프레임 생성
    for i, (frame_idx, description) in enumerate(symmetric_sequence, 1):
        frame = original_frames[frame_idx - 1]  # 0-based index
        output_path = temp_dir / f"jump_frame_{i:03d}.png"
        frame.save(output_path, 'PNG')
        print(f"   ✅ 프레임 {i:2d}: [원본 {frame_idx}] {description:15s} → {output_path.name}")

    print(f"\n🔄 기존 프레임 백업 및 교체 중...\n")

    # 기존 프레임 삭제
    for old_frame in jump_dir.glob("jump_frame_*.png"):
        old_frame.unlink()

    # 새 프레임 복사
    for new_frame in temp_dir.glob("jump_frame_*.png"):
        shutil.copy(new_frame, jump_dir / new_frame.name)

    # 임시 폴더 삭제
    shutil.rmtree(temp_dir)

    print("=" * 70)
    print(f"🎉 {len(symmetric_sequence)}개 프레임 대칭 구조로 재구성 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {jump_dir}")
    print(f"📊 구조: 준비 → 상승 → 최고점 → 하강(역순) → 착지\n")

if __name__ == '__main__':
    create_symmetric_jump()
