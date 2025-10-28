# 🕳️ Ancient Cavern - 레벨 디자인

**지역명**: Ancient Cavern (고대 동굴)
**보스**: Centipede of a Thousand Legs (천족 지네)
**테마**: 어둡고 습한 지하 동굴, 고대 유적의 흔적

할로우 나이트의 Forgotten Crossroads + Deepnest 스타일

---

## 🎨 분위기 & 컨셉

### 핵심 키워드
- **어둠**: 대부분이 어두움, 포인트 조명만
- **고립감**: 지하 깊숙이 갇힌 느낌
- **고대**: 오래된 석조 구조물, 무너진 기둥
- **생명**: 발광 버섯, 미세한 빛
- **위험**: 센티피드의 영역

### 색상 팔레트

**Base Colors**:
- `#0d0d12` (거의 검정, 배경)
- `#1a1a22` (어두운 회색-파랑)
- `#2a2520` (어두운 갈색, 흙/돌)

**Accent Colors**:
- `#4a3520` (돌 하이라이트)
- `#2a4a3a` (발광 버섯 - 청록색)
- `#5a3510` (횃불 빛 - 주황)

**Lighting**:
- `#ff8833` (따뜻한 횃불빛)
- `#33ccaa` (차가운 버섯빛)

---

## 🗺️ 레벨 레이아웃 (기본 구조)

### 크기
- **너비**: 1920px (60타일)
- **높이**: 약 1080px (34타일)
- **구간**: 3개 구간으로 나뉨

### 구간 구조

```
[입구 구간] ────→ [중앙 홀] ────→ [보스방 입구]
0-600px          600-1400px      1400-1920px

높이 변화:
  ╱───╲        ╱────────╲         ╱─────
 ╱     ╲      ╱          ╲       ╱
───     ────────           ──────
```

### 구간별 특징

**1. 입구 구간 (0-600px)**
- 플레이어 스폰 지점
- 약간 높은 플랫폼에서 시작
- 아래로 내려가는 구조
- 적 1-2마리

**2. 중앙 홀 (600-1400px)**
- 가장 넓은 공간
- 높이 차이가 큰 플랫폼들
- 적 4-5마리
- 고대 유적 구조물
- 발광 버섯

**3. 보스방 입구 (1400-1920px)**
- 다시 올라가는 구조
- 보스방으로 이어지는 통로
- 긴장감 조성 (조명 어두워짐)
- 적 2마리

---

## 🎨 배경 Sprite 목록

### Layer 1: Sky (고정 배경)
- 단순 그라데이션 (검정 → 어두운 회색)
- ColorRect로 구현

---

### Layer 2: Far Background (원경, motion_scale 0.2)

**필요한 Sprite**:

1. **stalactite_large.png** (큰 종유석)
   - 크기: 300x400px
   - 색상: #1a1a22
   - 천장에서 내려옴

2. **stalactite_medium.png** (중간 종유석)
   - 크기: 200x300px
   - 색상: #1a1a22

3. **stalactite_small.png** (작은 종유석)
   - 크기: 120x200px
   - 색상: #1a1a22

4. **distant_pillar.png** (멀리 보이는 석조 기둥)
   - 크기: 150x500px
   - 색상: #2a2520
   - 고대 유적 느낌

---

### Layer 3: Mid Background (중경, motion_scale 0.5)

**필요한 Sprite**:

1. **stone_column_broken.png** (부서진 돌기둥)
   - 크기: 200x450px
   - 색상: #2a2520 + #4a3520 하이라이트
   - 균열, 이끼

2. **stone_column_intact.png** (온전한 돌기둥)
   - 크기: 180x500px
   - 색상: #2a2520

3. **ancient_statue.png** (고대 석상)
   - 크기: 250x400px
   - 색상: #2a2520
   - 얼굴이 부서진 조각상

4. **cave_wall_detail.png** (동굴 벽 디테일)
   - 크기: 300x300px
   - 색상: #1a1a22
   - 바위 질감

5. **glowing_mushroom_cluster.png** (발광 버섯 군집)
   - 크기: 150x120px
   - 색상: #2a4a3a (청록색 발광)
   - 은은한 빛

---

### Layer 4: Foreground (전경, motion_scale 0.8)

**필요한 Sprite**:

1. **stalagmite_large.png** (큰 석순)
   - 크기: 120x200px
   - 색상: #0d0d12 (거의 검정)
   - 바닥에서 솟아오름

2. **stalagmite_small.png** (작은 석순)
   - 크기: 60x100px
   - 색상: #0d0d12

3. **rock_sharp.png** (날카로운 바위)
   - 크기: 80x60px
   - 색상: #0d0d12

4. **hanging_roots.png** (매달린 뿌리)
   - 크기: 100x150px
   - 색상: #1a1a22
   - 천장에서 늘어짐

5. **mist_patch.png** (안개 패치)
   - 크기: 200x100px
   - 색상: #1a1a22, 반투명
   - 바닥 근처

---

## 💡 조명 시스템

### PointLight2D 배치

**횃불 조명** (따뜻한 빛):
- 위치: 벽에 붙은 횃불 sprite 위치
- Color: `#ff8833`
- Energy: 0.8
- Range: 300px
- Texture: radial gradient

**버섯 조명** (차가운 빛):
- 위치: 발광 버섯 위치
- Color: `#33ccaa`
- Energy: 0.5
- Range: 200px

**전체 톤** (CanvasModulate):
- Color: `#0a0a0f` (매우 어둡게)

---

## 🎯 지형 레이아웃 (타일맵)

### Y축 레벨 (0 = 화면 상단)

```
Y = -200 ~ 0:    천장 (타일 없음, 종유석만)
Y = 0:           플레이어 스폰 플랫폼
Y = 200:         첫 번째 하강 플랫폼
Y = 400:         중앙 바닥
Y = 300:         중앙 플랫폼 (점프용)
Y = 500:         최하단 바닥
Y = 200:         보스방 입구 플랫폼
```

### X축 구간별 높이

```
X=0-200:     Y=0 (시작 플랫폼)
X=200-400:   Y=200 (하강)
X=400-800:   Y=400 (중앙 바닥)
X=800-1000:  Y=300 (중앙 플랫폼)
X=1000-1400: Y=400 (중앙 바닥)
X=1400-1600: Y=200 (상승)
X=1600-1920: Y=0 (보스방 입구)
```

---

## 🎮 게임플레이 요소

### 플랫폼 배치
- **점프 구간**: 중앙 홀에 3-4개 플랫폼
- **숨겨진 공간**: 천장 근처 비밀 플랫폼 (나중에 이중 점프로 접근)
- **안전 지대**: 적이 없는 작은 플랫폼

### 적 배치
- **Plains Worm** → **Cave Crawler** (이름 변경)
- **Wing Dragonfly** → **Cave Bat** (동굴 박쥐)
- **Rock Beetle** → 유지 (돌 벌레는 동굴에도 맞음)
- **Plains Mantis** → **Stone Guardian** (중간 보스급)

### 인터랙션 요소
- 발광 버섯 (밟으면 밝아짐?)
- 떨어지는 종유석 (위험 요소)
- 무너진 다리

---

## 📐 배경 오브젝트 배치 계획

### Layer 2 (원경)
```
X=200:  stalactite_large (천장)
X=500:  distant_pillar
X=900:  stalactite_medium (천장)
X=1300: distant_pillar
X=1600: stalactite_large (천장)
```

### Layer 3 (중경)
```
X=150:  stone_column_broken
X=400:  glowing_mushroom_cluster (바닥)
X=700:  ancient_statue
X=1000: stone_column_intact
X=1200: glowing_mushroom_cluster (벽)
X=1500: stone_column_broken
X=1800: cave_wall_detail
```

### Layer 4 (전경)
```
X=100:  stalagmite_small (바닥)
X=350:  hanging_roots (천장)
X=600:  stalagmite_large (바닥)
X=900:  rock_sharp (바닥)
X=1100: mist_patch (바닥)
X=1400: stalagmite_small (바닥)
X=1700: hanging_roots (천장)
```

---

## 🎨 타일셋 요구사항

### 필요한 타일 (32x32 그리드)

**Row 1**: 동굴 바닥 (걸을 수 있음)
- 평평한 돌 바닥 (3종류)

**Row 2**: 동굴 벽 (막힘)
- 거친 바위 벽 (3종류)

**Row 3**: 플랫폼 (뚫고 지나갈 수 있음)
- 얇은 돌 플랫폼 (3종류)

**색상**: 어두운 갈색/회색 (#2a2520, #3a3530)

---

## ✅ 다음 단계

1. **레벨 레이아웃 확정** - 이 문서 기반으로 스케치
2. **Sprite 생성** - Gemini 프롬프트로 14개 sprite 생성
3. **타일셋 생성** - 192x96 그리드
4. **Godot 구현** - Parallax + TileMap
5. **조명 추가** - Light2D 노드들
6. **폴리시** - 분위기 조정

---

**이 레벨이 완성되면 할로우 나이트급 첫 지역 완성!** 🎯
