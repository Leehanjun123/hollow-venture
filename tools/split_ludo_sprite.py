#!/usr/bin/env python3
"""
Ludo.ai 스프라이트 시트를 개별 프레임으로 분할
"""

from PIL import Image
from pathlib import Path

def split_ludo_sprite():
    """
    6x6 그리드 (36 프레임) 스프라이트 시트를 개별 프레임으로 분할
    """
    sprite_sheet_path = "/Users/leehanjun/Downloads/sprite-256px-36.png"
    output_dir = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human/jump")

    print("=" * 70)
    print("✂️  Ludo.ai 점프 스프라이트 시트 분할")
    print("=" * 70)

    # 스프라이트 시트 로드
    sprite_sheet = Image.open(sprite_sheet_path).convert('RGBA')
    sheet_width, sheet_height = sprite_sheet.size

    print(f"\n📁 입력: {sprite_sheet_path}")
    print(f"📁 출력: {output_dir}")
    print(f"📐 시트 크기: {sheet_width}x{sheet_height}")
    print(f"📊 그리드: 6행 x 6열")
    print(f"🎬 프레임 수: 36\n")

    # 각 프레임 크기 계산
    rows = 6
    cols = 6
    frame_width = sheet_width // cols
    frame_height = sheet_height // rows

    print(f"🖼️  각 프레임 크기: {frame_width}x{frame_height}\n")

    frame_num = 1

    # 행 우선 순서로 추출 (왼쪽 → 오른쪽, 위 → 아래)
    for row in range(rows):
        for col in range(cols):
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
            output_file = output_dir / f"jump_frame_{frame_num:03d}.png"
            centered_frame.save(output_file, 'PNG')

            print(f"   ✅ 프레임 {frame_num:2d}: 행{row+1} 열{col+1} → {output_file.name}")

            frame_num += 1

    print("\n" + "=" * 70)
    print(f"🎉 36개 프레임 추출 완료!")
    print("=" * 70)
    print(f"\n📂 결과: {output_dir}\n")

if __name__ == '__main__':
    split_ludo_sprite()
