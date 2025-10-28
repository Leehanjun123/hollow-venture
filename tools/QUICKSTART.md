# ⚡ 5분 빠른 시작 가이드

## 🎯 **지금 바로 시작하기**

### **Step 1: AI 도구 선택 (1분)**

다음 중 하나를 선택하세요:

#### **Option A: Midjourney (가장 추천)**
- ✅ 가장 일관성 있는 결과
- ✅ seed로 스타일 고정 가능
- ⚠️ 월 $10 필요
- 🔗 https://midjourney.com

#### **Option B: ChatGPT Plus (DALL-E 3)**
- ✅ 정확한 프롬프트 이해
- ✅ 대화로 수정 가능
- ⚠️ 월 $20 (ChatGPT Plus 구독)
- 🔗 https://chat.openai.com

#### **Option C: Leonardo.ai**
- ✅ **무료 크레딧** 제공!
- ✅ Image Guidance 기능
- ⚠️ 일관성 약간 떨어짐
- 🔗 https://leonardo.ai

---

### **Step 2: 첫 프레임 생성 (2분)**

#### **Midjourney 예시:**

Discord에서:
```
/imagine prompt: A 2D game character sprite, Hollow Knight inspired style, side view, pixel art aesthetic, hand-drawn look, white porcelain mask with black eye holes, black tattered cloak flowing behind, holding a silver nail sword, dark fantasy atmosphere, transparent background, standing idle pose, slight breathing, calm stance, 512x512 pixels, centered composition, clean edges, professional game art quality --ar 1:1 --style raw --v 6 --s 200
```

생성된 이미지:
1. U1, U2, U3, U4 중 마음에 드는 것 선택
2. 우클릭 → "Save Image"
3. 파일명: `human_idle_base.png`
4. 저장 위치: `tools/keyframes/human/`

✅ **첫 프레임 완성!**

---

#### **ChatGPT Plus 예시:**

ChatGPT에 입력:
```
Create a 2D game sprite for a Hollow Knight-inspired character.

Character details:
- White porcelain mask with black eye holes (like Hollow Knight)
- Black flowing cloak behind
- Holding a thin silver nail sword
- Side view, facing right
- Dark fantasy style
- Professional game asset quality
- Transparent background
- 512x512 pixels

Pose: Standing idle, slight breathing pose, calm and ready stance

Please make it look like a professional 2D game sprite with clean edges.
```

생성된 이미지:
1. 다운로드
2. 파일명: `human_idle_base.png`
3. 저장 위치: `tools/keyframes/human/`

✅ **첫 프레임 완성!**

---

### **Step 3: 같은 스타일로 더 만들기 (반복)**

#### **Midjourney:**
```
/imagine prompt: [동일한 베이스 프롬프트] left foot forward walking pose, cloak flowing backward --seed [이전 seed 번호] --ar 1:1 --style raw --v 6 --s 200
```

#### **ChatGPT:**
```
Great! Now create the same character but in a walking pose with left foot forward.
Keep the same style and quality as before.
```

#### **Leonardo.ai:**
1. 이전 이미지를 "Image Guidance"에 업로드
2. Strength: 0.75
3. 프롬프트 수정: `walking pose, left foot forward`

---

## 📋 **생성 순서 (효율적)**

### **Phase 1: 필수 키프레임 (6개) - 30분**
```
1. ✓ human_idle_base.png        (방금 만듦!)
2. ⏳ human_walk_contact.png     (다음 목표)
3. ⏳ human_attack_impact.png
4. ⏳ evil_idle_base.png
5. ⏳ evil_walk_stomp.png
6. ⏳ evil_attack_impact.png
```

이 6개만 있으면 게임 플레이 가능!

---

### **Phase 2: 보완 키프레임 (6개) - 30분**
```
7. ⏳ human_jump_air.png
8. ⏳ human_dodge_mid.png
9. ⏳ evil_jump_air.png
10. ⏳ evil_dash_mid.png
11. ⏳ human_hurt.png
12. ⏳ evil_hurt_rage.png
```

---

### **Phase 3: 세부 키프레임 (12개) - 1시간**
```
나머지 모든 프레임
```

---

## 🐍 **Python 스크립트 실행 (10분)**

키프레임이 몇 개 생겼으면 바로 테스트!

```bash
# 터미널에서
cd /Users/leehanjun/Desktop/money/hollow-venture

# 가상환경 생성 (최초 1회)
python3 -m venv venv
source venv/bin/activate
pip install Pillow numpy

# 스크립트 실행
python tools/sprite_generator.py
```

Python 콘솔에서:
```python
from sprite_generator import SpriteGenerator

gen = SpriteGenerator()

# Idle 애니메이션 생성 (4프레임)
gen.create_idle_animation('tools/keyframes/human/human_idle_base.png', num_frames=4)

print("✅ Idle 애니메이션 4프레임 생성 완료!")
print("   → assets/sprites/generated/ 폴더 확인")
```

결과:
```
✓ 생성: assets/sprites/generated/idle_1.png
✓ 생성: assets/sprites/generated/idle_2.png
✓ 생성: assets/sprites/generated/idle_3.png
✓ 생성: assets/sprites/generated/idle_4.png
```

---

## 🎮 **Godot 즉시 테스트 (5분)**

### **방법 1: 간단 테스트 (추천)**

1. **Godot 에디터 열기**

2. **player.tscn 열기**

3. **AnimatedSprite2D 선택**

4. **SpriteFrames 리소스에서 human_idle 애니메이션 선택**

5. **기존 프레임 옆에 새 프레임 추가**
   - 드래그 앤 드롭: `assets/sprites/generated/idle_1.png`
   - 추가: `idle_2.png`, `idle_3.png`, `idle_4.png`

6. **FPS 설정: 6**

7. **게임 실행 (F5)**

**결과:** 플레이어가 부드럽게 숨쉬는 걸 볼 수 있습니다! 🎉

---

## 📊 **현재 진행 상황**

```
✅ 프로젝트 구조 완료
✅ AI 프롬프트 템플릿 완료
✅ Python 스크립트 완료
✅ 워크플로우 가이드 완료

⏳ 키프레임 생성 중... (0/24)
⏳ 프레임 보간 대기중
⏳ Godot 통합 대기중
```

---

## 🆘 **막혔을 때**

### **"AI 생성 이미지에 배경이 있어요"**
→ https://remove.bg 에 업로드하면 자동으로 배경 제거

### **"스타일이 너무 달라요"**
→ Midjourney: `--seed` 번호 고정
→ ChatGPT: "Make it exactly like the previous image" 추가
→ Leonardo: Image Guidance 사용

### **"어떤 프롬프트를 써야 할지 모르겠어요"**
→ `tools/ai_prompts.md` 파일 열기
→ 원하는 포즈의 프롬프트 복사
→ 붙여넣기

### **"Python 스크립트 에러나요"**
```bash
# PIL 설치 확인
pip install Pillow numpy

# 다시 실행
python tools/sprite_generator.py
```

---

## ⏭️ **다음 단계**

1. **지금:** 첫 프레임 생성 (`human_idle_base.png`)
2. **5분 후:** Walk 프레임 생성
3. **10분 후:** Python 스크립트로 보간 테스트
4. **15분 후:** Godot에서 확인

---

## 💪 **동기 부여**

> "할로우 나이트도 2-3프레임으로 시작했습니다.
>
> 당신은 지금 4-6프레임으로 시작하는 중입니다.
>
> 이미 할로우 나이트보다 부드럽습니다! 🎉"

---

**지금 바로 첫 프레임을 생성하세요!**

1. AI 도구 열기 (Midjourney/ChatGPT/Leonardo)
2. 위의 프롬프트 복사
3. 생성!
4. 저장: `tools/keyframes/human/human_idle_base.png`

**시작하셨나요? 🚀**
