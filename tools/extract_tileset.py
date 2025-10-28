#!/usr/bin/env python3
"""
타일셋 이미지를 분리하고 재조합하는 스크립트

사용법:
python3 extract_tileset.py <input_image.png> <output_tileset.png>
"""

from PIL import Image
import sys

def extract_and_rebuild_tileset(input_path, output_path, target_rows=3):
    """
    타일셋 이미지를 분리하고 상위 N행만 사용해서 재조합

    Args:
        input_path: 입력 이미지 경로
        output_path: 출력 타일셋 경로
        target_rows: 사용할 행 수 (기본 3)
    """
    img = Image.open(input_path)
    width, height = img.size

    print(f"📐 입력 이미지 크기: {width}×{height}")

    # 타일 크기 감지 (32x32 가정)
    tile_size = 32
    cols = width // tile_size
    rows = height // tile_size

    print(f"📊 감지된 그리드: {cols}열 × {rows}행")
    print(f"🎯 타일 크기: {tile_size}×{tile_size}")
    print(f"🔢 총 타일 수: {cols * rows}개")

    # 6열인지 확인
    if cols != 6:
        print(f"⚠️  경고: 6열이 아닙니다. 그대로 진행...")

    # 상위 target_rows 행만 추출
    if rows < target_rows:
        print(f"❌ 오류: {target_rows}행이 필요하지만 {rows}행만 있습니다.")
        sys.exit(1)

    # 새 이미지 생성 (6열 × target_rows행)
    new_width = cols * tile_size
    new_height = target_rows * tile_size
    new_img = Image.new("RGBA", (new_width, new_height), (0, 0, 0, 0))

    print(f"\n✂️  상위 {target_rows}행 추출 중...")

    # 타일 복사
    for row in range(target_rows):
        for col in range(cols):
            # 타일 영역 계산
            left = col * tile_size
            top = row * tile_size
            right = left + tile_size
            bottom = top + tile_size

            # 타일 추출
            tile = img.crop((left, top, right, bottom))

            # 새 이미지에 붙이기
            new_img.paste(tile, (left, top))

            print(f"  ✓ 타일 [{row},{col}] 추출")

    # 저장
    new_img.save(output_path, "PNG")

    print(f"\n✅ 완성!")
    print(f"📦 출력: {output_path}")
    print(f"📐 크기: {new_width}×{new_height}")
    print(f"🎯 타일셋: {cols}열 × {target_rows}행 = {cols * target_rows}개 타일")

def main():
    if len(sys.argv) < 3:
        print(__doc__)
        print("\n예시:")
        print("  python3 extract_tileset.py input.png output_tileset.png")
        print("  python3 extract_tileset.py input.png output.png 3")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    target_rows = int(sys.argv[3]) if len(sys.argv) > 3 else 3

    extract_and_rebuild_tileset(input_file, output_file, target_rows)

if __name__ == "__main__":
    main()
