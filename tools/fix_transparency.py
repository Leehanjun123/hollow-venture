#!/usr/bin/env python3
"""
체크보드/배경을 진짜 투명으로 변환 (개선 버전)

사용법:
python3 fix_transparency.py <이미지.png>
python3 fix_transparency.py --folder <폴더경로>
"""

from PIL import Image
import numpy as np
import sys
from pathlib import Path

def is_checkerboard_color(r, g, b):
    """
    체크보드 패턴 색상인지 확인
    """
    # 회색/흰색 범위 (밝기 180~255, 채도 낮음)
    brightness = (r + g + b) / 3
    saturation = max(r, g, b) - min(r, g, b)

    return brightness > 180 and saturation < 30

def fix_transparency(input_path, output_path=None):
    """
    배경/체크보드를 투명으로 변환
    """
    if output_path is None:
        output_path = input_path

    img = Image.open(input_path).convert("RGBA")
    data = np.array(img)

    # RGB 분리
    red = data[:,:,0]
    green = data[:,:,1]
    blue = data[:,:,2]
    alpha = data[:,:,3]

    # 체크보드 마스크 생성
    brightness = (red.astype(float) + green + blue) / 3
    saturation = np.maximum(red, np.maximum(green, blue)) - np.minimum(red, np.minimum(green, blue))

    # 밝고 채도 낮은 픽셀 = 체크보드
    checkerboard_mask = (brightness > 180) & (saturation < 30)

    # 해당 픽셀의 알파를 0으로
    alpha[checkerboard_mask] = 0

    # 데이터 합치기
    data[:,:,3] = alpha

    # 저장
    result = Image.fromarray(data, mode="RGBA")
    result.save(output_path, "PNG")

    # 통계
    transparent_before = np.sum(data[:,:,3] == 0)
    print(f"✓ {Path(input_path).name}: {np.sum(checkerboard_mask)} 픽셀 투명화")

def process_folder(folder_path):
    """폴더 내 모든 PNG 처리"""
    folder = Path(folder_path)
    png_files = list(folder.glob("*.png"))

    if not png_files:
        print(f"❌ PNG 파일 없음: {folder_path}")
        return

    print(f"\n📁 {len(png_files)}개 파일 처리 중...\n")
    for png_file in png_files:
        try:
            fix_transparency(png_file)
        except Exception as e:
            print(f"❌ {png_file.name}: {e}")

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    if sys.argv[1] == "--folder":
        process_folder(sys.argv[2])
    else:
        fix_transparency(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)

if __name__ == "__main__":
    main()
