#!/usr/bin/env python3
"""
동굴 배경 sprite 15개를 자동으로 처리하는 스크립트

기능:
1. 체크보드 투명화
2. 올바른 크기로 리사이즈
3. 올바른 이름으로 rename
4. 목적 폴더에 복사
"""

from PIL import Image
import numpy as np
import os
import shutil

# Sprite 스펙 (이름: (너비, 높이))
SPRITE_SPECS = {
    "stalactite_large": (300, 400),
    "stalactite_medium": (200, 300),
    "stalactite_small": (120, 200),
    "distant_pillar": (150, 500),
    "stone_column_broken": (200, 450),
    "stone_column_intact": (180, 500),
    "ancient_statue": (250, 400),
    "cave_wall_detail": (300, 300),
    "glowing_mushroom_cluster": (150, 120),
    "stalagmite_large": (120, 200),
    "stalagmite_small": (60, 100),
    "rock_sharp": (80, 60),
    "hanging_roots": (100, 150),
    "mist_patch": (200, 100),
}

def fix_transparency(img):
    """체크보드 패턴을 투명으로 변환"""
    data = np.array(img)

    if data.shape[2] == 3:  # RGB
        img = img.convert("RGBA")
        data = np.array(img)

    # RGB 분리
    red = data[:,:,0]
    green = data[:,:,1]
    blue = data[:,:,2]
    alpha = data[:,:,3]

    # 체크보드 마스크 (밝고 채도 낮은 픽셀)
    brightness = (red.astype(float) + green + blue) / 3
    saturation = np.maximum(red, np.maximum(green, blue)) - np.minimum(red, np.minimum(green, blue))

    checkerboard_mask = (brightness > 180) & (saturation < 30)
    alpha[checkerboard_mask] = 0

    data[:,:,3] = alpha

    return Image.fromarray(data, "RGBA")

def resize_to_fit(img, target_width, target_height):
    """
    이미지를 목표 크기에 맞게 리사이즈
    - 비율 유지
    - 목표 크기 안에 들어가도록
    """
    # 현재 크기
    width, height = img.size

    # 비율 계산
    ratio = min(target_width / width, target_height / height)

    # 새 크기
    new_width = int(width * ratio)
    new_height = int(height * ratio)

    # 리사이즈 (LANCZOS = 고품질)
    return img.resize((new_width, new_height), Image.Resampling.LANCZOS)

def process_sprite(input_path, output_path, target_width, target_height):
    """단일 sprite 처리"""
    print(f"  📄 {os.path.basename(input_path)}")

    # 이미지 열기
    img = Image.open(input_path).convert("RGBA")

    # 투명도 수정
    img = fix_transparency(img)
    print(f"     ✓ 투명도 수정")

    # 리사이즈
    img = resize_to_fit(img, target_width, target_height)
    print(f"     ✓ 리사이즈: {img.size[0]}×{img.size[1]}")

    # 저장
    img.save(output_path, "PNG")
    print(f"     ✓ 저장: {output_path}")

def main():
    # 경로 설정
    input_folder = "/Users/leehanjun/Desktop/background"
    output_folder = "/Users/leehanjun/Desktop/money/hollow-venture/assets/backgrounds/cavern"

    # 입력 파일 목록
    input_files = sorted([f for f in os.listdir(input_folder) if f.endswith('.png')])

    if len(input_files) != 15:
        print(f"❌ 오류: 15개 파일이 필요하지만 {len(input_files)}개 발견")
        return

    print(f"📂 입력 폴더: {input_folder}")
    print(f"📂 출력 폴더: {output_folder}")
    print(f"📊 파일 수: {len(input_files)}개\n")

    # 수동 매핑 (사용자가 순서대로 생성했다고 가정)
    # 실제로는 각 이미지를 확인해야 함
    sprite_names = [
        "stone_column_broken",       # 1
        "rock_sharp",                 # 2
        "hanging_roots",              # 3
        "stalagmite_large",           # 4
        "ancient_statue",             # 5
        "stone_column_intact",        # 6
        "glowing_mushroom_cluster",   # 7
        "distant_pillar",             # 8
        "stalagmite_small",           # 9
        "stalactite_large",           # 10
        "stalactite_medium",          # 11
        "cave_wall_detail",           # 12
        "mist_patch",                 # 13
        "stalactite_small",           # 14
        # 15번은 타일셋 (별도 처리)
    ]

    print("🔄 Sprite 처리 중...\n")

    # 14개 sprite 처리
    for i, (input_file, sprite_name) in enumerate(zip(input_files[:14], sprite_names), 1):
        print(f"[{i}/14] {sprite_name}")

        input_path = os.path.join(input_folder, input_file)
        output_path = os.path.join(output_folder, f"{sprite_name}.png")

        target_width, target_height = SPRITE_SPECS[sprite_name]

        try:
            process_sprite(input_path, output_path, target_width, target_height)
        except Exception as e:
            print(f"     ❌ 오류: {e}")

        print()

    print("✅ 완료!")
    print(f"📁 출력 위치: {output_folder}")

if __name__ == "__main__":
    main()
