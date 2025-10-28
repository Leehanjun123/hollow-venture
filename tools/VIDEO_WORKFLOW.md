# 🎬 동영상 기반 스프라이트 제작 워크플로우

## 🚀 **전체 프로세스 (2-3시간)**

```
1. Gemini로 동영상 생성 (10개) → 1-2시간
2. FFmpeg로 프레임 추출 → 10분
3. 배경 제거 (필요시) → 20분
4. Godot 통합 → 30분
5. 테스트 및 조정 → 30분

총 소요시간: 약 2-3시간
```

---

## 📋 **Step 1: Gemini 동영상 생성 (1-2시간)**

### **준비물:**
- ✅ Google 계정
- ✅ 베이스 이미지 2개 (인간 모드, 악신 모드)
- ✅ `tools/GEMINI_VIDEO_PROMPTS.md` 파일

### **생성할 동영상 (총 10개):**

#### **인간 모드 (5개):**
1. ✅ `human_idle.mp4` (3초)
2. ✅ `human_walk.mp4` (4초)
3. ✅ `human_attack.mp4` (2초)
4. ✅ `human_jump.mp4` (3초)
5. ✅ `human_dodge.mp4` (2초)

#### **악신 모드 (5개):**
1. ✅ `evil_idle.mp4` (3초)
2. ✅ `evil_walk.mp4` (4초)
3. ✅ `evil_attack.mp4` (2초)
4. ✅ `evil_jump.mp4` (3초)
5. ✅ `evil_dash.mp4` (2초)

### **생성 순서 (효율적):**

**우선순위 1: Idle 먼저**
```
1. human_idle.mp4
2. evil_idle.mp4
```
→ 가장 중요! 이것만 있어도 캐릭터 표현 가능

**우선순위 2: 이동 액션**
```
3. human_walk.mp4
4. evil_walk.mp4
```

**우선순위 3: 전투 액션**
```
5. human_attack.mp4
6. evil_attack.mp4
7. human_jump.mp4
8. evil_jump.mp4
9. human_dodge.mp4
10. evil_dash.mp4
```

### **Gemini 사용법:**

1. **https://gemini.google.com 접속**

2. **이미지 업로드**
   - 📎 버튼 클릭
   - 베이스 이미지 선택 (human_base.png 또는 evil_base.png)

3. **프롬프트 입력**
   - `tools/GEMINI_VIDEO_PROMPTS.md` 열기
   - 원하는 애니메이션 프롬프트 복사
   - 붙여넣기

4. **생성 대기** (2-5분)

5. **다운로드**
   - 생성된 동영상 다운로드
   - 저장 위치: `tools/videos/human/` 또는 `tools/videos/evil/`
   - 파일명 규칙: `human_idle.mp4`, `evil_walk.mp4` 등

---

## 📋 **Step 2: 프레임 추출 (10분)**

### **FFmpeg 설치 확인:**

```bash
# macOS
brew install ffmpeg

# 확인
ffmpeg -version
```

### **프레임 추출 실행:**

#### **단일 동영상 추출:**
```bash
# Idle 애니메이션 (4프레임)
python extract_frames.py tools/videos/human/human_idle.mp4 --fps 12 --frames 4

# Walk 애니메이션 (6프레임)
python extract_frames.py tools/videos/human/human_walk.mp4 --fps 12 --frames 6

# Attack 애니메이션 (4프레임)
python extract_frames.py tools/videos/human/human_attack.mp4 --fps 15 --frames 4
```

#### **결과:**
```
assets/sprites/extracted/human_idle/
├── human_idle_frame_001.png
├── human_idle_frame_002.png
├── human_idle_frame_003.png
└── human_idle_frame_004.png
```

### **FPS 가이드라인:**
```
Idle:   --fps 6   (부드러운 호흡)
Walk:   --fps 12  (자연스러운 걷기)
Attack: --fps 15  (날카로운 공격)
Jump:   --fps 10  (공중 동작)
Dodge:  --fps 12  (빠른 회피)
```

---

## 📋 **Step 3: 배경 제거 (20분, 선택)**

### **방법 1: rembg (추천, AI 기반)**

```bash
# 설치 (최초 1회)
pip install rembg

# 실행
python remove_background.py assets/sprites/extracted/human_idle/
```

**결과:**
```
assets/sprites/extracted/human_idle_nobg/
├── human_idle_frame_001.png (배경 제거됨)
├── human_idle_frame_002.png
├── human_idle_frame_003.png
└── human_idle_frame_004.png
```

### **방법 2: 수동 (Photoshop/GIMP)**

- Magic Wand Tool → Delete
- 또는 remove.bg 웹사이트 사용

---

## 📋 **Step 4: Godot 통합 (30분)**

### **스프라이트 정리:**

```bash
# 최종 스프라이트를 Godot 폴더로 복사
cp assets/sprites/extracted/human_idle_nobg/*.png assets/sprites/player/animations_v2/human/idle/
```

### **Godot에서:**

1. **player.tscn 열기**

2. **AnimatedSprite2D 선택**

3. **SpriteFrames 리소스 열기**

4. **새 애니메이션 추가:**
   - Animation Name: `human_idle_v2`
   - FPS: `6`

5. **프레임 추가:**
   - 드래그 앤 드롭: `idle_frame_001.png` ~ `idle_frame_004.png`

6. **재생 테스트:**
   - Animation 탭에서 `human_idle_v2` 선택
   - 재생 버튼 클릭

---

## 📋 **Step 5: 테스트 및 조정 (30분)**

### **게임 실행:**
```bash
# Godot 프로젝트 실행
godot --path . res://scenes/levels/cavern_level.tscn
```

### **확인 사항:**
- [ ] 애니메이션이 부드럽게 재생되는가?
- [ ] 루프가 자연스러운가?
- [ ] 타이밍이 적절한가?
- [ ] 다른 애니메이션과 전환이 매끄러운가?

### **조정:**
- FPS 올리기/낮추기
- 프레임 순서 변경
- 특정 프레임 제거

---

## 🔄 **자동화 스크립트 (고급)**

모든 동영상을 한 번에 처리:

```bash
#!/bin/bash
# process_all_videos.sh

# Human mode
for video in tools/videos/human/*.mp4; do
    name=$(basename "$video" .mp4)
    python extract_frames.py "$video" --fps 12 --frames 6
    python remove_background.py "assets/sprites/extracted/$name/"
done

# Evil mode
for video in tools/videos/evil/*.mp4; do
    name=$(basename "$video" .mp4)
    python extract_frames.py "$video" --fps 12 --frames 6
    python remove_background.py "assets/sprites/extracted/$name/"
done

echo "✅ 모든 동영상 처리 완료!"
```

---

## 📊 **진행 상황 체크리스트**

### **동영상 생성:**
- [ ] Human Idle (3초)
- [ ] Human Walk (4초)
- [ ] Human Attack (2초)
- [ ] Human Jump (3초)
- [ ] Human Dodge (2초)
- [ ] Evil Idle (3초)
- [ ] Evil Walk (4초)
- [ ] Evil Attack (2초)
- [ ] Evil Jump (3초)
- [ ] Evil Dash (2초)

### **프레임 추출:**
- [ ] Human Idle → 4프레임
- [ ] Human Walk → 6프레임
- [ ] Human Attack → 4프레임
- [ ] Human Jump → 3프레임
- [ ] Human Dodge → 3프레임
- [ ] Evil Idle → 4프레임
- [ ] Evil Walk → 6프레임
- [ ] Evil Attack → 4프레임
- [ ] Evil Jump → 3프레임
- [ ] Evil Dash → 3프레임

### **Godot 통합:**
- [ ] 모든 애니메이션 SpriteFrames에 추가
- [ ] FPS 설정 완료
- [ ] 애니메이션 전환 스크립트 연결
- [ ] 테스트 완료

---

## 🆘 **문제 해결**

### **Q: Gemini가 얼굴을 바꿔버려요**
A: 프롬프트에 강조:
```
Keep this character's face and mask EXACTLY as shown.
DO NOT CHANGE THE FACE OR MASK DESIGN AT ALL.
```

### **Q: 배경이 완벽하게 제거되지 않아요**
A:
1. `rembg` 대신 수동 제거
2. Photoshop/GIMP에서 Magic Wand Tool 사용
3. 또는 remove.bg 웹사이트 사용

### **Q: 프레임이 너무 빠르거나 느려요**
A:
- Godot SpriteFrames에서 FPS 조정
- 또는 프레임 추출 시 `--fps` 값 변경

### **Q: 동영상이 루프되지 않아요**
A:
- Gemini 프롬프트에 "seamless loop" 추가
- 또는 첫 프레임과 마지막 프레임 수동 조정

---

## 💡 **팁**

### **동영상 품질 향상:**
- 프롬프트에 "high quality", "professional" 추가
- "4K", "detailed" 키워드 사용
- 여러 번 생성해서 최고 품질 선택

### **일관성 유지:**
- 같은 베이스 이미지 사용
- 프롬프트 앞부분 동일하게 유지
- "Keep the same art style" 강조

### **효율적인 작업:**
1. Idle부터 시작 (가장 중요)
2. 한 번에 여러 동영상 생성 (대기하면서)
3. 생성되는 동안 프레임 추출 스크립트 준비

---

**지금 바로 시작하세요! 🚀**

1. `tools/GEMINI_VIDEO_PROMPTS.md` 열기
2. Gemini 접속
3. 베이스 이미지 업로드
4. Idle 프롬프트 입력
5. 동영상 생성!
