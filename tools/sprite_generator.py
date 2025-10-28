#!/usr/bin/env python3
"""
할로우 나이트 스타일 스프라이트 대량 생성기

사용법:
1. AI로 키프레임 생성 (5-10개)
2. tools/keyframes/ 폴더에 저장
3. python sprite_generator.py 실행
4. 자동으로 중간 프레임 생성
"""

from PIL import Image, ImageEnhance, ImageFilter
import os
import numpy as np
from pathlib import Path

class SpriteGenerator:
    def __init__(self, keyframe_dir="tools/keyframes", output_dir="assets/sprites/generated"):
        self.keyframe_dir = Path(keyframe_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def interpolate_frames(self, img1_path, img2_path, num_frames=3, animation_name="anim"):
        """두 키프레임 사이의 중간 프레임 생성"""
        img1 = Image.open(img1_path).convert("RGBA")
        img2 = Image.open(img2_path).convert("RGBA")

        # 크기 맞추기
        if img1.size != img2.size:
            img2 = img2.resize(img1.size, Image.Resampling.LANCZOS)

        frames = [img1]  # 시작 프레임

        for i in range(1, num_frames + 1):
            alpha = i / (num_frames + 1)

            # 픽셀 블렌딩
            arr1 = np.array(img1, dtype=np.float32)
            arr2 = np.array(img2, dtype=np.float32)

            blended = (1 - alpha) * arr1 + alpha * arr2
            blended = np.clip(blended, 0, 255).astype(np.uint8)

            frame = Image.fromarray(blended, mode='RGBA')
            frames.append(frame)

        frames.append(img2)  # 끝 프레임

        # 저장
        for idx, frame in enumerate(frames):
            output_path = self.output_dir / f"{animation_name}_{idx + 1}.png"
            frame.save(output_path)
            print(f"✓ 생성: {output_path}")

        return frames

    def create_idle_animation(self, base_frame, num_frames=6):
        """Idle 애니메이션 생성 (숨쉬기 효과)"""
        img = Image.open(base_frame).convert("RGBA")
        frames = []

        for i in range(num_frames):
            # 사인 곡선으로 부드러운 움직임
            phase = (i / num_frames) * 2 * np.pi
            scale_y = 1.0 + 0.02 * np.sin(phase)  # 2% 상하 움직임

            # 세로 스케일 적용
            new_height = int(img.height * scale_y)
            new_width = img.width

            scaled = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

            # 중앙 정렬을 위해 캔버스에 배치
            canvas = Image.new('RGBA', img.size, (0, 0, 0, 0))
            y_offset = (img.height - new_height) // 2
            canvas.paste(scaled, (0, y_offset), scaled)

            frames.append(canvas)

            output_path = self.output_dir / f"idle_{i + 1}.png"
            canvas.save(output_path)
            print(f"✓ 생성: {output_path}")

        return frames

    def create_walk_cycle(self, keyframes, num_frames=8):
        """걷기 사이클 생성 (4키프레임 → 8프레임)"""
        # keyframes: [contact, down, pass, up]

        if len(keyframes) != 4:
            print("⚠️ 걷기 사이클은 4개의 키프레임이 필요합니다")
            return

        images = [Image.open(kf).convert("RGBA") for kf in keyframes]
        frames = []

        # contact → down → pass → up → contact (반대발)
        for i in range(8):
            idx = i // 2  # 각 키프레임을 2번씩 사용
            frame = images[idx % 4].copy()

            # 홀수 프레임은 살짝 블러 (모션 블러 효과)
            if i % 2 == 1:
                frame = frame.filter(ImageFilter.GaussianBlur(radius=0.5))

            frames.append(frame)

            output_path = self.output_dir / f"walk_{i + 1}.png"
            frame.save(output_path)
            print(f"✓ 생성: {output_path}")

        return frames

    def add_motion_blur(self, img_path, direction="horizontal", intensity=5):
        """모션 블러 추가 (빠른 동작용)"""
        img = Image.open(img_path).convert("RGBA")

        # 방향에 따라 블러 적용
        if direction == "horizontal":
            kernel = ImageFilter.Kernel(
                (5, 1),
                [1/5] * 5,
                scale=1
            )
        else:
            kernel = ImageFilter.Kernel(
                (1, 5),
                [1/5] * 5,
                scale=1
            )

        blurred = img.filter(kernel)

        output_path = self.output_dir / f"{Path(img_path).stem}_blur.png"
        blurred.save(output_path)
        print(f"✓ 모션 블러 추가: {output_path}")

        return blurred

    def create_attack_frames(self, base_frame, num_frames=6):
        """공격 애니메이션 생성 (회전 효과)"""
        img = Image.open(base_frame).convert("RGBA")
        frames = []

        angles = [-15, -10, 0, 20, 30, 15]  # 준비 → 휘두름 → 경직

        for i in range(num_frames):
            rotated = img.rotate(angles[i], expand=False, fillcolor=(0, 0, 0, 0))

            # 휘두르는 순간(프레임 3-4)은 모션 블러 추가
            if i in [3, 4]:
                rotated = rotated.filter(ImageFilter.GaussianBlur(radius=1))

            frames.append(rotated)

            output_path = self.output_dir / f"attack_{i + 1}.png"
            rotated.save(output_path)
            print(f"✓ 생성: {output_path}")

        return frames

    def batch_process_directory(self):
        """디렉토리 전체 자동 처리"""
        print("🎨 스프라이트 생성 시작...\n")

        # 키프레임 찾기
        keyframes = sorted(self.keyframe_dir.glob("*.png"))

        if not keyframes:
            print("⚠️ keyframes 폴더에 이미지가 없습니다")
            print(f"   경로: {self.keyframe_dir.absolute()}")
            return

        print(f"✓ {len(keyframes)}개 키프레임 발견\n")

        # 사용자 선택
        print("생성할 애니메이션을 선택하세요:")
        print("1. Idle (숨쉬기)")
        print("2. Walk (걷기)")
        print("3. Attack (공격)")
        print("4. 두 프레임 사이 보간")

        return keyframes


def main():
    """메인 함수"""
    generator = SpriteGenerator()

    print("=" * 60)
    print("🎮 할로우 나이트 스타일 스프라이트 생성기")
    print("=" * 60)
    print()

    # 사용 예시
    print("📝 사용법:")
    print("1. AI로 키프레임 생성 (Midjourney/DALL-E)")
    print("2. tools/keyframes/ 폴더에 저장")
    print("3. 아래 함수 사용:\n")

    print("   # Idle 애니메이션 (6프레임)")
    print("   generator.create_idle_animation('tools/keyframes/base.png')")
    print()

    print("   # 두 프레임 사이 보간 (3프레임 추가)")
    print("   generator.interpolate_frames(")
    print("       'tools/keyframes/walk_1.png',")
    print("       'tools/keyframes/walk_2.png',")
    print("       num_frames=3,")
    print("       animation_name='walk'")
    print("   )")
    print()

    print("   # 공격 애니메이션 (회전 효과)")
    print("   generator.create_attack_frames('tools/keyframes/attack.png')")
    print()

    keyframes = generator.batch_process_directory()

    if keyframes:
        print(f"\n✓ 키프레임: {[kf.name for kf in keyframes]}")


if __name__ == "__main__":
    main()
