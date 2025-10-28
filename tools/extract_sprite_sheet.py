#!/usr/bin/env python3
"""
스프라이트 시트에서 개별 프레임 추출
Dark Knight Walk 스프라이트 시트 → 개별 PNG 프레임
"""

from PIL import Image
from pathlib import Path

def extract_walk_frames(sprite_sheet_path, output_dir, row=2, num_frames=9):
    """
    스프라이트 시트에서 Walk 프레임 추출

    Args:
        sprite_sheet_path: 스프라이트 시트 이미지 경로
        output_dir: 출력 디렉토리
        row: 추출할 행 (0부터 시작, 2 = 세 번째 줄 = 오른쪽 측면)
        num_frames: 추출할 프레임 수
    """
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    img = Image.open(sprite_sheet_path)
    width, height = img.size

    print("=" * 70)
    print("🎬 Dark Knight Walk 프레임 추출")
    print("=" * 70)
    print(f"\n📁 입력: {sprite_sheet_path}")
    print(f"📁 출력: {output_path}")
    print(f"📐 시트 크기: {width}x{height}px\n")

    # 그리드 계산 (대략 9x5 그리드)
    cols = 9
    rows = 5
    frame_width = width // cols
    frame_height = height // rows

    print(f"🔲 프레임 크기: {frame_width}x{frame_height}px")
    print(f"📊 그리드: {cols}x{rows}")
    print(f"🎯 추출 행: {row} (측면 뷰)\n")

    extracted = 0

    for col in range(num_frames):
        # 프레임 좌표 계산
        left = col * frame_width
        top = row * frame_height
        right = left + frame_width
        bottom = top + frame_height

        # 프레임 잘라내기
        frame = img.crop((left, top, right, bottom))

        # 투명도 확인 (빈 프레임 건너뛰기)
        bbox = frame.getbbox()
        if bbox is None:
            print(f"   ⏭️  Frame {col+1}: 빈 프레임 (건너뜀)")
            continue

        # 저장
        output_file = output_path / f"walk_frame_{extracted+1:03d}.png"
        frame.save(output_file, 'PNG')
        extracted += 1

        print(f"   ✅ Frame {extracted}: {output_file.name}")

    print("\n" + "=" * 70)
    print(f"🎉 {extracted}개 Walk 프레임 추출 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {output_path}\n")

    return extracted


def main():
    sprite_sheet = Path.home() / "Downloads/dark-knight/Knight 2D/Sprites/Walk.png"
    output_dir = "assets/sprites/player/animations/human/walk"

    if not sprite_sheet.exists():
        print(f"❌ 스프라이트 시트를 찾을 수 없습니다: {sprite_sheet}")
        return

    # 측면 뷰 (row=2, 세 번째 줄)
    extract_walk_frames(sprite_sheet, output_dir, row=2, num_frames=9)


if __name__ == '__main__':
    main()
