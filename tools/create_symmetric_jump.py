#!/usr/bin/env python3
"""
완전 대칭 점프 애니메이션 생성
올라가는 프레임(1-2-3-4)을 역순(3-2-1)으로 사용해서 내려오기
"""

from PIL import Image
from pathlib import Path
import shutil

def create_symmetric_jump():
    """
    대칭 구조: 1 → 2 → 3 → 4 → 4 → 3 → 2 → 1
    """
    downloads = Path("/Users/leehanjun/Downloads")
    jump_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump")

    print("=" * 70)
    print("🔄 완전 대칭 점프 애니메이션 생성")
    print("=" * 70)

    # 기존 프레임 삭제
    for old_frame in jump_dir.glob("jump_frame_*.png"):
        old_frame.unlink()
    print("\n✅ 기존 프레임 삭제 완료\n")

    # 키프레임 정의
    frame1 = Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo.png").convert('RGBA')  # 준비
    frame2 = Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (5).png").convert('RGBA')  # 크라우치
    frame3 = Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (1).png").convert('RGBA')  # 이륙
    frame4 = Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (3).png").convert('RGBA')  # 최고점

    # 대칭 구조: 올라가기(1-2-3-4) → 최고점 유지 → 내려오기(3-2-1)
    symmetric_sequence = [
        (frame1, "준비 자세"),
        (frame2, "크라우치 (힘 모으기)"),
        (frame3, "이륙 (상승)"),
        (frame4, "최고점"),
        (frame4, "최고점 유지"),
        (frame3, "하강 (이륙 역순)"),
        (frame2, "착지 준비 (크라우치 역순)"),
        (frame1, "착지 완료 (준비 역순)"),
    ]

    print("📋 대칭 점프 애니메이션 구조:")
    print("   1 → 2 → 3 → 4 → 4 → 3 → 2 → 1")
    print("   (올라가기 → 최고점 → 내려오기는 올라가기의 역순)\n")

    # 프레임 생성
    for i, (img, description) in enumerate(symmetric_sequence, 1):
        output_path = jump_dir / f"jump_frame_{i:03d}.png"
        img.save(output_path, 'PNG')
        print(f"   ✅ 프레임 {i}: {description:25s} → {output_path.name}")

    print("\n" + "=" * 70)
    print(f"🎉 {len(symmetric_sequence)}개 프레임 대칭 구조로 생성 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {jump_dir}")
    print(f"📊 구조: 완전 대칭 (올라갔다 내려오기)\n")

if __name__ == '__main__':
    create_symmetric_jump()
