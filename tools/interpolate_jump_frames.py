#!/usr/bin/env python3
"""
6개 키프레임을 12개 프레임으로 보간
"""

from PIL import Image
from pathlib import Path

def blend_images(img1, img2, alpha=0.5):
    """
    두 이미지를 블렌딩하여 중간 프레임 생성
    alpha=0.5면 정확히 중간
    """
    return Image.blend(img1, img2, alpha)

def create_jump_animation():
    """
    6개 키프레임 사이에 중간 프레임을 추가하여 12프레임 생성
    """
    downloads = Path("/Users/leehanjun/Downloads")
    output_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump")
    output_dir.mkdir(parents=True, exist_ok=True)

    print("=" * 70)
    print("🎬 점프 애니메이션 생성: 6 키프레임 → 12 프레임")
    print("=" * 70)

    # 키프레임 로드 (올바른 순서로)
    keyframes = {
        'prepare': Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo.png").convert('RGBA'),
        'crouch': Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (5).png").convert('RGBA'),
        'takeoff': Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (1).png").convert('RGBA'),
        'peak': Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (3).png").convert('RGBA'),
        'descend': Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (2).png").convert('RGBA'),
        'land': Image.open(downloads / "Gemini_Generated_Image_wgdohxwgdohxwgdo (4).png").convert('RGBA'),
    }

    print(f"\n✅ 6개 키프레임 로드 완료")
    print(f"   - 준비 자세 (prepare)")
    print(f"   - 크라우치 (crouch)")
    print(f"   - 이륙 (takeoff)")
    print(f"   - 최고점 (peak)")
    print(f"   - 하강 (descend)")
    print(f"   - 착지 (land)\n")

    # 12프레임 구성
    # 각 키프레임 사이에 중간 프레임 추가
    frames = []

    # 1-2: 준비 → 크라우치
    frames.append(('prepare', keyframes['prepare']))
    frames.append(('prepare→crouch', blend_images(keyframes['prepare'], keyframes['crouch'])))

    # 3-4: 크라우치 → 이륙
    frames.append(('crouch', keyframes['crouch']))
    frames.append(('crouch→takeoff', blend_images(keyframes['crouch'], keyframes['takeoff'])))

    # 5-6: 이륙 → 최고점
    frames.append(('takeoff', keyframes['takeoff']))
    frames.append(('takeoff→peak', blend_images(keyframes['takeoff'], keyframes['peak'])))

    # 7-8: 최고점 (정점에서 잠시 유지)
    frames.append(('peak', keyframes['peak']))
    frames.append(('peak hold', keyframes['peak']))

    # 9-10: 최고점 → 하강
    frames.append(('peak→descend', blend_images(keyframes['peak'], keyframes['descend'])))
    frames.append(('descend', keyframes['descend']))

    # 11-12: 하강 → 착지
    frames.append(('descend→land', blend_images(keyframes['descend'], keyframes['land'])))
    frames.append(('land', keyframes['land']))

    # 프레임 저장
    print("💾 프레임 저장 중...\n")
    for i, (name, frame) in enumerate(frames, 1):
        output_path = output_dir / f"jump_frame_{i:03d}.png"
        frame.save(output_path, 'PNG')
        print(f"   ✅ 프레임 {i:2d}: {name:20s} → {output_path.name}")

    print("\n" + "=" * 70)
    print(f"🎉 12개 프레임 생성 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {output_dir}\n")

if __name__ == '__main__':
    create_jump_animation()
