#!/usr/bin/env python3
"""
체크보드 패턴을 진짜 투명으로 변환하는 스크립트

사용법:
python3 remove_checkerboard.py <input_image.png> <output_image.png>

또는 폴더 전체:
python3 remove_checkerboard.py --folder <folder_path>
"""

from PIL import Image
import sys
import os
from pathlib import Path

def remove_checkerboard(input_path, output_path=None):
    """
    체크보드 패턴(회색/흰색)을 투명으로 변환
    """
    if output_path is None:
        output_path = input_path

    # 이미지 열기
    img = Image.open(input_path).convert("RGBA")
    pixels = img.load()
    width, height = img.size

    # 체크보드 색상 정의 (일반적인 체크보드 패턴)
    checkerboard_colors = [
        (204, 204, 204, 255),  # 밝은 회색
        (255, 255, 255, 255),  # 흰색
        (192, 192, 192, 255),  # 회색
        (128, 128, 128, 255),  # 어두운 회색
    ]

    # 픽셀별로 검사
    for y in range(height):
        for x in range(width):
            pixel = pixels[x, y]

            # 체크보드 색상이면 완전 투명으로
            if pixel[:3] in [c[:3] for c in checkerboard_colors]:
                pixels[x, y] = (0, 0, 0, 0)

    # 저장
    img.save(output_path, "PNG")
    print(f"✓ 변환 완료: {output_path}")

def process_folder(folder_path):
    """
    폴더 내 모든 PNG 파일 처리
    """
    folder = Path(folder_path)
    png_files = list(folder.glob("*.png"))

    if not png_files:
        print(f"❌ PNG 파일을 찾을 수 없습니다: {folder_path}")
        return

    print(f"📁 {len(png_files)}개 파일 처리 중...")
    for png_file in png_files:
        try:
            remove_checkerboard(png_file)
        except Exception as e:
            print(f"❌ 오류 ({png_file.name}): {e}")

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    if sys.argv[1] == "--folder":
        if len(sys.argv) < 3:
            print("❌ 폴더 경로를 지정하세요")
            sys.exit(1)
        process_folder(sys.argv[2])
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2] if len(sys.argv) > 2 else input_file

        if not os.path.exists(input_file):
            print(f"❌ 파일을 찾을 수 없습니다: {input_file}")
            sys.exit(1)

        remove_checkerboard(input_file, output_file)

if __name__ == "__main__":
    main()
