# 무료 타일셋 다운로드 & 설정 가이드

## Step 1: 다운로드 (5분)

### 추천 타일셋: **0x72 DungeonTileset II**

**다운로드 링크:**
https://0x72.itch.io/dungeontileset-ii

### 다운로드 방법:
1. 위 링크 접속
2. "Download Now" 클릭
3. $0 입력 (무료) → "Download" 클릭
4. ZIP 파일 다운로드

### 압축 풀기:
```bash
# Downloads 폴더에서
cd ~/Downloads
unzip dungeontileset-ii.zip
```

---

## Step 2: 파일 확인 (1분)

압축을 풀면:
```
dungeontileset-ii/
├── frames/              # 16x16 개별 타일들
│   ├── floor_1.png
│   ├── wall_1.png
│   └── ...
├── tilesheet.png        # 전체 타일셋 (추천)
└── README.txt
```

**우리가 사용할 파일:** `tilesheet.png`

---

## Step 3: 프로젝트에 복사 (1분)

```bash
# 다운로드한 파일을 프로젝트로 복사
cp ~/Downloads/dungeontileset-ii/tilesheet.png \
   /Users/leehanjun/Desktop/money/hollow-venture/assets/tilesets/dungeon_tileset.png
```

또는 Finder에서:
1. `tilesheet.png` 찾기
2. Hollow Venture 프로젝트의 `assets/tilesets/` 폴더로 드래그
3. 이름 변경: `dungeon_tileset.png`

---

## Step 4: Godot에서 TileSet 생성 (5분)

### 자동 생성 (제가 준비):

실행:
```bash
cd /Users/leehanjun/Desktop/money/hollow-venture
```

제가 스크립트로 TileSet 리소스 생성해드림

### 또는 수동:

1. Godot 에디터 열기
2. `assets/tilesets/` 우클릭 → "Create New" → "Resource"
3. "TileSet" 선택 → `dungeon_tileset.tres`
4. 더블클릭해서 열기
5. "Add TileSetAtlasSource" (+) 클릭
6. Texture: `dungeon_tileset.png` 선택
7. Texture Region Size: `16 x 16`
8. 자동으로 타일 그리드 생성됨!

---

## Step 5: 타일 ID 확인 (5분)

0x72 타일셋은 이미 정리되어 있음:

**타일 ID (대략):**
- 0-10: 바닥 타일
- 11-20: 벽 타일
- 21-30: 장식
- 31-40: 플랫폼

**정확한 ID 확인:**
1. TileSet 에디터에서 타일 클릭
2. 좌표 확인 (0,0부터 시작)
3. 필요한 타일 ID 메모

---

## Step 6: 맵 생성 코드 업데이트 (제가 진행)

타일 ID 알려주시면:
- room_factory.gd 업데이트
- 새 타일 ID로 맵 생성

---

## Step 7: 테스트 (1분)

F5로 실행:
- 맵이 제대로 보이는지 확인
- 충돌 작동하는지 확인

---

## 타일 ID 샘플 (0x72 DungeonTileset II 기준):

```
바닥: 타일 ID ???
벽: 타일 ID ???
플랫폼: 타일 ID ???
장식: 타일 ID ???
```

다운로드 후 확인해서 알려주세요!

---

## 예상 시간:

- 다운로드: 2분
- 복사: 1분
- Godot 설정: 5분
- 타일 ID 확인: 3분
- 코드 업데이트: 5분 (제가 진행)
- 테스트: 2분

**총: 20분**

---

**지금 다운로드 시작하세요!**

https://0x72.itch.io/dungeontileset-ii
