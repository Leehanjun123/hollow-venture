#!/usr/bin/env python3
"""
블렌딩 없이 6개 키프레임만으로 깔끔한 대칭 점프 애니메이션 생성
"""

from PIL import Image
from pathlib import Path
import shutil

def create_clean_jump():
    """
    6개 키프레임을 올바른 순서로 배치하여 대칭 점프 애니메이션 생성
    """
    downloads = Path("/Users/leehanjun/Downloads")
    jump_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump")

    print("=" * 70)
    print("🎬 깔끔한 대칭 점프 애니메이션 생성")
    print("=" * 70)

    # 기존 프레임 삭제
    for old_frame in jump_dir.glob("jump_frame_*.png"):
        old_frame.unlink()
    print("\n✅ 기존 프레임 삭제 완료\n")

    # 키프레임 순서 정의
    # 1. 준비 → 2. 크라우치 → 3. 이륙 → 4. 최고점 → 5. 하강 → 6. 착지
    jump_sequence = [
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo.png", "준비 자세"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (5).png", "크라우치 (힘 모으기)"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (1).png", "이륙 (상승)"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (3).png", "최고점"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (3).png", "최고점 유지"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (2).png", "하강"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (4).png", "착지"),
        (downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo.png", "착지 완료"),
    ]

    print("📋 점프 애니메이션 구조:")
    print("   준비 → 크라우치 → 이륙 → 최고점 → 하강 → 착지\n")

    # 프레임 생성
    for i, (source_path, description) in enumerate(jump_sequence, 1):
        img = Image.open(source_path).convert('RGBA')
        output_path = jump_dir / f"jump_frame_{i:03d}.png"
        img.save(output_path, 'PNG')
        print(f"   ✅ 프레임 {i}: {description:20s} → {output_path.name}")

    print("\n" + "=" * 70)
    print(f"🎉 {len(jump_sequence)}개 프레임 생성 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {jump_dir}")
    print(f"📊 구조: 대칭적 점프 (올라갔다 내려오기)\n")

if __name__ == '__main__':
    create_clean_jump()
