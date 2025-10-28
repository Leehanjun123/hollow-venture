# 엔딩 결정 시스템 - 추적 & 계산

## 🎯 핵심 원칙

**"플레이어가 모르는 사이에 여러 요소를 추적하여 엔딩 결정"**

---

## 📊 추적 요소 (5가지)

### 1. 모드 사용 시간
```
가장 기본적인 측정

추적 방법:
- 매 프레임마다 현재 모드 체크
- 악신 모드 시간 누적
- 인간 모드 시간 누적

예시:
악신 모드: 45분 30초
인간 모드: 34분 20초
총 플레이: 79분 50초

악신 비율: 57%
```

### 2. 적 처치 수 (모드별)
```
어느 모드로 적을 더 많이 죽였나

추적 방법:
- 적이 죽을 때 현재 모드 기록
- 각 모드별 처치 수 누적

예시:
악신 모드 처치: 420마리
인간 모드 처치: 180마리
총 처치: 600마리

악신 비율: 70%
```

### 3. 보스 처치 모드 (가중치 높음) ⭐
```
보스를 어느 모드로 죽였나가 중요

추적 방법:
- 보스 체력 0될 때 현재 모드 기록
- 보스는 일반 적보다 10배 가중치

예시:
보스 1: 악신 모드로 처치 (가중치 10)
보스 2: 인간 모드로 처치 (가중치 10)
보스 3: 악신 모드로 처치 (가중치 10)
...
보스 10: 악신 모드로 처치 (가중치 10)

악신으로 처치한 보스: 7개
인간으로 처치한 보스: 3개

악신 비율: 70%
```

### 4. 특수 능력 사용 횟수
```
어느 모드의 특수 능력을 더 많이 썼나

추적 방법:
- 광폭화 사용 횟수
- 패링 성공 횟수
- 완벽 회피 횟수

예시:
광폭화 사용: 120회
패링 성공: 45회

악신 활용도가 높음
```

### 5. 중요 이벤트 선택 (특정 순간)
```
스토리 중요 순간의 선택

예시:
- NPC를 구할 때 어느 모드였나
- 특정 아이템을 얻을 때 어느 모드였나
- 비밀 이벤트 발동 시 어느 모드였나

각 이벤트마다 가중치 부여
```

---

## 🧮 점수 계산 공식

### 기본 공식
```javascript
// 1. 시간 점수 (기본 40% 비중)
const timeScore = {
  evil: evilModeTime * 1.0,
  human: humanModeTime * 1.0
}

// 2. 처치 점수 (20% 비중)
const killScore = {
  evil: evilModeKills * 0.5,
  human: humanModeKills * 0.5
}

// 3. 보스 점수 (30% 비중) - 가장 중요!
const bossScore = {
  evil: bossKilledAsEvil * 10.0,
  human: bossKilledAsHuman * 10.0
}

// 4. 스킬 점수 (10% 비중)
const skillScore = {
  evil: rageUseCount * 0.3,
  human: parrySuccessCount * 0.5
}

// 총점 계산
const totalEvil = timeScore.evil + killScore.evil + bossScore.evil + skillScore.evil
const totalHuman = timeScore.human + killScore.human + bossScore.human + skillScore.human

// 비율 계산
const evilRatio = totalEvil / (totalEvil + totalHuman) * 100
```

### 실제 예시
```
플레이어 A (공격형):

시간:
- 악신: 50분 → 50점
- 인간: 30분 → 30점

처치:
- 악신: 400마리 → 200점
- 인간: 200마리 → 100점

보스 (10명):
- 악신으로 처치: 8명 → 80점
- 인간으로 처치: 2명 → 20점

스킬:
- 광폭화: 100회 → 30점
- 패링: 20회 → 10점

총점:
악신: 50 + 200 + 80 + 30 = 360점
인간: 30 + 100 + 20 + 10 = 160점

악신 비율: 360 / 520 = 69.2%
→ 악신 엔딩!
```

---

## 🎮 엔딩 분기점

### 3단계 분기
```
악신 비율 65% 이상 → 악신 엔딩
인간 비율 65% 이상 → 인간 엔딩 (악신 35% 이하)
35-65% → 중립 엔딩
```

### 세부 엔딩
```
악신 90%+ → 완전 타락 엔딩 (최악)
악신 65-90% → 악신 엔딩
중립 35-65% → 중립 엔딩 (최종 선택)
인간 65-90% → 인간 엔딩
인간 90%+ → 완전 구원 엔딩 (진엔딩)
```

---

## 🔍 플레이어에게 보이는 것

### 보이지 않음 ❌
```
- 악신 비율 퍼센트
- 점수 숫자
- "악신 점수 +10" 같은 알림
- 명확한 게이지
```

### 미묘하게 암시 ✅
```
1. 캐릭터 외형 변화
   - 악신 쪽: 눈빛 붉어짐, 어두운 오라
   - 인간 쪽: 눈빛 밝음, 밝은 오라

2. NPC 반응
   - "당신의 눈빛이... 변했군요"
   - "당신에게서 두려운 힘이 느껴집니다"

3. 환경 변화
   - 악신 쪽: 주변 식물 시들음
   - 인간 쪽: 작은 동물들 다가옴

4. 메뉴 UI
   - 악신 쪽: 배경 점점 어두워짐
   - 인간 쪽: 배경 밝고 따뜻함
```

---

## 💾 저장 데이터 구조

### 세이브 파일에 기록
```javascript
{
  // 플레이어에게 보이는 정보
  playerName: "주인공",
  level: 25,
  health: 120,
  currentArea: "화염의 폐허",

  // 숨겨진 추적 정보 (플레이어 안 보임)
  _tracking: {
    evilModeTime: 2730,        // 초 단위
    humanModeTime: 2060,
    evilKills: 420,
    humanKills: 180,
    bossKillMode: [
      "evil",    // 보스 1
      "human",   // 보스 2
      "evil",    // 보스 3
      "evil",    // 보스 4
      "human",   // 보스 5
      // ...
    ],
    rageUseCount: 120,
    parrySuccessCount: 45,
    perfectDodgeCount: 30,

    // 중요 이벤트
    importantEvents: [
      { event: "npc_save_1", mode: "human" },
      { event: "secret_item_1", mode: "evil" },
      // ...
    ]
  }
}
```

---

## 🎯 보스전 특수 처리

### 보스를 어느 모드로 죽였나가 가장 중요
```
이유:
- 보스전은 게임의 하이라이트
- 플레이어가 "진짜 선호하는 모드" 사용
- 10개 보스 = 명확한 측정 기준

예시:
10개 보스 중 7개를 악신 모드로 처치
→ 명확하게 악신 선호

보스 마지막 일격 시점의 모드 기록:
```javascript
function onBossDeath() {
  const currentMode = player.getCurrentMode() // "evil" or "human"

  // 보스 처치 모드 기록
  tracking.bossKillMode.push(currentMode)

  // 보스는 가중치 10배
  if (currentMode === "evil") {
    tracking.evilScore += 10
  } else {
    tracking.humanScore += 10
  }
}
```

---

## 📈 실시간 계산 (플레이어 안 보임)

### 매 프레임 업데이트
```javascript
class GameTracker {
  update(deltaTime) {
    // 현재 모드 시간 누적
    if (player.mode === "evil") {
      this.evilModeTime += deltaTime
    } else {
      this.humanModeTime += deltaTime
    }

    // 비율 계산 (내부적으로만)
    this.calculateRatio()

    // 외형 변화 업데이트
    this.updatePlayerAppearance()
  }

  calculateRatio() {
    const total = this.evilScore + this.humanScore
    this.evilRatio = (this.evilScore / total) * 100

    // 단계별 변화 (0-25%, 25-50%, 50-75%, 75-100%)
    this.corruptionLevel = Math.floor(this.evilRatio / 25)
  }

  updatePlayerAppearance() {
    // 비율에 따라 외형 변화
    if (this.evilRatio > 75) {
      player.setAppearance("heavy_corruption")
    } else if (this.evilRatio > 50) {
      player.setAppearance("medium_corruption")
    } else if (this.evilRatio > 25) {
      player.setAppearance("light_corruption")
    } else {
      player.setAppearance("pure")
    }
  }
}
```

---

## 🎬 엔딩 결정 시점

### 최종 보스 처치 직후
```javascript
function onFinalBossDefeated() {
  // 최종 점수 계산
  const finalScore = tracker.calculateFinalScore()
  const evilRatio = finalScore.evilRatio

  console.log(`악신 비율: ${evilRatio.toFixed(1)}%`) // 개발용 로그

  // 엔딩 결정
  let ending = null

  if (evilRatio >= 90) {
    ending = "COMPLETE_CORRUPTION"  // 완전 타락
  } else if (evilRatio >= 65) {
    ending = "EVIL_ENDING"          // 악신 엔딩
  } else if (evilRatio >= 35) {
    ending = "NEUTRAL_ENDING"       // 중립 (최종 선택)
  } else if (evilRatio >= 10) {
    ending = "HUMAN_ENDING"         // 인간 엔딩
  } else {
    ending = "TRUE_ENDING"          // 진엔딩 (완전 구원)
  }

  // 엔딩 재생
  playEnding(ending)
}
```

---

## 🔒 조작 방지

### 플레이어가 의도적으로 조작 못하게
```
문제:
"엔딩 보려고 마지막에만 특정 모드 사용"

해결:
1. 보스 처치 모드 가중치 높임
   - 마지막에만 바꿔도 이미 늦음

2. 시간 누적
   - 전체 플레이타임이 쌓임

3. 외형 변화로 암시
   - 중간에 "어? 내가 너무 악신 썼나?" 깨달음

4. 중립 엔딩 존재
   - 애매하면 최종 선택 가능
   - 완벽한 조작 불필요
```

---

## ✨ 플레이어 경험

### 1회차
```
플레이어: "악신 모드 재밌네!"
→ 계속 악신 모드 사용
→ (몰래) 악신 점수 쌓임
→ 중반: "어? 눈빛이 붉어졌어..."
→ 후반: "NPC들이 날 무서워해..."
→ 엔딩: "악신으로 타락..."
→ "아... 내가 악신 모드를 너무 많이 써서..."
```

### 2회차 (의도적 변경)
```
플레이어: "이번엔 인간 모드로 해보자"
→ 인간 모드 위주 플레이
→ 외형이 밝게 유지됨
→ NPC들이 친근함
→ 엔딩: "인간으로 남음"
→ 완전히 다른 경험!
```

---

## 🎯 핵심 포인트

1. **보스 처치 모드가 가장 중요 (30% 가중치)**
2. **시간 + 처치 수 + 스킬 사용 복합 측정**
3. **숫자로 안 보여주고 외형/환경으로 암시**
4. **65% 기준으로 엔딩 분기**
5. **중립 엔딩으로 애매한 경우 대응**
