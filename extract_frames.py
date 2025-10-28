#!/usr/bin/env python3
"""
동영상에서 프레임 추출 스크립트

사용법:
    python extract_frames.py tools/videos/human/human_idle.mp4 --fps 12 --frames 4

    --fps: 초당 프레임 수 (기본값: 12)
    --frames: 추출할 프레임 수 (기본값: 전체)
"""

import subprocess
import argparse
from pathlib import Path
import sys

def check_ffmpeg():
    """FFmpeg 설치 확인"""
    try:
        result = subprocess.run(['ffmpeg', '-version'],
                                capture_output=True,
                                text=True)
        return result.returncode == 0
    except FileNotFoundError:
        return False

def extract_frames(video_path, output_dir, fps=12, max_frames=None):
    """
    동영상에서 프레임 추출

    Args:
        video_path: 입력 동영상 경로
        output_dir: 출력 디렉토리
        fps: 초당 프레임 수
        max_frames: 최대 프레임 수 (None이면 전체)
    """
    video_path = Path(video_path)
    output_dir = Path(output_dir)

    if not video_path.exists():
        print(f"❌ 동영상 파일이 없습니다: {video_path}")
        return False

    output_dir.mkdir(parents=True, exist_ok=True)

    # 출력 파일명 패턴
    output_pattern = output_dir / f"{video_path.stem}_frame_%03d.png"

    print(f"🎬 동영상: {video_path.name}")
    print(f"📁 출력 폴더: {output_dir}")
    print(f"⚙️  FPS: {fps}")
    if max_frames:
        print(f"📊 최대 프레임: {max_frames}")
    print()

    # FFmpeg 명령어 구성
    cmd = [
        'ffmpeg',
        '-i', str(video_path),
        '-vf', f'fps={fps}',  # FPS 설정
        '-start_number', '1',  # 1부터 시작
    ]

    if max_frames:
        cmd.extend(['-frames:v', str(max_frames)])

    cmd.append(str(output_pattern))

    # 실행
    print("🔄 프레임 추출 중...")
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)

        if result.returncode == 0:
            # 생성된 파일 확인
            extracted_files = sorted(output_dir.glob(f"{video_path.stem}_frame_*.png"))
            print(f"✅ {len(extracted_files)}개 프레임 추출 완료!")
            print()
            print("📋 생성된 파일:")
            for i, file in enumerate(extracted_files[:10], 1):  # 처음 10개만 표시
                print(f"   {i}. {file.name}")
            if len(extracted_files) > 10:
                print(f"   ... 외 {len(extracted_files) - 10}개")
            return True
        else:
            print(f"❌ FFmpeg 오류:")
            print(result.stderr)
            return False

    except Exception as e:
        print(f"❌ 오류 발생: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='동영상에서 게임 스프라이트 프레임 추출')
    parser.add_argument('video', help='입력 동영상 파일 경로')
    parser.add_argument('--fps', type=int, default=12,
                        help='초당 프레임 수 (기본값: 12)')
    parser.add_argument('--frames', type=int, default=None,
                        help='추출할 최대 프레임 수 (기본값: 전체)')
    parser.add_argument('--output', type=str, default=None,
                        help='출력 디렉토리 (기본값: assets/sprites/extracted/)')

    args = parser.parse_args()

    print("=" * 70)
    print("🎮 동영상 → 스프라이트 프레임 추출기")
    print("=" * 70)
    print()

    # FFmpeg 확인
    if not check_ffmpeg():
        print("❌ FFmpeg가 설치되어 있지 않습니다.")
        print()
        print("설치 방법:")
        print("  macOS: brew install ffmpeg")
        print("  Linux: sudo apt install ffmpeg")
        print("  Windows: https://ffmpeg.org/download.html")
        sys.exit(1)

    # 출력 디렉토리 결정
    if args.output:
        output_dir = Path(args.output)
    else:
        video_name = Path(args.video).stem
        output_dir = Path(f"assets/sprites/extracted/{video_name}")

    # 프레임 추출
    success = extract_frames(
        args.video,
        output_dir,
        fps=args.fps,
        max_frames=args.frames
    )

    if success:
        print()
        print("=" * 70)
        print("🎉 완료! 다음 단계:")
        print("=" * 70)
        print()
        print("1. 추출된 프레임 확인")
        print(f"   → {output_dir}")
        print()
        print("2. 배경 제거 (필요시)")
        print("   → python remove_background.py")
        print()
        print("3. Godot에 통합")
        print("   → AnimatedSprite2D → SpriteFrames")

if __name__ == "__main__":
    main()
