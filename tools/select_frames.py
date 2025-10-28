#!/usr/bin/env python3
"""
특정 프레임만 선별하여 복사하는 스크립트
오른쪽 이동 프레임만 선택하거나, 원하는 프레임만 골라낼 때 사용
"""

import sys
import shutil
from pathlib import Path
import argparse

def select_frames(input_dir, output_dir, frame_numbers, animation_name="anim"):
    """
    특정 번호의 프레임만 선별하여 복사

    Args:
        input_dir: 입력 디렉토리
        output_dir: 출력 디렉토리
        frame_numbers: 선택할 프레임 번호 리스트 (예: [1,2,3,8,9,10])
        animation_name: 애니메이션 이름 (walk, jump 등)
    """
    input_path = Path(input_dir)
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    print("=" * 70)
    print("🎯 프레임 선별 복사")
    print("=" * 70)
    print(f"\n📁 입력 폴더: {input_path}")
    print(f"📁 출력 폴더: {output_path}")
    print(f"🎬 애니메이션: {animation_name}")
    print(f"📊 선택된 프레임: {frame_numbers}\n")

    selected_files = []

    for new_index, frame_num in enumerate(frame_numbers, 1):
        # 원본 파일명 (001, 002 형식)
        original_file = input_path / f"{animation_name}_frame_{frame_num:03d}.png"

        if not original_file.exists():
            print(f"⚠️  프레임 {frame_num:03d}를 찾을 수 없습니다: {original_file}")
            continue

        # 새 파일명 (순차적으로 001부터 다시 시작)
        new_file = output_path / f"{animation_name}_frame_{new_index:03d}.png"

        # 복사
        shutil.copy2(original_file, new_file)
        selected_files.append((frame_num, new_index))
        print(f"   ✅ Frame {frame_num:03d} → {new_index:03d}")

    print("\n" + "=" * 70)
    print(f"🎉 완료! {len(selected_files)}개 프레임 선별됨")
    print("=" * 70)
    print(f"\n📂 결과 확인: {output_path}\n")

    return selected_files


def parse_frame_range(range_str):
    """
    프레임 범위 문자열 파싱
    예: "1-5,8,10-12" → [1,2,3,4,5,8,10,11,12]
    """
    frame_numbers = []

    for part in range_str.split(','):
        part = part.strip()
        if '-' in part:
            # 범위 (예: 1-5)
            start, end = part.split('-')
            frame_numbers.extend(range(int(start), int(end) + 1))
        else:
            # 단일 번호
            frame_numbers.append(int(part))

    return sorted(set(frame_numbers))  # 중복 제거 및 정렬


def main():
    parser = argparse.ArgumentParser(
        description='특정 프레임만 선별하여 복사',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
사용 예시:
  # Walk 프레임에서 1-3번만 선택
  python select_frames.py assets/sprites/extracted/walk -f "1-3" -n walk

  # Walk 프레임에서 1,2,3,8,9,10번 선택
  python select_frames.py assets/sprites/extracted/walk -f "1-3,8-10" -n walk

  # 출력 폴더 직접 지정
  python select_frames.py assets/sprites/extracted/walk -f "1-6" -o output/walk_right -n walk
        """
    )

    parser.add_argument('input_dir', help='입력 디렉토리 경로')
    parser.add_argument('-f', '--frames', required=True,
                        help='선택할 프레임 번호 (예: "1-3,8-10" 또는 "1,2,3")')
    parser.add_argument('-o', '--output', help='출력 디렉토리 (지정 안하면 _selected 폴더 생성)')
    parser.add_argument('-n', '--name', default='anim',
                        help='애니메이션 이름 (기본값: anim)')

    args = parser.parse_args()

    # 출력 디렉토리 설정
    if args.output is None:
        input_path = Path(args.input_dir)
        output_dir = input_path.parent / f"{input_path.name}_selected"
    else:
        output_dir = args.output

    # 프레임 번호 파싱
    frame_numbers = parse_frame_range(args.frames)

    # 프레임 선별
    select_frames(args.input_dir, output_dir, frame_numbers, args.name)


if __name__ == '__main__':
    main()
