# 🎨 48프레임 스프라이트 제작 워크플로우

## 📋 **전체 프로세스 개요**

```
1. AI로 키프레임 생성 (20-24개) → 2-3시간
2. Python 스크립트로 중간 프레임 보간 → 10분
3. 수동 정리 및 미세 조정 (선택) → 30분
4. Godot SpriteFrames 통합 → 30분
5. 타이밍 조정 및 테스트 → 30분

총 소요시간: 약 4-5시간
```

---

## 🚀 **Step 1: AI로 키프레임 생성 (가장 중요!)**

### **필요한 키프레임 리스트**

#### **인간 모드 (12개 키프레임)**
```
✓ human_idle_base.png        - 기본 서있는 자세
✓ human_idle_breath.png       - 숨쉬기 정점
✓ human_walk_contact.png      - 발 닿은 순간
✓ human_walk_pass.png         - 다리 교차
✓ human_attack_windup.png     - 공격 준비
✓ human_attack_impact.png     - 공격 충격
✓ human_jump_crouch.png       - 점프 준비
✓ human_jump_air.png          - 공중 자세
✓ human_dodge_start.png       - 회피 시작
✓ human_dodge_mid.png         - 회피 중간
✓ human_hurt.png              - 피격
✓ human_land.png              - 착지
```

#### **악신 모드 (12개 키프레임)**
```
✓ evil_idle_base.png          - 위협적인 서있는 자세
✓ evil_idle_rage.png          - 분노 호흡 정점
✓ evil_walk_stomp.png         - 무거운 발걸음
✓ evil_walk_pass.png          - 다리 교차
✓ evil_attack_windup.png      - 강력한 준비
✓ evil_attack_impact.png      - 강타 충격
✓ evil_jump_launch.png        - 폭발 점프
✓ evil_jump_air.png           - 공중 자세
✓ evil_dash_start.png         - 대쉬 시작
✓ evil_dash_mid.png           - 대쉬 중간
✓ evil_hurt_rage.png          - 분노 피격
✓ evil_land_impact.png        - 강한 착지
```

---

### **AI 생성 방법 (선택)**

#### **Option A: Midjourney (추천 - 가장 일관성 좋음)**

1. **Discord에서 Midjourney 실행**

2. **베이스 프롬프트 + 개별 액션**
```
/imagine prompt: A 2D game character sprite, Hollow Knight inspired style, side view, pixel art aesthetic, hand-drawn look, white porcelain mask with black eye holes, black tattered cloak flowing behind, holding a silver nail sword, dark fantasy atmosphere, transparent background, PNG format, 512x512 pixels, centered composition, clean edges, professional game art quality, [여기에 개별 액션 추가], --ar 1:1 --style raw --v 6 --s 200
```

3. **개별 액션 예시:**
   - **Idle:** `standing idle pose, slight breathing, calm stance`
   - **Walk:** `left foot forward walking pose, cloak flowing backward`
   - **Attack:** `sword swinging forward, mid-attack pose`

4. **같은 seed 사용으로 일관성 유지:**
```
--seed 12345 (첫 생성 후 동일 seed 계속 사용)
```

5. **다운로드 후 `tools/keyframes/human/` 또는 `tools/keyframes/evil/`에 저장**

---

#### **Option B: DALL-E 3 (ChatGPT Plus)**

1. **ChatGPT에 프롬프트 입력**
```
Create a 2D game sprite for a Hollow Knight-inspired character.

Character design:
- White porcelain mask with black eye holes
- Black flowing cloak
- Holding a silver nail sword
- Side view, facing right
- Transparent background
- 512x512 pixels
- Professional game asset quality

Pose: [여기에 개별 액션]
- Standing idle with slight breathing
```

2. **"Make this more consistent with the previous image" 사용**

3. **배경 제거:**
   - `remove.bg` 사용
   - 또는 Photoshop/GIMP

---

#### **Option C: Leonardo.ai (무료 크레딧)**

1. **Leonardo.ai 접속 후 로그인**

2. **Model: Leonardo Anime XL 선택**

3. **프롬프트 입력:**
```
Positive:
2D game character sprite, Hollow Knight style, white mask knight, black cloak, silver sword, side view, transparent background, game asset, professional quality

Negative:
realistic, 3D, blurry, duplicate, multiple characters, text, watermark
```

4. **Image Guidance 사용:**
   - 첫 이미지를 Reference로 업로드
   - Strength: 0.7-0.8로 일관성 유지

---

### **🎯 생성 순서 (효율적)**

**우선순위 1: 베이스 프레임 (가장 중요!)**
```
1. human_idle_base.png
2. evil_idle_base.png
```
→ 이 두 개가 모든 것의 기준!

**우선순위 2: 주요 액션 키프레임**
```
3. human_walk_contact.png
4. human_attack_impact.png
5. human_jump_air.png
6. evil_walk_stomp.png
7. evil_attack_impact.png
8. evil_jump_air.png
```
→ 나머지는 이것들의 변형

**우선순위 3: 세부 프레임**
```
나머지 프레임들 생성
```

---

## 🐍 **Step 2: Python 스크립트로 보간**

### **스크립트 실행**

```bash
cd /Users/leehanjun/Desktop/money/hollow-venture

# Python 가상환경 생성 (최초 1회)
python3 -m venv venv
source venv/bin/activate
pip install Pillow numpy

# 스크립트 실행
python tools/sprite_generator.py
```

### **스크립트 사용 예시**

```python
from sprite_generator import SpriteGenerator

gen = SpriteGenerator()

# 1. Idle 애니메이션 (4프레임)
gen.create_idle_animation('tools/keyframes/human/human_idle_base.png', num_frames=4)

# 2. Walk 애니메이션 (2키프레임 → 6프레임)
gen.interpolate_frames(
    'tools/keyframes/human/human_walk_contact.png',
    'tools/keyframes/human/human_walk_pass.png',
    num_frames=3,
    animation_name='human_walk_1'
)

# 3. Attack 애니메이션 (회전 효과)
gen.create_attack_frames('tools/keyframes/human/human_attack_impact.png', num_frames=4)
```

---

## 🎨 **Step 3: 수동 정리 (선택)**

### **Aseprite 사용 (권장 - $19.99)**

1. **프레임 불러오기**
```
File → Import Sprite Sheet
또는 개별 PNG 드래그
```

2. **타이밍 조정**
```
Frame 속성에서 Duration 설정
- Idle: 150ms per frame
- Walk: 80-100ms per frame
- Attack: 50-80ms per frame
```

3. **미세 조정**
```
- Onion Skinning 켜기 (Alt+O)
- 프레임 간 차이 확인
- 픽셀 단위 수정
```

4. **Export**
```
File → Export Sprite Sheet
Settings:
- Type: Horizontal Strip (or Packed)
- Trim: Checked
- Format: PNG
```

---

### **무료 대안: Piskel (웹 기반)**

1. **piskelapp.com 접속**

2. **Import → From File → 개별 프레임 업로드**

3. **프레임 순서 조정**

4. **Export**

---

## 🎮 **Step 4: Godot 통합**

### **방법 A: SpriteFrames 리소스 직접 수정**

1. **현재 player_frames.tres 백업**
```bash
cp assets/sprites/player/player_frames.tres assets/sprites/player/player_frames_backup.tres
```

2. **새 스프라이트 폴더 생성**
```bash
mkdir -p assets/sprites/player/animations_v2/human/idle
mkdir -p assets/sprites/player/animations_v2/human/walk
# ... (각 애니메이션별)
```

3. **생성된 프레임 복사**
```bash
# Idle
cp assets/sprites/generated/human/idle_*.png assets/sprites/player/animations_v2/human/idle/

# Walk
cp assets/sprites/generated/human/walk_*.png assets/sprites/player/animations_v2/human/walk/
```

4. **Godot에서 SpriteFrames 리소스 열기**
   - `assets/sprites/player/player_frames.tres` 더블클릭
   - 각 애니메이션에 새 프레임 추가
   - FPS 설정 (Idle: 6 FPS, Walk: 12 FPS, Attack: 15 FPS)

---

### **방법 B: 스크립트로 자동화 (추천!)**

```python
# tools/update_spriteframes.py

import os
from pathlib import Path

animations = {
    'human_idle': {'fps': 6, 'loop': True},
    'human_walk': {'fps': 12, 'loop': True},
    'human_attack': {'fps': 15, 'loop': False},
    'human_jump': {'fps': 10, 'loop': False},
    'human_dodge': {'fps': 12, 'loop': False},
    'human_hurt': {'fps': 8, 'loop': False},
    'human_land': {'fps': 10, 'loop': False},
}

def generate_spriteframes_config():
    """Godot SpriteFrames .tres 파일 생성"""
    # TODO: 구현
    pass
```

---

## ⏱️ **Step 5: 타이밍 조정**

### **FPS 가이드라인**

```
Idle:   6 FPS  (부드러운 호흡)
Walk:   12 FPS (자연스러운 걷기)
Run:    15 FPS (빠른 움직임)
Attack: 15 FPS (날카로운 공격)
Jump:   10 FPS (공중 동작)
Dodge:  12 FPS (빠른 회피)
Hurt:   10 FPS (반응)
Land:   12 FPS (착지 충격)
```

### **테스트 방법**

1. **게임 실행**
```bash
godot --path /Users/leehanjun/Desktop/money/hollow-venture res://scenes/levels/cavern_level.tscn
```

2. **각 애니메이션 테스트**
   - Idle: 가만히 서있기
   - Walk: 좌우 이동
   - Jump: Space
   - Attack: Z
   - Dodge: X

3. **타이밍이 어색하면:**
   - SpriteFrames에서 FPS 조정
   - 또는 개별 프레임 duration 조정

---

## ✅ **완료 체크리스트**

### **AI 생성 단계**
- [ ] 인간 모드 키프레임 12개 생성
- [ ] 악신 모드 키프레임 12개 생성
- [ ] 모든 이미지 512x512, 투명 배경 확인
- [ ] 일관성 있는 스타일 확인

### **보간 단계**
- [ ] Python 환경 설정 완료
- [ ] 각 애니메이션별 프레임 보간 완료
- [ ] 총 48프레임 확인

### **통합 단계**
- [ ] 스프라이트 폴더 정리
- [ ] SpriteFrames 리소스 업데이트
- [ ] FPS 설정 완료

### **테스트 단계**
- [ ] 모든 애니메이션 재생 확인
- [ ] 애니메이션 전환 부드러움 확인
- [ ] 타이밍 자연스러움 확인
- [ ] 버그 없음 확인

---

## 🆘 **문제 해결**

### **Q: AI 생성 이미지가 일관성 없어요**
A:
- Midjourney: 같은 seed 사용 (`--seed 12345`)
- DALL-E: "Make it consistent with previous image" 반복
- Leonardo: Image Guidance 기능 사용 (이전 이미지 참조)

### **Q: 배경이 투명하지 않아요**
A:
- remove.bg 사용
- GIMP: Layer → Transparency → Add Alpha Channel → Select by Color → Delete
- Photoshop: Magic Wand Tool → Delete

### **Q: 크기가 제각각이에요**
A:
```python
from PIL import Image

def resize_to_512(image_path):
    img = Image.open(image_path)
    img = img.resize((512, 512), Image.LANCZOS)
    img.save(image_path)
```

### **Q: 애니메이션이 끊겨 보여요**
A:
- FPS 올리기 (8 → 12 → 15)
- 또는 중간 프레임 더 추가
- Godot 프로젝트 설정에서 V-Sync 확인

---

## 📊 **진행 상황 트래킹**

```
현재 진행도: [        ] 0%

✓ AI 프롬프트 작성      [████████] 100%
✓ 폴더 구조 생성        [████████] 100%
⏳ 키프레임 생성        [        ]   0%
⏳ 프레임 보간           [        ]   0%
⏳ Godot 통합          [        ]   0%
⏳ 테스트 및 조정       [        ]   0%
```

---

**지금 바로 시작하세요!** 🚀

1. `tools/ai_prompts.md` 열기
2. 선택한 AI 도구에서 첫 프레임 생성 (`human_idle_base.png`)
3. `tools/keyframes/human/` 폴더에 저장
4. 다음 프레임 계속 생성...
