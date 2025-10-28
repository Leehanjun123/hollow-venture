#!/usr/bin/env python3
"""
스프라이트 시트를 개별 프레임으로 분할
"""

from PIL import Image
import numpy as np
from pathlib import Path

def split_sprite_sheet(sprite_sheet_path, output_dir, rows=3, cols=4, frame_count=12):
    """
    스프라이트 시트를 개별 프레임으로 분할

    Args:
        sprite_sheet_path: 스프라이트 시트 이미지 경로
        output_dir: 출력 디렉토리
        rows: 행 수
        cols: 열 수
        frame_count: 총 프레임 수
    """
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # 스프라이트 시트 로드
    sprite_sheet = Image.open(sprite_sheet_path).convert('RGBA')
    sheet_width, sheet_height = sprite_sheet.size

    print("=" * 70)
    print("✂️  스프라이트 시트 분할")
    print("=" * 70)
    print(f"\n📁 입력: {sprite_sheet_path}")
    print(f"📁 출력: {output_path}")
    print(f"📐 시트 크기: {sheet_width}x{sheet_height}")
    print(f"📊 그리드: {rows}행 x {cols}열")
    print(f"🎬 프레임 수: {frame_count}\n")

    # 각 프레임의 크기 계산
    frame_width = sheet_width // cols
    frame_height = sheet_height // rows

    print(f"🖼️  각 프레임 크기: {frame_width}x{frame_height}\n")

    frame_num = 1

    # 행 우선 순서로 추출 (왼쪽 → 오른쪽, 위 → 아래)
    for row in range(rows):
        for col in range(cols):
            if frame_num > frame_count:
                break

            # 프레임 영역 계산
            left = col * frame_width
            top = row * frame_height
            right = left + frame_width
            bottom = top + frame_height

            # 프레임 추출
            frame = sprite_sheet.crop((left, top, right, bottom))

            # 768x768 크기로 중앙 정렬
            target_size = 768
            centered_frame = Image.new('RGBA', (target_size, target_size), (0, 0, 0, 0))

            # 중앙 위치 계산
            paste_x = (target_size - frame_width) // 2
            paste_y = (target_size - frame_height) // 2

            # 중앙에 붙여넣기
            centered_frame.paste(frame, (paste_x, paste_y), frame)

            # 저장
            output_file = output_path / f"jump_frame_{frame_num:03d}.png"
            centered_frame.save(output_file, 'PNG')

            print(f"   ✅ 프레임 {frame_num:2d}: 행{row+1} 열{col+1} → {output_file.name}")

            frame_num += 1

    print("\n" + "=" * 70)
    print(f"🎉 {frame_count}개 프레임 추출 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {output_path}\n")


def main():
    # 스프라이트 시트 경로
    sprite_sheet = "/Users/leehanjun/Desktop/money/hollow-venture/tools/Gemini_Generated_Image_7wkx8b7wkx8b7wkx.png"
    output_dir = "/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump_temp"

    split_sprite_sheet(sprite_sheet, output_dir, rows=3, cols=4, frame_count=12)


if __name__ == '__main__':
    main()
