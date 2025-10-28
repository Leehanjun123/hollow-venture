# 🦴 Spine 2D 애니메이션 워크플로우

## 1️⃣ 캐릭터 레이어 분리

Spine에서 사용하려면 캐릭터를 부위별로 분리해야 합니다.

### 필요한 레이어 (PNG 파일):

```
character/
├── head/
│   ├── mask.png          (마스크/얼굴)
│   ├── eyes_left.png     (왼쪽 눈)
│   └── eyes_right.png    (오른쪽 눈)
├── body/
│   ├── torso.png         (몸통)
│   └── cloak.png         (망토)
└── legs/
    ├── leg_left.png      (왼쪽 다리)
    ├── leg_right.png     (오른쪽 다리)
    ├── foot_left.png     (왼쪽 부츠)
    └── foot_right.png    (오른쪽 부츠)
```

### 레이어 분리 방법:

**Option A: Photoshop/GIMP 사용**
1. 현재 캐릭터 이미지 열기
2. Magic Wand로 각 부위 선택
3. 각 부위를 새 레이어로 복사
4. 각 레이어를 PNG로 export

**Option B: Gemini AI 사용**
캐릭터 이미지를 업로드하고:
```
Separate this character into individual body parts as transparent PNG layers:
- Head/mask (white mask only)
- Left eye (black oval)
- Right eye (black oval)
- Torso (body without cloak)
- Cloak (flowing cape)
- Left leg
- Right leg
- Left boot
- Right boot

Each part should be on transparent background and properly aligned.
```

---

## 2️⃣ Spine 프로젝트 설정

### 프로젝트 생성:

1. Spine 실행
2. `New Project` 클릭
3. 프로젝트 이름: `hollow-venture-player`
4. 해상도: 512x512 (또는 1024x1024)

### 이미지 Import:

1. 좌측 `Images` 폴더 우클릭 → `Import Images`
2. 모든 PNG 파일 선택
3. 자동으로 Spine에 추가됨

---

## 3️⃣ 리깅 (Skeleton 만들기)

### 뼈대 구조:

```
root (원점)
└── hip (엉덩이)
    ├── torso (몸통)
    │   ├── cloak (망토 - IK)
    │   └── head (머리)
    │       ├── eye_left
    │       └── eye_right
    ├── leg_left (왼쪽 다리)
    │   └── foot_left (왼쪽 발)
    └── leg_right (오른쪽 다리)
        └── foot_right (오른쪽 발)
```

### 리깅 순서:

1. **Root Bone 생성** (Create → Bone)
   - 캐릭터 중심에 배치

2. **Hip Bone** (엉덩이)
   - Root의 자식으로 생성
   - 몸통 하단에 배치

3. **Torso Bone** (몸통)
   - Hip의 자식
   - 몸통 중심에 배치
   - `torso.png` 이미지 연결

4. **Head Bone** (머리)
   - Torso의 자식
   - 목 위치에 배치
   - `mask.png` 이미지 연결

5. **Leg Bones** (다리)
   - Hip에서 좌우 다리 생성
   - 각 다리 끝에 Foot Bone 추가

6. **Cloak** (망토)
   - IK로 설정하면 자연스러운 흔들림

---

## 4️⃣ 애니메이션 제작

### Idle 애니메이션:

1. 새 애니메이션: `human_idle`
2. Duration: 1초 (또는 원하는 길이)
3. Keyframes:
   - 0.0s: 시작 자세
   - 0.5s: 약간 아래로 (호흡)
   - 1.0s: 시작 자세로 복귀

**Tip:** Torso를 Y축으로 2-3px 움직이고, Cloak은 약간 흔들리게

### Walk 애니메이션:

1. 새 애니메이션: `human_walk`
2. Duration: 0.5-0.7초
3. Keyframes:
   - 다리 번갈아 앞뒤로
   - 몸통 약간 위아래
   - 망토 뒤로 흔들림

**참고:** 할로우 나이트 프레임을 보며 타이밍 맞추기

### Jump 애니메이션:

1. 새 애니메이션: `human_jump`
2. Keyframes:
   - 0.0s: 웅크림 (다리 구부림)
   - 0.2s: 도약 (다리 펴짐)
   - 0.4s: 공중 자세
   - 0.6s: 착지 준비
   - 0.8s: 착지

---

## 5️⃣ Godot 통합

### Export 설정:

1. Spine에서 `Spine → Export`
2. Format: `JSON`
3. 저장 위치: `assets/sprites/player/spine/`
4. Export 클릭

**생성 파일:**
- `player.json` (애니메이션 데이터)
- `player.atlas` (텍스처 아틀라스)
- `player.png` (텍스처 이미지)

### Godot에서 사용:

**Godot Spine Plugin 설치:**

1. **spine-godot 플러그인 다운로드**
   - https://github.com/EsotericSoftware/spine-runtimes/tree/4.2/spine-godot

2. **플러그인 설치:**
   ```bash
   # Godot 프로젝트 폴더에서
   cd addons
   git clone https://github.com/EsotericSoftware/spine-runtimes.git
   cp -r spine-runtimes/spine-godot/spine_godot ./
   ```

3. **Godot에서 활성화:**
   - Project → Project Settings → Plugins
   - Spine 플러그인 체크

4. **씬에 추가:**
   ```gdscript
   # player.gd
   extends Node2D

   @onready var spine = $SpineSprite

   func _ready():
       spine.get_skeleton().set_skin_by_name("default")
       spine.get_animation_state().set_animation("human_idle", true)

   func walk():
       spine.get_animation_state().set_animation("human_walk", true)

   func jump():
       spine.get_animation_state().set_animation("human_jump", false)
   ```

---

## 📚 추가 리소스

### 공식 튜토리얼:
- **Spine 기본 사용법:** http://esotericsoftware.com/spine-quickstart
- **리깅 튜토리얼:** http://esotericsoftware.com/spine-basic-rigging
- **애니메이션 튜토리얼:** http://esotericsoftware.com/spine-animating

### 유튜브 튜토리얼:
- "Spine 2D Tutorial for Beginners" 검색
- "Hollow Knight Style Animation Spine" 검색

### Godot Spine 통합:
- https://github.com/EsotericSoftware/spine-runtimes/tree/4.2/spine-godot

---

## 💡 팁

1. **시작은 간단하게**
   - 처음엔 Idle만 만들어보기
   - 리깅이 제대로 됐는지 확인

2. **할로우 나이트 참고**
   - 추출한 프레임을 Spine에서 보며 타이밍 맞추기
   - Onion Skin 기능 활용

3. **IK 사용**
   - 다리는 IK로 설정하면 자연스러운 걷기
   - 망토도 IK로 흔들림 구현

4. **Graph Editor 활용**
   - Easing을 조절해서 부드러운 움직임
   - Hollow Knight는 주로 Ease In/Out 사용

---

## 🚀 빠른 시작 체크리스트

- [ ] Spine 2D 다운로드 및 설치
- [ ] 캐릭터 이미지를 레이어별로 분리
- [ ] Spine 프로젝트 생성
- [ ] 이미지 Import
- [ ] 기본 뼈대 만들기 (Root → Hip → Torso → Head)
- [ ] Idle 애니메이션 제작
- [ ] JSON Export
- [ ] Godot 플러그인 설치
- [ ] 게임에서 테스트

Spine은 처음엔 어렵지만, 한 번 익히면 매우 빠르고 강력합니다!
