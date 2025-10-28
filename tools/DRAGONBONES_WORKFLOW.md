# 🐉 DragonBones 워크플로우 (무료 Spine 대안)

## 왜 DragonBones?

- ✅ **완전 무료** (제한 없음)
- ✅ Spine과 거의 동일한 기능
- ✅ Godot 공식 지원
- ✅ 할로우 나이트급 애니메이션 가능

---

## 1️⃣ 설치

### DragonBones Pro 다운로드:

**공식 사이트:** https://dragonbones.github.io/en/download.html

**다운로드 링크:**
- Windows: https://dragonbones.github.io/download/DragonBonesPro-v5.6.0-win64.zip
- Mac: https://dragonbones.github.io/download/DragonBonesPro-v5.6.0-mac.zip

**설치:**
1. ZIP 파일 다운로드
2. 압축 해제
3. DragonBones Pro 실행

---

## 2️⃣ 캐릭터 레이어 분리

DragonBones도 Spine과 동일하게 부위별 분리 필요:

```
character/
├── head/
│   ├── mask.png          (마스크/얼굴)
│   ├── eyes.png          (눈)
├── body/
│   ├── torso.png         (몸통)
│   ├── cloak.png         (망토)
└── legs/
    ├── leg_left.png      (왼쪽 다리)
    ├── leg_right.png     (오른쪽 다리)
    ├── foot_left.png     (왼쪽 부츠)
    └── foot_right.png    (오른쪽 부츠)
```

---

## 3️⃣ DragonBones 프로젝트 생성

### 새 프로젝트:

1. DragonBones Pro 실행
2. `New Project` 클릭
3. 프로젝트 이름: `hollow-venture-player`
4. 저장 위치: `assets/sprites/player/dragonbones/`

### 이미지 Import:

1. `Library` 패널에서 `Import` 클릭
2. 모든 PNG 파일 선택
3. 자동으로 라이브러리에 추가됨

---

## 4️⃣ 아마추어(Armature) 만들기

### 뼈대 구조:

```
root
└── hip
    ├── body
    │   ├── cloak
    │   └── head
    │       └── eyes
    ├── leg_L
    │   └── foot_L
    └── leg_R
        └── foot_R
```

### 리깅 순서:

1. **Scene 패널에서 `Create Armature`**

2. **Bone Tool 선택**
   - 단축키: `B`

3. **뼈 생성:**
   - 캐릭터 중심에서 클릭 (Root)
   - 엉덩이 위치 클릭 (Hip)
   - 몸통 중심 클릭 (Body)
   - 머리 위치 클릭 (Head)
   - 다리 좌우 생성

4. **이미지 연결:**
   - 각 Bone 선택
   - Library에서 이미지를 Scene으로 드래그
   - Bone에 연결

---

## 5️⃣ 애니메이션 제작

### Idle 애니메이션:

1. `Animation` 패널에서 `New Animation`
2. 이름: `idle`
3. Duration: 1000ms (1초)

**Keyframes:**
- Frame 0: 시작 자세
- Frame 500: Body를 Y축 -5px (호흡)
- Frame 1000: 시작 자세로 복귀

**Tip:** `Auto Key` 활성화하면 자동으로 키프레임 생성

### Walk 애니메이션:

1. 새 애니메이션: `walk`
2. Duration: 600ms

**Keyframes:**
- 다리를 번갈아 앞뒤로
- 몸통 약간 위아래
- 망토 흔들림

### Jump 애니메이션:

1. 새 애니메이션: `jump`
2. Duration: 800ms

**Keyframes:**
- 0ms: 웅크림
- 200ms: 도약
- 400ms: 공중 자세
- 600ms: 착지 준비
- 800ms: 착지

---

## 6️⃣ Export

### JSON Export:

1. `File → Export → Export Data`
2. Format: **JSON**
3. 저장 위치: `assets/sprites/player/dragonbones/`
4. 파일명: `player_ske.json`

**생성 파일:**
- `player_ske.json` (스켈레톤 데이터)
- `player_tex.json` (텍스처 데이터)
- `player_tex.png` (텍스처 아틀라스)

---

## 7️⃣ Godot 통합

### Godot DragonBones 플러그인 설치:

**방법 1: AssetLib (추천)**

1. Godot에서 `AssetLib` 탭
2. "DragonBones" 검색
3. 설치

**방법 2: 수동 설치**

```bash
cd your-godot-project/addons
git clone https://github.com/sealinesun/DragonBones2D.git dragonbones
```

**플러그인 활성화:**
- Project → Project Settings → Plugins
- DragonBones 체크

### 씬에 추가:

1. **DragonBones 노드 추가:**
   - Scene에서 `+` → `DragonBones` 검색
   - `DragonBones` 노드 추가

2. **파일 연결:**
   ```gdscript
   # player.gd
   extends DragonBones

   func _ready():
       # 애니메이션 파일 로드
       resource = preload("res://assets/sprites/player/dragonbones/player_ske.json")

       # 기본 애니메이션 재생
       play("idle", -1)  # -1 = 무한 반복

   func walk():
       play("walk", -1)

   func jump():
       play("jump", 1)  # 1번만 재생
   ```

3. **스크립트에서 사용:**
   ```gdscript
   # 애니메이션 전환
   if velocity.x != 0:
       $DragonBones.play("walk", -1)
   else:
       $DragonBones.play("idle", -1)

   if Input.is_action_just_pressed("jump"):
       $DragonBones.play("jump", 1)
   ```

---

## 📚 튜토리얼 리소스

### 공식 문서:
- **DragonBones 공식 문서:** https://github.com/DragonBones/DragonBonesJS/tree/master/Egret
- **DragonBones 유튜브:** https://www.youtube.com/channel/UCzLfW2tD5vdFLKLsKs3TFHg

### 유튜브 튜토리얼:
- "DragonBones Tutorial for Beginners"
- "2D Game Animation DragonBones"

### Godot 통합:
- https://github.com/sealinesun/DragonBones2D

---

## 💡 DragonBones vs Spine 비교

| 기능 | DragonBones | Spine |
|------|-------------|-------|
| 가격 | **무료** | $69-369 |
| 리깅 | ✅ 동일 | ✅ |
| 애니메이션 | ✅ 동일 | ✅ |
| IK | ✅ | ✅ |
| Mesh Deform | ❌ | ✅ (Pro) |
| Godot 지원 | ✅ | ✅ |
| 커뮤니티 | 중간 | 큼 |

**결론:** 할로우 나이트급 애니메이션은 DragonBones로 충분히 가능!

---

## 🚀 빠른 시작 (30분)

### 체크리스트:

- [ ] DragonBones Pro 다운로드 (5분)
- [ ] 현재 캐릭터 이미지를 부위별로 분리 (10분)
- [ ] DragonBones 프로젝트 생성 및 이미지 import (3분)
- [ ] 기본 뼈대 만들기 (5분)
- [ ] Idle 애니메이션 제작 (5분)
- [ ] JSON Export (1분)
- [ ] Godot에서 테스트 (1분)

---

## 🎯 추천 학습 순서

1. **DragonBones 설치** (지금 바로)
2. **공식 튜토리얼 영상 하나 보기** (20분)
3. **간단한 테스트 캐릭터로 연습** (30분)
4. **실제 게임 캐릭터 작업** (1-2시간)

DragonBones는 무료지만 Spine만큼 강력합니다!
