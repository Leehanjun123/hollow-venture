# 🎬 Gemini 동영상 생성 프롬프트 가이드

## 📌 **중요 규칙**
- ✅ **얼굴/마스크는 절대 변형하지 말 것**
- ✅ **제공된 이미지의 스타일 유지**
- ✅ **3-5초 루프 애니메이션**
- ✅ **부드러운 움직임 (smooth, fluid motion)**
- ✅ **사이드뷰 유지 (side view)**

---

## 👤 **인간 모드 (Human Mode)**

### **기본 설정:**
- 베이스 이미지: `human_base.png` (Image #1)
- 스타일: 중립적, 어쌔신 같은, 우아한 움직임
- 색상: 검은 망토, 흰 마스크, 은색 검

---

### **1. Idle Animation (3초 루프)**

**Gemini 프롬프트:**
```
Keep this character's face, mask, and head position EXACTLY as shown. Do not change the face, mask design, or head angle AT ALL.

IMPORTANT: The head must stay completely still. The mouth expression must not change.

Animate this 2D game character with subtle idle breathing motion:
- Very gentle up and down movement (breathing) - BODY ONLY, not head
- Cloak flowing slightly in a gentle breeze
- Sword held steady at side
- Head position COMPLETELY FIXED - no tilting, no bobbing, no movement
- Face expression FROZEN - mouth stays the same
- Maintain side view throughout
- Smooth, looping animation
- 3 seconds duration
- Professional 2D game sprite animation style
- Keep the character centered in frame

The character should feel alive but calm, with only the cloak and subtle body breathing moving.
```

**한국어 버전:**
```
이 캐릭터의 얼굴, 마스크, 머리 위치를 정확히 그대로 유지하세요. 얼굴, 마스크 디자인, 고개 각도를 절대 변경하지 마세요.

중요: 머리는 완전히 고정되어야 합니다. 입 표정도 변경되면 안 됩니다.

이 2D 게임 캐릭터에 미묘한 대기 호흡 모션을 추가하세요:
- 매우 부드러운 상하 움직임 (호흡) - 몸통만, 머리는 절대 안 됨
- 망토가 약한 바람에 살짝 흔들림
- 검은 옆에서 안정적으로 유지
- 머리 위치 완전 고정 - 기울임, 움직임 절대 금지
- 얼굴 표정 고정 - 입 모양 그대로 유지
- 사이드뷰 유지
- 부드럽고 반복 가능한 애니메이션
- 3초 길이
- 전문적인 2D 게임 스프라이트 애니메이션 스타일
- 캐릭터를 프레임 중앙에 유지

캐릭터는 살아있지만 차분하게, 망토와 미묘한 몸통 호흡만 움직여야 합니다.
```

---

### **2. Walk Animation (4초 루프)**

**Gemini 프롬프트:**
```
Keep this character's face and mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character walking in place (side view):
- Smooth walking cycle with natural leg movement
- Cloak flowing backward from motion
- Subtle up-down body bob while walking
- Sword swaying slightly with movement
- Arms moving naturally with walk
- Head stays level
- Walking speed: calm, measured pace (not running)
- 4 seconds duration for full walk cycle
- Loop seamlessly
- Maintain side view facing right

The walk should feel graceful and controlled, like an assassin moving carefully.
```

---

### **3. Attack Animation (2초)**

**Gemini 프롬프트:**
```
Keep this character's face and mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character performing a sword slash attack:
- Start: Sword pulled back (windup)
- Middle: Fast forward slash with full extension
- End: Follow-through pose
- Cloak whips dramatically during swing
- Body rotates with the attack
- Slight forward lunge
- 2 seconds total (quick and sharp)
- Side view maintained
- Motion blur effect on sword during swing
- Character returns to ready stance at end

The attack should feel powerful, fast, and precise.
```

---

### **4. Jump Animation (3초)**

**Gemini 프롬프트:**
```
Keep this character's face and mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character jumping:
- Start: Crouch down (prepare)
- Middle: Launch upward, legs extend down, cloak flows down
- Peak: Body curled, cloak floating upward
- End: Descending, preparing to land
- 3 seconds total
- Smooth arc motion
- Cloak reacts to gravity and movement
- Side view maintained

The jump should feel light and graceful, defying gravity momentarily.
```

---

### **5. Dodge Roll (2초)**

**Gemini 프롬프트:**
```
Keep this character's face and mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character performing a forward dodge roll:
- Start: Lean forward
- Middle: Roll forward (compact form, cloak wraps)
- End: Exit roll into ready stance
- Fast, evasive movement
- 2 seconds duration
- Motion blur during roll
- Side view maintained

The dodge should feel urgent and skillful, like avoiding danger.
```

---

## 😈 **악신 모드 (Evil Mode)**

### **기본 설정:**
- 베이스 이미지: `evil_base.png` (Image #2)
- 스타일: 공격적, 위협적, 강력한 움직임
- 색상: 검은 망토, 흰 마스크 (미소), 은색 검

---

### **1. Idle Animation (3초 루프)**

**Gemini 프롬프트:**
```
Keep this character's face, SMILING mask, and head position EXACTLY as shown. Do not change the face, mask design, or head angle AT ALL.

IMPORTANT: The head must stay completely still. The smiling mouth expression must not change.

Animate this 2D game character with aggressive idle stance:
- Heavy breathing motion (stronger than normal) - BODY ONLY, not head
- Cloak flowing more aggressively
- Slight body swaying (menacing) - body only, head stays fixed
- Sword held with tension, ready to strike
- Head position COMPLETELY FIXED - no tilting, no movement
- Face expression FROZEN - smile stays the same
- Red energy particles floating around (optional)
- 3 seconds loop
- Side view maintained
- More intense and threatening than normal idle

The character should feel dangerous and unstable, with only the cloak and aggressive body movement.
```

---

### **2. Walk Animation (4초 루프)**

**Gemini 프롬프트:**
```
Keep this character's face and SMILING mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character walking with heavy, aggressive steps:
- Stomping walk (heavy footfalls implied)
- More pronounced up-down body movement
- Cloak whipping violently
- Sword swinging more dramatically
- Aggressive, threatening stride
- 4 seconds for full cycle
- Loop seamlessly
- Side view maintained

The walk should feel menacing and powerful, like a predator approaching.
```

---

### **3. Attack Animation (2초)**

**Gemini 프롬프트:**
```
Keep this character's face and SMILING mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character performing a devastating slash:
- Extreme backswing (huge windup)
- Explosive forward slash with full body rotation
- Maximum extension and power
- Cloak blasts outward
- Slight screen shake effect implied
- 2 seconds duration
- Heavy motion blur on sword
- Overextended follow-through

The attack should feel overwhelming, brutal, and destructive.
```

---

### **4. Jump Animation (3초)**

**Gemini 프롬프트:**
```
Keep this character's face and SMILING mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character performing a powerful jump:
- Explosive launch from ground (crack implied)
- Forceful upward thrust
- Cloak blasting downward
- Aggressive aerial pose with sword ready
- 3 seconds total
- More forceful than normal jump
- Side view maintained

The jump should feel violent and powerful, like breaking through the ground.
```

---

### **5. Dash (2초)**

**Gemini 프롬프트:**
```
Keep this character's face and SMILING mask EXACTLY as shown. Do not change the face or mask design.

Animate this 2D game character performing an aggressive forward dash:
- Explosive forward lean
- Body becomes horizontal blur
- Cloak streams behind violently
- Red energy trail (optional)
- 2 seconds duration
- Fast, aggressive momentum
- Slides to stop at end

The dash should feel unstoppable, like a charging bull.
```

---

## 🎬 **Gemini 사용 방법**

### **Step 1: Gemini 접속**
1. https://gemini.google.com 접속
2. 로그인 (Google 계정)

### **Step 2: 이미지 업로드**
1. 채팅창에서 "📎" (파일 첨부) 클릭
2. 베이스 이미지 업로드:
   - 인간 모드: `human_base.png`
   - 악신 모드: `evil_base.png`

### **Step 3: 프롬프트 입력**
위의 프롬프트를 복사해서 붙여넣기

### **Step 4: 동영상 생성 대기**
- 약 2-5분 소요
- 생성 완료되면 다운로드

### **Step 5: 파일명 규칙**
```
tools/videos/human/human_idle.mp4
tools/videos/human/human_walk.mp4
tools/videos/human/human_attack.mp4
tools/videos/human/human_jump.mp4
tools/videos/human/human_dodge.mp4

tools/videos/evil/evil_idle.mp4
tools/videos/evil/evil_walk.mp4
tools/videos/evil/evil_attack.mp4
tools/videos/evil/evil_jump.mp4
tools/videos/evil/evil_dash.mp4
```

---

## 📊 **생성 체크리스트**

### **Human Mode (5개 동영상)**
- [ ] Idle (3초)
- [ ] Walk (4초)
- [ ] Attack (2초)
- [ ] Jump (3초)
- [ ] Dodge (2초)

### **Evil Mode (5개 동영상)**
- [ ] Idle (3초)
- [ ] Walk (4초)
- [ ] Attack (2초)
- [ ] Jump (3초)
- [ ] Dash (2초)

---

## ⚙️ **다음 단계**

동영상 생성 후:
1. `extract_frames.py` 스크립트로 프레임 추출
2. 배경 제거 (필요시)
3. Godot SpriteFrames에 통합
4. 타이밍 조정 및 테스트

---

## 💡 **팁**

### **프롬프트 수정이 필요하면:**
- "Make it more/less aggressive"
- "Slower/faster movement"
- "More dramatic cloak motion"
- "Keep the character more centered"

### **결과가 마음에 안 들면:**
- "Try again" 클릭
- 프롬프트에 "MORE EMPHASIS ON: [원하는 것]" 추가
- 예: "MORE EMPHASIS ON: keeping the face exactly the same"

---

**이제 Gemini에서 첫 동영상을 만들어보세요! 🚀**

1. Gemini 접속
2. Image #1 업로드
3. "Idle Animation" 프롬프트 복사-붙여넣기
4. 생성!
