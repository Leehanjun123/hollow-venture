#!/usr/bin/env python3
"""
프레임 배경 제거 스크립트

사용법:
    python remove_background.py assets/sprites/extracted/human_idle/

필요 패키지:
    pip install rembg pillow
"""

import argparse
from pathlib import Path
from PIL import Image
import sys

def remove_bg_with_rembg(input_path, output_path):
    """rembg를 사용한 배경 제거"""
    try:
        from rembg import remove

        with open(input_path, 'rb') as input_file:
            input_data = input_file.read()
            output_data = remove(input_data)

        with open(output_path, 'wb') as output_file:
            output_file.write(output_data)

        return True
    except ImportError:
        return False
    except Exception as e:
        print(f"⚠️  오류: {e}")
        return False

def remove_bg_with_threshold(input_path, output_path, threshold=240):
    """
    간단한 임계값 기반 배경 제거
    (흰색/밝은 배경용)
    """
    try:
        img = Image.open(input_path).convert('RGBA')
        datas = img.getdata()

        new_data = []
        for item in datas:
            # 밝은 픽셀을 투명하게
            if item[0] > threshold and item[1] > threshold and item[2] > threshold:
                new_data.append((255, 255, 255, 0))
            else:
                new_data.append(item)

        img.putdata(new_data)
        img.save(output_path, "PNG")
        return True
    except Exception as e:
        print(f"⚠️  오류: {e}")
        return False

def process_directory(input_dir, output_dir=None, method='rembg'):
    """디렉토리 내 모든 이미지 처리"""
    input_dir = Path(input_dir)

    if not input_dir.exists():
        print(f"❌ 디렉토리가 없습니다: {input_dir}")
        return False

    if output_dir is None:
        output_dir = input_dir.parent / f"{input_dir.name}_nobg"
    else:
        output_dir = Path(output_dir)

    output_dir.mkdir(parents=True, exist_ok=True)

    # PNG 파일 찾기
    image_files = list(input_dir.glob("*.png"))

    if not image_files:
        print(f"❌ PNG 파일이 없습니다: {input_dir}")
        return False

    print(f"📁 입력: {input_dir}")
    print(f"📁 출력: {output_dir}")
    print(f"📊 파일 수: {len(image_files)}")
    print(f"⚙️  방법: {method}")
    print()

    success_count = 0

    for i, img_file in enumerate(image_files, 1):
        output_file = output_dir / img_file.name

        print(f"[{i}/{len(image_files)}] 처리 중: {img_file.name}...", end=' ')

        if method == 'rembg':
            success = remove_bg_with_rembg(img_file, output_file)
        else:
            success = remove_bg_with_threshold(img_file, output_file)

        if success:
            print("✅")
            success_count += 1
        else:
            print("❌")

    print()
    print(f"✅ {success_count}/{len(image_files)} 파일 처리 완료!")
    return True

def main():
    parser = argparse.ArgumentParser(description='스프라이트 프레임 배경 제거')
    parser.add_argument('input_dir', help='입력 디렉토리 (프레임 이미지들)')
    parser.add_argument('--output', type=str, default=None,
                        help='출력 디렉토리 (기본값: [input]_nobg)')
    parser.add_argument('--method', choices=['rembg', 'threshold'], default='rembg',
                        help='배경 제거 방법 (기본값: rembg)')

    args = parser.parse_args()

    print("=" * 70)
    print("🎨 스프라이트 배경 제거")
    print("=" * 70)
    print()

    # rembg 확인
    if args.method == 'rembg':
        try:
            import rembg
        except ImportError:
            print("❌ rembg가 설치되어 있지 않습니다.")
            print()
            print("설치 방법:")
            print("  pip install rembg")
            print()
            print("또는 간단한 방법 사용:")
            print("  python remove_background.py [dir] --method threshold")
            sys.exit(1)

    success = process_directory(
        args.input_dir,
        args.output,
        method=args.method
    )

    if success:
        print()
        print("=" * 70)
        print("🎉 완료!")
        print("=" * 70)

if __name__ == "__main__":
    main()
