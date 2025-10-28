# 🎯 하이브리드 전략: 할로우 나이트 + 우리 스토리

## 📋 핵심 전략

```
할로우 나이트 게임 (100%)
    ↓
캐릭터 & 스토리만 교체
    ↓
우리만의 게임
```

---

## ✅ 할로우 나이트에서 그대로 가져올 것 (100%)

### 1. 게임플레이 메커닉
- [x] 이동: 8.3 u/s, 즉시 가속/감속
- [x] 점프: Mega Man X 스타일
- [x] 공격: Old Nail 5 데미지, 0.41초 쿨다운
- [x] Soul 시스템: 11 per hit, 99 max
- [x] 대시: Mothwing Cloak
- [x] 이단점프: Monarch Wings
- [x] Focus: 33 Soul로 체력 회복

### 2. 적 & AI
- [x] Crawlid (8 HP, 느린 순찰)
- [x] Tiktik (8 HP, 벽 기어다님)
- [x] Gruzzer (8 HP, 돌진)
- [x] Wandering Husk (15 HP, 좀비)
- [x] 기타 할로우 나이트 적들

### 3. 레벨 디자인
- [x] Forgotten Crossroads 구조
- [x] 64px 블록아웃
- [x] HD 아트워크 수동 배치
- [x] 3-5 레이어 parallax
- [x] Soft transparent shapes 조명

### 4. 비주얼 스타일
- [x] 색상 팔레트: #1f2937, #4b5563, #6b7280 등
- [x] 어두운 분위기
- [x] 검은 외곽선
- [x] 아래쪽 그라디언트
- [x] Fog & atmospheric perspective

---

## 🎨 우리 것으로 교체할 것

### 1. 플레이어 캐릭터

#### 비주얼
```
할로우 나이트 Knight
    ↓ (스프라이트 교체)
우리 인간 모드 (108프레임 완성)
```

**매핑:**
- Idle → 우리 idle (6프레임)
- Walk → 우리 walk (12프레임)
- Jump → 우리 jump (18프레임)
- Attack → 우리 attack (36프레임)
- Dash → 우리 dodge (36프레임)

**색상:**
- 할로우 나이트 Knight: 흰색 + 검은 외곽선
- 우리 캐릭터: 그대로 사용 (이미 흰색 계열)

#### 스펙
```
할로우 나이트 그대로:
- 5 Masks (체력)
- Old Nail 5 데미지
- 8.3 이동 속도
- Soul 99
```

---

### 2. 듀얼 모드 시스템 변환

#### 기존 우리 시스템:
```
인간 모드 (Assassin)
악신 모드 (Berserker)
```

#### 할로우 나이트로 변환:
```
인간 모드 = Old Nail (시작)
악신 모드 = Pure Nail (최종 업그레이드)

또는

인간 모드 = 기본 상태
악신 모드 = Shade (죽었을 때 나타나는 그림자)
```

**추천: Nail 업그레이드 방식**
```
Old Nail (5 데미지) → 인간 모드 외형
Sharpened Nail (9) → 약간 어두워짐
Channelled Nail (13) → 더 어두워짐
Coiled Nail (17) → 거의 악신
Pure Nail (21) → 완전 악신 모드 외형
```

---

### 3. 스토리

#### 할로우 나이트 스토리 구조:
```
1. 시작: 지상에서 Hallownest로 하강
2. 탐험: Forgotten Crossroads
3. 능력 획득: Mothwing Cloak, Monarch Wings 등
4. 보스 전투: False Knight, Hornet 등
5. 진실: Hollow Knight, Radiance
```

#### 우리 스토리로 교체:
```
1. 시작: 타락한 신이 추방당하고 인간 세계로 떨어짐
2. 탐험: 고대 왕국의 유적 (Forgotten Crossroads 구조 재사용)
3. 능력 회복: 신의 힘을 조각조각 되찾음
   - Mothwing Cloak → "신속의 파편"
   - Monarch Wings → "비상의 파편"
4. 보스: 자신을 추방한 신들의 부하
5. 진실: 자신의 타락한 본성과 대면
```

#### 스토리 텍스트 (NPC 대화):
```
할로우 나이트:
"...Shaw!" (Hornet)
"...friend..." (Elderbug)

우리 게임:
"...인간의 몸에 갇힌 신이여..." (고대 현자)
"...복수는 또 다른 타락을 낳을 뿐..." (수호자)
```

---

## 📐 구체적 작업 계획

### Phase 1: 할로우 나이트 기반 구축 (7-10일)

#### 1.1 게임플레이 메커닉 (2-3일)
```gdscript
// player.gd 수정

// 할로우 나이트 스펙 그대로
const OLD_NAIL_DAMAGE = 5
const WALK_SPEED = 300.0
const JUMP_VELOCITY = -750.0
const ATTACK_COOLDOWN = 0.41
const SOUL_PER_HIT = 11
const MAX_SOUL = 99

// 듀얼 모드 → Nail 업그레이드로 변환
var nail_level = 1  // 1=Old, 2=Sharpened, ..., 5=Pure

func get_damage():
    match nail_level:
        1: return 5   # Old Nail (인간 모드 외형)
        2: return 9
        3: return 13
        4: return 17
        5: return 21  # Pure Nail (악신 모드 외형)
```

#### 1.2 레벨 디자인 (3-4일)
```
1. 64px 블록아웃 타일셋
2. Forgotten Crossroads 7개 방
3. Parallax 배경 (3-5 레이어)
4. Soft transparent shapes 조명
```

#### 1.3 적 AI (2-3일)
```
1. Crawlid (8 HP)
2. Tiktik (8 HP)
3. Gruzzer (8 HP)
```

---

### Phase 2: 우리 캐릭터/스토리 적용 (3-5일)

#### 2.1 캐릭터 스프라이트 교체 (1-2일)
```gdscript
// player.tscn

// 기존 할로우 나이트 Knight 스프라이트
// → 우리 인간 모드 108프레임으로 교체

[node name="AnimatedSprite2D"]
sprite_frames = "res://assets/sprites/player/player_frames.tres"
// 이미 완성된 108프레임 사용
```

#### 2.2 Nail 업그레이드 → 외형 변화 (1일)
```gdscript
func _update_appearance_by_nail_level():
    match nail_level:
        1, 2:
            # 인간 모드 외형 (밝음)
            animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
        3, 4:
            # 전환 중 (약간 어두워짐)
            animated_sprite.modulate = Color(0.8, 0.8, 0.9, 1.0)
        5:
            # 악신 모드 외형 (어두움)
            animated_sprite.modulate = Color(0.6, 0.5, 0.7, 1.0)
```

#### 2.3 스토리 텍스트 교체 (1-2일)
```
1. 방 이름 변경
   - "King's Pass" → "추방자의 통로"
   - "Crossroads Hub" → "잊혀진 왕국"

2. NPC 대화 작성
3. 보스 이름 변경
   - "False Knight" → "배신자 기사"

4. 능력 이름 변경
   - "Mothwing Cloak" → "신속의 파편"
```

---

## 🎯 최종 결과

### 게임플레이
```
100% 할로우 나이트
- 이동 느낌
- 전투 느낌
- 탐험 느낌
- 난이도
```

### 비주얼
```
99% 할로우 나이트
- 색상 팔레트
- 레벨 디자인
- 적 디자인

1% 우리 것
- 플레이어 스프라이트 (108프레임)
```

### 스토리
```
100% 우리 것
- "타락한 신의 복수"
- 인간의 몸에 갇힌 신
- 힘을 되찾는 여정
- 자신의 본성과 대면
```

---

## ✅ 작업 체크리스트

### Phase 1: 할로우 나이트 기반
- [ ] 플레이어 스펙 할로우 나이트로 조정
- [ ] 64px 타일셋 구축
- [ ] Forgotten Crossroads 레벨
- [ ] Crawlid, Tiktik, Gruzzer AI
- [ ] Parallax 배경
- [ ] Soft transparent shapes 조명

### Phase 2: 우리 것 적용
- [ ] 플레이어 스프라이트 교체 (108프레임)
- [ ] Nail 업그레이드 = 외형 변화
- [ ] 방 이름 한글화
- [ ] 스토리 텍스트 작성
- [ ] NPC 대화
- [ ] 보스/능력 이름 변경

---

## 🎮 플레이어 경험

**플레이어가 느끼는 것:**
1. "이거 할로우 나이트랑 똑같은데?" (게임플레이)
2. "어? 캐릭터가 다르네" (비주얼)
3. "스토리가 완전 다르네!" (스토리)

**결과:**
- 할로우 나이트의 검증된 재미
- 우리만의 캐릭터/스토리
- 할로우 나이트 팬들이 "이건 뭐지?" 관심

---

다음 단계: **Phase 1.1 - 플레이어 스펙 조정** 시작할까요?
