# 크루즈 상세 정보 데이터 입력 지침

## 두 테이블의 역할 구분

| 테이블 | 쓰임새 | 단위 |
|--------|--------|------|
| `cruise_info` | 크루즈/객실 상세 정보 (일정, 시설, 취소정책, 포함사항 등) | 객실 타입 1행 |
| `cruise_rate_card_inclusions` | 특정 요금 카드(객실 타입+시즌)에만 적용되는 포함사항 | rate_card_id 1행 |

---

## 1. `cruise_info` 테이블

### 언제 사용하나?
크루즈를 처음 등록할 때, 또는 기존 크루즈의 정보를 수정할 때 사용합니다.  
**객실 타입당 1행**을 INSERT합니다.  
크루즈 공통 정보(일정표, 취소정책, 시설 등)는 **모든 객실 행에 동일하게 반복 입력**합니다.

### UI에서 표시되는 위치
- 크루즈 직접예약 페이지 → 크루즈 선택 후 나타나는 **"크루즈 상세 정보 패널"**
- 객실 카드 → 면적, 침대, 발코니, 특별 어메니티 등 **객실 고유 정보**

### 주요 컬럼 설명

#### 식별 컬럼 (필수)
```sql
cruise_code   -- 고유 코드 (예: 'GP-OS', 'CATH-PS'). 크루즈약자-객실약자 패턴 권장
cruise_name   -- 크루즈 한글명 (cruise_rate_card의 cruise_name과 반드시 동일해야 함)
room_name     -- 객실 타입명 (cruise_rate_card의 room_type 또는 room_type_en과 매칭)
display_order -- 객실 표시 순서 (낮은 번호가 위에 표시됨)
```

#### 객실 고유 정보 (객실마다 다르게 입력)
```sql
room_area        -- 객실 면적 (예: '30㎡', '43㎡')
room_description -- 객실 상세 설명 (수용 인원, 베드 구성, 주의사항 등 자세히)
bed_type         -- 침대 타입 (예: '더블 또는 트윈', '킹사이즈', '더블 + 싱글')
max_adults       -- 최대 성인 수 (기본 2)
max_guests       -- 최대 총 수용 인원 (기본 3)
has_balcony      -- 발코니 여부 (true/false)
is_vip           -- VIP 등급 여부 (true/false)
has_butler       -- 버틀러 서비스 여부 (true/false)
is_recommended   -- 추천 객실 여부 (true → 객실 카드에 '★ 추천' 배지)
connecting_available  -- 커넥팅룸 가능 여부
extra_bed_available   -- 엑스트라베드 가능 여부 (기본 true)
special_amenities     -- 특별 어메니티 (객실 카드에 ✨ 아이콘으로 표시)
warnings              -- 주의사항 (객실 카드에 ⚠️ 아이콘으로 표시)
```

#### 크루즈 공통 정보 (모든 객실 행에 동일하게 반복)
```sql
name           -- 크루즈 영문명
description    -- 크루즈 소개 문구
duration       -- 일정 (예: '1박2일', '2박3일', '당일')
category       -- 등급 분류 (예: '프리미엄', '럭셔리')
star_rating    -- 등급 표기 (예: '6성급', '5성급')
capacity       -- 수용 인원 (예: '160명')
awards         -- 수상 이력 (예: 'Asia\'s Best Cruise')
facilities     -- 편의시설 목록 (jsonb 배열, 예: '["수영장", "엘리베이터"]')
inclusions     -- 크루즈 포함사항 (일반 텍스트, 줄바꿈 구분)
exclusions     -- 크루즈 불포함사항 (일반 텍스트, 줄바꿈 구분)
```

#### 일정표 (`itinerary` - jsonb)
```sql
-- 형식: 일차별 배열
'[
  {"day": 1, "title": "1일차", "schedule": [
    {"time": "08:00", "activity": "호텔 픽업"},
    {"time": "12:00", "activity": "점심식사"}
  ]},
  {"day": 2, "title": "2일차", "schedule": [
    {"time": "06:00", "activity": "일출 감상"}
  ]}
]'::jsonb
```

#### 취소 정책 (`cancellation_policy` - jsonb)
```sql
-- 형식: 조건별 배열
'[
  {"condition": "승선코드 발급 전", "penalty": "무료 취소"},
  {"condition": "출발 31일 전", "penalty": "1,000,000 VND"},
  {"condition": "출발 21~30일 전", "penalty": "요금의 15%"},
  {"condition": "출발 17~20일 전", "penalty": "요금의 50%"},
  {"condition": "출발 16일 이내 또는 노쇼", "penalty": "취소/환불 불가"},
  {"condition": "천재지변/정부명령/크루즈 결항", "penalty": "전액 환불"}
]'::jsonb
```

### cruise_rate_card와 매칭 규칙
`cruise_info.room_name` ↔ `cruise_rate_card.room_type` 또는 `cruise_rate_card.room_type_en`  
4단계 매칭 로직 적용 (정확매칭 → 영문 정확매칭 → 영문 부분매칭 → 한글 부분매칭)

✅ 안전한 방법: `cruise_info.room_name`을 `cruise_rate_card.room_type_en`과 **동일하게** 입력

---

## 2. `cruise_rate_card_inclusions` 테이블

### 언제 사용하나?
특정 객실 타입 또는 특정 시즌 요금에만 **추가로 포함되는 사항**이 있을 때 사용합니다.  
예시:
- 프로모션 시즌에만 "웰컴 과일 바구니 제공"
- VIP 스위트에만 "버틀러 서비스 1회 포함"
- 특정 객실에만 "랍스터 디너 포함"

`cruise_info.inclusions`는 크루즈 전체 공통 포함사항이고,  
`cruise_rate_card_inclusions`는 **특정 rate_card(객실+시즌)에만 적용되는 포함사항**입니다.

### UI에서 표시되는 위치
크루즈 직접예약 페이지 → **객실 선택 카드 하단** → "포함사항" 섹션 (✓ 체크마크 목록)

### 테이블 구조
```sql
CREATE TABLE cruise_rate_card_inclusions (
  id              uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  rate_card_id    uuid NOT NULL REFERENCES cruise_rate_card(id) ON DELETE CASCADE,
  inclusion_text  text NOT NULL,   -- 포함사항 텍스트 (1줄 1항목)
  display_order   integer DEFAULT 0, -- 표시 순서 (낮을수록 위에 표시)
  created_at      timestamptz DEFAULT now()
);
```

### 데이터 입력 방법

#### 방법 1: rate_card_id를 직접 알 때
```sql
INSERT INTO cruise_rate_card_inclusions (rate_card_id, inclusion_text, display_order)
VALUES
  ('uuid-here', '승솟동굴 투어 포함', 1),
  ('uuid-here', '카약 체험 포함', 2),
  ('uuid-here', '랍스터 디너 포함', 3);
```

#### 방법 2: 크루즈명/객실명으로 조회하여 INSERT (권장)
```sql
-- 특정 크루즈의 특정 객실 모든 시즌 요금에 포함사항 추가
INSERT INTO cruise_rate_card_inclusions (rate_card_id, inclusion_text, display_order)
SELECT rc.id, v.inclusion_text, v.display_order
FROM cruise_rate_card rc
CROSS JOIN (VALUES
  ('승솟동굴 투어 포함', 1),
  ('카약 & 뱀부보트 체험 포함', 2),
  ('뷔페/코스 식사 포함', 3),
  ('오징어 낚시 포함', 4)
) AS v(inclusion_text, display_order)
WHERE rc.cruise_name = '그랜드 파이어니스 크루즈'
  AND rc.room_type = 'Ocean Suite'
  AND rc.is_active = true;
```

#### 방법 3: 크루즈 전체 객실에 동일한 포함사항 추가
```sql
-- 크루즈 전체의 모든 활성 요금에 포함사항 추가
INSERT INTO cruise_rate_card_inclusions (rate_card_id, inclusion_text, display_order)
SELECT rc.id, v.inclusion_text, v.display_order
FROM cruise_rate_card rc
CROSS JOIN (VALUES
  ('동굴 투어 포함', 1),
  ('전일 식사 포함', 2)
) AS v(inclusion_text, display_order)
WHERE rc.cruise_name = '캐서린 크루즈'
  AND rc.is_active = true;
```

### 포함사항 수정/삭제
```sql
-- 특정 크루즈의 포함사항 전체 교체
DELETE FROM cruise_rate_card_inclusions
WHERE rate_card_id IN (
  SELECT id FROM cruise_rate_card WHERE cruise_name = '그랜드 파이어니스 크루즈'
);

-- 이후 다시 INSERT
```

---

## 3. 새 크루즈 추가 전체 절차

### 파일 생성 규칙
```
sql/
  0XX-[크루즈명]-data.sql        -- cruise_info 데이터
  0XX-[크루즈명]-rate-card.sql   -- cruise_rate_card 요금 + inclusions
```

### 단계별 실행 순서
```
1. 011-cruise-info-columns.sql   (최초 1회만, 이미 실행했으면 건너뜀)
2. 0XX-[크루즈명]-data.sql       (cruise_info 입력)
3. 0XX-[크루즈명]-rate-card.sql  (cruise_rate_card 요금 입력)
4. inclusions INSERT             (rate-card.sql 내에 포함하거나 별도 파일)
```

### 최소 필수 입력 체크리스트
- [ ] `cruise_name`이 `cruise_rate_card`와 **정확히 동일** (오타 주의)
- [ ] `room_name`이 `room_type_en`과 매칭되도록 입력
- [ ] `display_order` 설정 (오름차순 = 저가 → 고가 순)
- [ ] `itinerary` jsonb 유효성 확인
- [ ] `cancellation_policy` jsonb 유효성 확인
- [ ] `is_active = true` 확인 (요금 카드)
- [ ] `valid_from`, `valid_to` 날짜 범위 확인

---

## 4. 두 테이블의 `inclusions` 비교 요약

```
┌─────────────────────────────────────┬──────────────────────────────────────────┐
│ cruise_info.inclusions              │ cruise_rate_card_inclusions              │
├─────────────────────────────────────┼──────────────────────────────────────────┤
│ 크루즈 전체 공통 포함사항           │ 특정 객실/시즌 요금에만 적용되는 포함사항 │
│ 일반 텍스트 (줄바꿈 구분)           │ 항목별 1행 (display_order 정렬)          │
│ UI: 크루즈 상세정보 패널에 표시     │ UI: 객실 선택 카드 하단에 ✓ 목록 표시   │
│ 예: "동굴투어 포함, 식사 포함"      │ 예: "랍스터 디너 포함" (VIP 객실 한정)  │
└─────────────────────────────────────┴──────────────────────────────────────────┘
```

> **언제 `cruise_rate_card_inclusions`를 쓰나?**  
> 같은 크루즈라도 **객실 타입별로 포함 혜택이 다를 때** 사용합니다.  
> 모든 객실에 동일하게 적용된다면 `cruise_info.inclusions`에 텍스트로 기재하는 것으로 충분합니다.
