#!/usr/bin/env python3
"""
배경 모자이크 처리 스크립트
추출된 프레임의 배경을 모자이크 처리하여 캐릭터만 강조
"""

import sys
from pathlib import Path
from PIL import Image, ImageFilter
import argparse

def apply_mosaic(image_path, output_path, mosaic_size=10, blur_strength=5):
    """
    이미지에 모자이크 효과 적용

    Args:
        image_path: 입력 이미지 경로
        output_path: 출력 이미지 경로
        mosaic_size: 모자이크 블록 크기 (작을수록 세밀)
        blur_strength: 블러 강도 (0이면 블러 없음)
    """
    img = Image.open(image_path).convert('RGBA')
    width, height = img.size

    # 1단계: 이미지 축소 (모자이크 효과)
    small_width = max(1, width // mosaic_size)
    small_height = max(1, height // mosaic_size)
    small_img = img.resize((small_width, small_height), Image.NEAREST)

    # 2단계: 원본 크기로 확대 (픽셀화)
    mosaic_img = small_img.resize((width, height), Image.NEAREST)

    # 3단계: 약간의 블러 추가 (선택사항)
    if blur_strength > 0:
        mosaic_img = mosaic_img.filter(ImageFilter.GaussianBlur(blur_strength))

    # 저장
    mosaic_img.save(output_path, 'PNG')
    return output_path


def process_directory(input_dir, output_dir=None, mosaic_size=10, blur_strength=5):
    """
    디렉토리의 모든 PNG 파일 처리

    Args:
        input_dir: 입력 디렉토리
        output_dir: 출력 디렉토리 (None이면 _mosaic 폴더 생성)
        mosaic_size: 모자이크 블록 크기
        blur_strength: 블러 강도
    """
    input_path = Path(input_dir)

    if output_dir is None:
        output_path = input_path.parent / f"{input_path.name}_mosaic"
    else:
        output_path = Path(output_dir)

    output_path.mkdir(parents=True, exist_ok=True)

    png_files = sorted(input_path.glob('*.png'))

    if not png_files:
        print(f"❌ {input_dir}에 PNG 파일이 없습니다.")
        return

    print("=" * 70)
    print("🎨 배경 모자이크 처리")
    print("=" * 70)
    print(f"\n📁 입력 폴더: {input_path}")
    print(f"📁 출력 폴더: {output_path}")
    print(f"🔲 모자이크 크기: {mosaic_size}px")
    print(f"🌫️  블러 강도: {blur_strength}")
    print(f"📊 처리할 파일: {len(png_files)}개\n")

    for i, png_file in enumerate(png_files, 1):
        output_file = output_path / png_file.name
        apply_mosaic(png_file, output_file, mosaic_size, blur_strength)
        print(f"   {i:2d}. {png_file.name} → {output_file.name}")

    print("\n" + "=" * 70)
    print(f"🎉 완료! {len(png_files)}개 파일 처리됨")
    print("=" * 70)
    print(f"\n📂 결과 확인: {output_path}\n")


def main():
    parser = argparse.ArgumentParser(
        description='프레임 이미지 배경 모자이크 처리',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
사용 예시:
  # Walk 프레임 모자이크 처리 (기본값)
  python mosaic_background.py assets/sprites/extracted/walk

  # Jump 프레임 모자이크 처리 (강한 모자이크)
  python mosaic_background.py assets/sprites/extracted/jump --mosaic-size 15

  # 모자이크만 적용 (블러 없음)
  python mosaic_background.py assets/sprites/extracted/walk --blur 0

  # 출력 폴더 직접 지정
  python mosaic_background.py assets/sprites/extracted/walk -o output/walk_mosaic
        """
    )

    parser.add_argument('input_dir', help='입력 디렉토리 경로')
    parser.add_argument('-o', '--output', help='출력 디렉토리 (지정 안하면 자동 생성)')
    parser.add_argument('-m', '--mosaic-size', type=int, default=10,
                        help='모자이크 블록 크기 (기본값: 10, 클수록 더 흐림)')
    parser.add_argument('-b', '--blur', type=int, default=5,
                        help='블러 강도 (기본값: 5, 0이면 블러 없음)')

    args = parser.parse_args()

    process_directory(
        args.input_dir,
        args.output,
        args.mosaic_size,
        args.blur
    )


if __name__ == '__main__':
    main()
