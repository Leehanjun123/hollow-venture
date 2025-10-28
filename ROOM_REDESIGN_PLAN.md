# Hollow Knight Style Room Redesign Plan
## 할로우 나이트 스타일 연결된 방 구조 재설계

> 참고 맵: `assets/references/forgotten_crossroads_map.png`

---

## 핵심 변경사항

### 기존 문제점
- ❌ 각 방이 독립적으로 설계됨
- ❌ 연결 구조가 단순 (왼쪽 ← → 오른쪽만)
- ❌ 방 크기가 획일적
- ❌ 할로우 나이트의 미로 같은 탐험 느낌 부족

### 새로운 설계 목표
- ✅ 모든 방이 유기적으로 연결 (상하좌우)
- ✅ 각 방마다 다른 크기와 모양
- ✅ 복잡한 탐험 경로
- ✅ 실제 할로우 나이트 맵 구조 재현

---

## 새로운 Room Layout

```
                    [Dirtmouth - 나중에]
                            |
                      ┌─────┴─────┐
                      │  Room 02  │  Central Hub (허브)
                      │    HUB    │  22x16 tiles (1408x1024)
        ┌─────────────┤           ├─────────────┐
        │             └─────┬─────┘             │
        │                   │                   │
  ┌─────┴─────┐       ┌─────┴─────┐       ┌─────┴─────┐
  │  Room 01  │       │  Room 04  │       │  Room 03  │
  │King's Pass│       │  Vertical │       │  Eastern  │
  │  HALLWAY  │       │   Shaft   │       │  Passage  │
  │30x12 tiles│       │10x30 tiles│       │28x12 tiles│
  │1920x768 px│       │640x1920 px│       │1792x768 px│
  └───────────┘       └─────┬─────┘       └───────────┘
                            │
                      ┌─────┴─────┐
                      │  Room 05  │  False Knight Arena
                      │   BOSS    │  28x22 tiles (1792x1408)
                      │           │
                      └─────┬─────┘
                            │
                      ┌─────┴─────┐
                      │  Room 06  │  Lower Passage
                      │  HALLWAY  │  25x14 tiles (1600x896)
                      └─────┬─────┘
                            │
                      ┌─────┴─────┐
                      │  Room 07  │  Mothwing Shrine
                      │ TREASURE  │  16x10 tiles (1024x640)
                      └───────────┘
```

---

## Room 상세 설계

### Room 01: King's Pass Entry (시작점)
```
크기: 30 x 12 타일 (1920 x 768 px)
타입: HALLWAY (긴 수평 복도)

연결:
  - 오른쪽 → Room 02 (Central Hub)

특징:
  - 게임 시작 지점
  - 단순한 직선 복도
  - 왼쪽에서 오른쪽으로 점진적 하강
  - 튜토리얼 역할

스폰 포인트:
  - StartPoint (X: 128, Y: 640)  - 게임 시작
  - LeftEntrance (X: 128, Y: 640) - 나중에 돌아올 때
  - RightExit → Room 02 연결 (X: 1856, Y: 512)

Transition:
  - RightExit: target="room_02_blockout.tscn", spawn="LeftEntrance"
```

### Room 02: Central Hub (중앙 허브)
```
크기: 22 x 16 타일 (1408 x 1024 px)
타입: HUB (4방향 연결 허브)

연결:
  - 왼쪽 ← Room 01 (King's Pass)
  - 오른쪽 → Room 03 (Eastern Passage)
  - 아래 ↓ Room 04 (Vertical Shaft)
  - 위 ↑ (나중에 Temple로 확장)

특징:
  - 탐험의 중심지
  - 여러 플랫폼 레벨
  - 복잡한 수직 구조
  - 4방향 선택 가능

스폰 포인트:
  - LeftEntrance (X: 128, Y: 512) ← Room 01에서
  - RightEntrance (X: 1344, Y: 512) ← Room 03에서
  - BottomEntrance (X: 704, Y: 960) ← Room 04에서

Transition:
  - LeftExit: target="room_01_blockout.tscn", spawn="RightExit"
  - RightExit: target="room_03_blockout.tscn", spawn="LeftEntrance"
  - BottomExit: target="room_04_blockout.tscn", spawn="TopEntrance"
```

### Room 03: Eastern Passage
```
크기: 28 x 12 타일 (1792 x 768 px)
타입: HALLWAY (긴 수평 복도)

연결:
  - 왼쪽 ← Room 02 (Central Hub)
  - 오른쪽 → (나중에 Crystal Peak로 확장)

특징:
  - 동쪽으로 가는 주요 통로
  - 약간의 전투 요소
  - 플랫폼 레벨 2~3개

스폰 포인트:
  - LeftEntrance (X: 128, Y: 640) ← Room 02에서
  - RightExit (X: 1728, Y: 640)

Transition:
  - LeftExit: target="room_02_blockout.tscn", spawn="RightEntrance"
```

### Room 04: Vertical Shaft Down
```
크기: 10 x 30 타일 (640 x 1920 px)
타입: VERTICAL_SHAFT (높고 좁은 수직 통로)

연결:
  - 위 ↑ Room 02 (Central Hub)
  - 아래 ↓ Room 05 (False Knight Arena)

특징:
  - 매우 좁고 높음
  - 아래로 떨어지는 긴장감
  - 벽에 작은 플랫폼들
  - 떨어지면서 적 회피

스폰 포인트:
  - TopEntrance (X: 320, Y: 128) ← Room 02에서
  - BottomEntrance (X: 320, Y: 1856) ← Room 05에서

Transition:
  - TopExit: target="room_02_blockout.tscn", spawn="BottomEntrance"
  - BottomExit: target="room_05_blockout.tscn", spawn="TopEntrance"
```

### Room 05: False Knight Arena
```
크기: 28 x 22 타일 (1792 x 1408 px)
타입: BOSS_ARENA (보스 전투 공간)

연결:
  - 위 ↑ Room 04 (Vertical Shaft)
  - 오른쪽 → Room 06 (Lower Passage)

특징:
  - 크고 개방된 공간
  - 플랫폼 최소화 (전투 집중)
  - False Knight 보스 (나중에 구현)
  - 보스 처치 후 오른쪽 문 열림

스폰 포인트:
  - TopEntrance (X: 896, Y: 192) ← Room 04에서
  - RightExit (X: 1728, Y: 1216)

Transition:
  - TopExit: target="room_04_blockout.tscn", spawn="BottomEntrance"
  - RightExit: target="room_06_blockout.tscn", spawn="LeftEntrance"
```

### Room 06: Lower Passage
```
크기: 25 x 14 타일 (1600 x 896 px)
타입: HALLWAY (중간 크기 수평 복도)

연결:
  - 왼쪽 ← Room 05 (False Knight Arena)
  - 오른쪽 → Room 07 (Mothwing Shrine)

특징:
  - 보스방 이후 조용한 복도
  - 중간 난이도 플랫폼
  - 다음 목적지로 연결

스폰 포인트:
  - LeftEntrance (X: 128, Y: 704) ← Room 05에서
  - RightExit (X: 1536, Y: 704)

Transition:
  - LeftExit: target="room_05_blockout.tscn", spawn="RightExit"
  - RightExit: target="room_07_blockout.tscn", spawn="LeftEntrance"
```

### Room 07: Mothwing Shrine
```
크기: 16 x 10 타일 (1024 x 640 px)
타입: TREASURE (보물방 - 대칭 구조)

연결:
  - 왼쪽 ← Room 06 (Lower Passage)

특징:
  - 작고 대칭적인 성소
  - 중앙에 Mothwing Cloak
  - 신성한 분위기
  - 막다른 방 (보물 획득 후 돌아감)

스폰 포인트:
  - LeftEntrance (X: 128, Y: 512) ← Room 06에서
  - CenterPedestal (X: 512, Y: 256) - Mothwing Cloak 위치

Transition:
  - LeftExit: target="room_06_blockout.tscn", spawn="RightExit"
```

---

## 구현 단계

### 1단계: 기본 구조 수정 ✓
- [x] 맵 분석 완료
- [x] 방 레이아웃 설계 완료
- [x] 참고 맵 이미지 프로젝트에 추가

### 2단계: 각 Room 스크립트 수정
- [ ] Room 01 크기 및 연결 수정
- [ ] Room 02 크기 및 연결 수정 (4방향)
- [ ] Room 03 크기 및 연결 수정
- [ ] Room 04 크기 및 연결 수정 (수직)
- [ ] Room 05 크기 및 연결 수정 (보스방)
- [ ] Room 06 크기 및 연결 수정
- [ ] Room 07 크기 및 연결 수정

### 3단계: TileMap 에디터로 실제 맵 그리기
- [ ] 각 방에 참고 이미지 Sprite2D 추가
- [ ] TileMap 에디터로 정확한 지형 그리기
- [ ] 충돌 테스트

### 4단계: Transition 테스트
- [ ] 모든 방 연결 테스트
- [ ] 스폰 포인트 정확도 확인
- [ ] 플레이어 이동 자연스러움 확인

---

## TileMap 에디터 사용 가이드

### 참고 이미지 추가 방법:

1. **각 Room .tscn 파일 열기**
2. **Sprite2D 노드 추가**:
   - Room root 노드 우클릭 → Add Child Node → Sprite2D
   - 이름: "ReferenceImage"
3. **이미지 로드**:
   - Inspector → Texture → Load
   - `assets/references/forgotten_crossroads_map.png` 선택
4. **반투명 설정**:
   - Inspector → CanvasItem → Modulate
   - Alpha를 128 (50%) 정도로 설정
5. **레이어 설정**:
   - Inspector → Ordering → Z Index = -1 (타일맵 뒤에)
6. **위치 조정**:
   - 해당 방 부분이 보이도록 이미지 위치/스케일 조정

### TileMap으로 그리기:

1. **TileMap 노드 선택**
2. **하단 TileMap 탭 클릭**
3. **타일 선택 후 페인팅**:
   - Solid Tile (source 0): 벽, 바닥, 천장
   - Platform Tile (source 1): 일방통행 플랫폼
4. **참고 이미지 보면서 따라 그리기**
5. **완성 후 ReferenceImage 노드 삭제 또는 비활성화**

---

## 다음 작업

이제 각 Room 스크립트를 수정해서 새로운 크기와 연결 구조를 적용하겠습니다.

할로우 나이트처럼 완벽하게 연결된 미로 구조가 될 것입니다!
