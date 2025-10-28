# Hollow Venture - 타일셋 제작 스펙
## 할로우 나이트급 타일셋 요구사항

---

## 1. 기본 스펙

### 타일 크기:
- **16x16 픽셀** (추천)
- 또는 32x32 (더 디테일하지만 작업량 많음)

### 색상 팔레트:
- **다크 블루-그린 톤** (할로우 나이트 동굴 느낌)
- 메인: #1a2e3d, #2a4d5a, #3a6d7a
- 액센트: #5acfd6 (크리스탈), #8b6d3f (흙)

### 총 필요 타일 수:
- **최소 50개** (기본)
- **권장 80-100개** (퀄리티)

---

## 2. 필수 타일 카테고리

### A. 바닥 타일 (Ground) - 15개

**기본 바닥:**
1. 바닥_중앙 (반복 타일)
2. 바닥_variation_1 (균열)
3. 바닥_variation_2 (작은 돌)
4. 바닥_variation_3 (이끼)

**바닥 경계 (Autotiling용):**
5. 바닥_위쪽_경계
6. 바닥_아래쪽_경계
7. 바닥_왼쪽_경계
8. 바닥_오른쪽_경계
9. 바닥_왼쪽위_모서리_외곽
10. 바닥_오른쪽위_모서리_외곽
11. 바닥_왼쪽아래_모서리_외곽
12. 바닥_오른쪽아래_모서리_외곽
13. 바닥_왼쪽위_모서리_내곽
14. 바닥_오른쪽위_모서리_내곽
15. 바닥_단독 (모든 방향 경계)

---

### B. 벽 타일 (Wall) - 15개

**기본 벽:**
1. 벽_중앙 (반복 타일)
2. 벽_variation_1 (균열)
3. 벽_variation_2 (돌출부)
4. 벽_variation_3 (이끼 핀)

**벽 경계 (Autotiling용):**
5-15. (바닥과 동일한 경계 구조)

---

### C. 플랫폼 (Platform) - 8개

1. 플랫폼_왼쪽_끝
2. 플랫폼_중앙
3. 플랫폼_오른쪽_끝
4. 플랫폼_단독 (1타일 크기)
5. 플랫폼_받침_왼쪽
6. 플랫폼_받침_중앙
7. 플랫폼_받침_오른쪽
8. 플랫폼_variation (나무/돌)

---

### D. 장식 타일 (Decorations) - 20개

**천장 장식:**
1-3. 고드름 (작음/중간/큼)
4-5. 뿌리 (내려옴)
6. 균열 (천장)

**벽 장식:**
7-9. 이끼 (작음/중간/큼)
10-12. 덩굴
13-14. 벽 균열
15-16. 작은 돌출부

**바닥 장식:**
17-18. 작은 돌
19. 물웅덩이
20. 풀

---

### E. 특수 타일 (Special) - 10개

1-3. 크리스탈 (작음/중간/큼)
4-5. 발광 버섯
6. 문 (닫힘)
7. 문 (열림)
8. 체인/사슬
9. 깨진 기둥
10. 뼈다귀

---

### F. 배경 타일 (Background) - 12개

**원경 벽:**
1-4. 흐릿한 벽 (depth 느낌)
5-8. 먼 동굴 구조물
9-12. 배경 장식 (기둥, 아치 등)

---

## 3. Autotiling 비트마스크 구조

```
Godot 4.x 기준 3x3 비트마스크:

 1 | 2 | 4
-----------
 8 | X |16
-----------
32 |64 |128

총 47개 조합 필요 (Godot terrain autotiling)
```

**필요한 타일 조합:**
- 중앙 (모든 방향 이웃)
- 4방향 단일 경계
- 4개 모서리 (외곽)
- 4개 모서리 (내곽)
- 특수 케이스들

---

## 4. 스타일 가이드

### 픽셀 아트 규칙:
1. **앤티앨리어싱**: 최소화 (선명한 픽셀)
2. **아웃라인**: 1-2px 어두운 테두리
3. **셰이딩**: 3-4단계 명암
4. **디더링**: 그라데이션에 사용

### 할로우 나이트 특징:
- **유기적인 형태** (직선 최소화)
- **불규칙한 경계**
- **깊이감** (밝기 차이로 표현)
- **디테일** (균열, 이끼, 돌출부)

---

## 5. 참고 자료

### 할로우 나이트 타일셋 분석:
- Forgotten Crossroads: 밝은 청록색, 단순한 구조
- Deepnest: 어두운 갈색, 유기적 형태
- Crystal Peak: 크리스탈 강조, 밝은 색

### 추천 도구:
- **Aseprite** (픽셀 아트 제작)
- **Piskel** (무료 웹 도구)
- **Photoshop/GIMP** (편집)

---

## 6. 제작 방법 옵션

### 옵션 A: 직접 제작
- Aseprite로 16x16 타일 직접 그리기
- 시간: 약 10-20시간
- 퀄리티: 최상 (완전 커스텀)

### 옵션 B: AI 생성 + 수정
- AI 프롬프트로 베이스 생성
- Photoshop으로 16x16 자르기 + 수정
- 시간: 약 5-10시간
- 퀄리티: 중상

### 옵션 C: 에셋 구매
- itch.io, OpenGameArt 검색
- 키워드: "cave tileset", "metroidvania tileset"
- 비용: $5-20
- 시간: 1시간
- 퀄리티: 에셋 품질에 따름

---

## 7. AI 생성 프롬프트 (옵션 B 선택 시)

### Gemini 프롬프트:

```
Create a pixel art tileset for a 2D metroidvania game in Hollow Knight style.

Specs:
- 16x16 pixels per tile
- Dark blue-green cave theme (#1a2e3d base color)
- Organic, irregular shapes
- Include: ground tiles, wall tiles, platforms, stalactites, crystals
- 3-4 shading levels
- Pixel perfect, no anti-aliasing
- Arranged in a sprite sheet

Style: Dark atmospheric caves, similar to Hollow Knight's Forgotten Crossroads
Layout: Multiple variations of each tile type
```

---

## 8. 타일셋 파일 구조

```
assets/tilesets/
├── main_tileset.png          # 메인 타일셋 (16x16 grid)
├── decorations.png           # 장식 타일
├── backgrounds.png           # 배경 레이어
├── main_tileset.tres         # Godot TileSet 리소스
└── autotile_config.json      # Autotiling 설정
```

---

## 9. 다음 단계

1. **당신이 할 일:**
   - 위 3가지 옵션 중 선택
   - 타일셋 이미지 파일 확보
   - `/assets/tilesets/` 폴더에 저장

2. **제가 할 일:**
   - Godot TileSet 설정 (autotiling)
   - 코드 개선 (새 타일 활용)
   - 맵 생성 알고리즘 업그레이드

---

## 10. 최소 MVP (빠른 시작)

**급하면 이것만:**
- 바닥 타일 5개 (중앙 + 4개 경계)
- 벽 타일 5개
- 플랫폼 3개
- 장식 5개

**총 18개 타일로 시작 가능**

---

준비되면 타일셋 파일 보내주세요!
