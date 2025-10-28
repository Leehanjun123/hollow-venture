#!/usr/bin/env python3
"""
플레이어 스프라이트의 얼굴 부분(흰색 마스크)을 복원
"""

from PIL import Image, ImageDraw
import numpy as np
from pathlib import Path

def restore_white_face(image_path):
    """
    얼굴 부분에 흰색 원을 다시 그려넣기
    """
    img = Image.open(image_path).convert("RGBA")
    data = np.array(img)

    # 이미지 크기
    height, width = data.shape[:2]

    # 중심점 (얼굴 위치 추정)
    center_x = width // 2
    center_y = int(height * 0.35)  # 상단 35% 지점

    # 얼굴 영역 크기 (이미지 크기에 비례)
    face_radius = int(min(width, height) * 0.12)

    # 흰색 원형 마스크 그리기
    draw_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(draw_layer)

    # 얼굴 (흰색 원)
    draw.ellipse(
        [center_x - face_radius, center_y - face_radius,
         center_x + face_radius, center_y + face_radius],
        fill=(255, 255, 255, 255)
    )

    # 눈 (검은색 타원)
    eye_size = int(face_radius * 0.3)
    eye_y = center_y
    left_eye_x = center_x - int(face_radius * 0.35)
    right_eye_x = center_x + int(face_radius * 0.35)

    draw.ellipse(
        [left_eye_x - eye_size, eye_y - eye_size,
         left_eye_x + eye_size, eye_y + eye_size],
        fill=(0, 0, 0, 255)
    )

    draw.ellipse(
        [right_eye_x - eye_size, eye_y - eye_size,
         right_eye_x + eye_size, eye_y + eye_size],
        fill=(0, 0, 0, 255)
    )

    # 입 (검은색 선)
    mouth_y = center_y + int(face_radius * 0.4)
    mouth_width = int(face_radius * 0.6)
    draw.line(
        [center_x - mouth_width, mouth_y,
         center_x + mouth_width, mouth_y],
        fill=(0, 0, 0, 255),
        width=int(face_radius * 0.15)
    )

    # 원본 이미지와 합성
    result = Image.alpha_composite(img, draw_layer)
    result.save(image_path, "PNG")

    print(f"✓ {Path(image_path).name} 복원 완료")

def process_player_sprites():
    """모든 플레이어 스프라이트 처리"""
    base_path = Path("/Users/leehanjun/Desktop/money/hollow-venture/assets/sprites/player/animations/human")

    for folder in base_path.iterdir():
        if folder.is_dir():
            for png_file in folder.glob("*.png"):
                try:
                    restore_white_face(png_file)
                except Exception as e:
                    print(f"❌ {png_file.name}: {e}")

if __name__ == "__main__":
    process_player_sprites()
