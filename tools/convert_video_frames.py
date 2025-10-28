#!/usr/bin/env python3
"""
비디오 프레임을 768x768 중앙 정렬로 변환
"""

from PIL import Image
from pathlib import Path
import shutil

def convert_video_frames():
    """
    영상에서 추출한 프레임을 768x768로 변환하고 jump 폴더로 복사
    """
    video_frames_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump_video_frames")
    jump_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump")

    print("=" * 70)
    print("🎬 비디오 프레임을 768x768로 변환")
    print("=" * 70)

    # 기존 jump 폴더 프레임 삭제
    for old_frame in jump_dir.glob("jump_frame_*.png"):
        old_frame.unlink()
    print("\n✅ 기존 프레임 삭제 완료\n")

    # 36개 프레임 변환
    for i in range(1, 37):
        video_frame_path = video_frames_dir / f"frame_{i:03d}.png"

        if not video_frame_path.exists():
            print(f"⚠️  프레임 {i} 없음: {video_frame_path}")
            continue

        # 프레임 로드
        img = Image.open(video_frame_path).convert('RGBA')

        # 768x768 캔버스 생성
        target_size = 768
        centered_frame = Image.new('RGBA', (target_size, target_size), (0, 0, 0, 0))

        # 중앙 위치 계산
        paste_x = (target_size - img.width) // 2
        paste_y = (target_size - img.height) // 2

        # 중앙에 붙여넣기
        centered_frame.paste(img, (paste_x, paste_y), img)

        # 저장
        output_path = jump_dir / f"jump_frame_{i:03d}.png"
        centered_frame.save(output_path, 'PNG')

        print(f"   ✅ 프레임 {i:2d}: {img.width}x{img.height} → 768x768 (중앙 정렬)")

    print("\n" + "=" * 70)
    print("🎉 36개 프레임 변환 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {jump_dir}\n")

if __name__ == '__main__':
    convert_video_frames()
