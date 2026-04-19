-- ============================================================================
-- 솔레일 하롱 호텔 (Hotel Soleil Halong) 데이터
-- 하롱베이 5성급 (Trademark Collection by Wyndham)
-- ============================================================================
-- 실행 순서: 020-hotel-schema-rebuild.sql 이후 실행
-- ※ 시즌 구분: 없음 (연중 단일 가격, 5월 기준 제공 - 변동 시 UPDATE 필요)
-- ※ 요일 구분: 없음 (weekday_type: ALL)
-- ============================================================================
-- 객실 구성 (13행):
--   디럭스 트윈 시티뷰 / 베이뷰  (31m²,  성인2)
--   디럭스 킹  시티뷰 / 베이뷰   (31m²,  성인2)
--   프리미어   시티뷰 / 베이뷰   (46m²,  성인2)
--   주니어 스위트 시티뷰 / 베이뷰 (46m²,  성인2)
--   패밀리 스위트 시티뷰          (60m²,  성인4)  ← 시티뷰만 제공
--   이그제큐티브 스위트 시티뷰 / 베이뷰 (68m², 성인2)
--   프레지덴셜 스위트 시티뷰 / 베이뷰  (98m², 성인2)
-- ============================================================================
-- 아동 요금: 만 6~12세 300,000동 / 엑스트라베드: 650,000동
-- 체크인: 14:00 / 체크아웃: 12:00
-- 위치: SUN WORLD 케이블카 선착장 바로 앞 (하롱베이 관광 중심지)
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. hotel_info INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location,
  star_rating, check_in_time, check_out_time,
  phone, currency, notes, active
) VALUES (
  'SOLEIL_HALONG',
  '솔레일 하롱 호텔',
  'HOTEL',
  '하롱베이 바이짜이, 썬월드 케이블카 선착장 앞',
  5,
  '14:00:00',
  '12:00:00',
  NULL,
  'VND',
  '5성급 (Trademark Collection by Wyndham). SUN WORLD 케이블카 선착장 바로 앞, 도보 시내 이동 편리. 한국인 친화적 서비스(조식 김밥·김치 제공). 4층 실내 수영장(06:00~21:00), 2층 레스토랑. ▶체크인 규정: 08시 이전 얼리체크인 1박 100%, 08~10시 50% 추가. 18시 이후 레이트체크아웃 1박 100%, 18시 이전 50% 추가. ▶취소 정책: 이용일 6일 전까지 무료 취소, 이후 환불 불가. ▶결제: 예약 시 50%, 체크인 1일 전 50%. ▶패밀리스위트 타입: ①거실+방2개형 ②방2개형(거실無) 구분 예약 필요.',
  TRUE
)
ON CONFLICT (hotel_code) DO UPDATE SET
  hotel_name      = EXCLUDED.hotel_name,
  location        = EXCLUDED.location,
  star_rating     = EXCLUDED.star_rating,
  check_in_time   = EXCLUDED.check_in_time,
  check_out_time  = EXCLUDED.check_out_time,
  notes           = EXCLUDED.notes,
  updated_at      = NOW();

-- ============================================================================
-- 2. hotel_price INSERT
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ─────────────── 디럭스 트윈 ───────────────
(
  'SOLEIL_HALONG_DELUXE_TWIN_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'DELUXE_TWIN_CITY', '디럭스 트윈 시티뷰',
  'STANDARD', 3, TRUE,
  1650000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '31m². 트윈베드. 단독 발코니. 시티뷰. 기준 성인2. 엑스트라베드 650,000동(성인2+아동1 시 추가). 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),
(
  'SOLEIL_HALONG_DELUXE_TWIN_BAY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'DELUXE_TWIN_BAY', '디럭스 트윈 베이뷰',
  'STANDARD', 3, TRUE,
  1700000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '31m². 트윈베드. 단독 발코니. 베이뷰(하롱베이 전망). 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),

-- ─────────────── 디럭스 킹 ───────────────
(
  'SOLEIL_HALONG_DELUXE_KING_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'DELUXE_KING_CITY', '디럭스 킹 시티뷰',
  'STANDARD', 3, TRUE,
  1650000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '31m². 킹베드. 단독 발코니. 시티뷰. 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),
(
  'SOLEIL_HALONG_DELUXE_KING_BAY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'DELUXE_KING_BAY', '디럭스 킹 베이뷰',
  'STANDARD', 3, TRUE,
  1700000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '31m². 킹베드. 단독 발코니. 베이뷰(하롱베이 전망). 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),

-- ─────────────── 프리미어 ───────────────
(
  'SOLEIL_HALONG_PREMIER_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'PREMIER_CITY', '프리미어 시티뷰',
  'STANDARD', 3, TRUE,
  2200000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '46m². 킹베드. 단독 발코니. 시티뷰. 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),
(
  'SOLEIL_HALONG_PREMIER_BAY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'PREMIER_BAY', '프리미어 베이뷰',
  'STANDARD', 3, TRUE,
  2200000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '46m². 킹베드. 단독 발코니. 베이뷰(하롱베이 전망). 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),

-- ─────────────── 주니어 스위트 ───────────────
(
  'SOLEIL_HALONG_JUNIOR_SUITE_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'JUNIOR_SUITE_CITY', '주니어 스위트 시티뷰',
  'SUITE', 3, TRUE,
  2500000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '46m². 킹베드. 단독 발코니. 시티뷰. 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),
(
  'SOLEIL_HALONG_JUNIOR_SUITE_BAY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'JUNIOR_SUITE_BAY', '주니어 스위트 베이뷰',
  'SUITE', 3, TRUE,
  2500000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '46m². 킹베드. 단독 발코니. 베이뷰(하롱베이 전망). 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),

-- ─────────────── 패밀리 스위트 (시티뷰만 제공) ───────────────
(
  'SOLEIL_HALONG_FAMILY_SUITE_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'FAMILY_SUITE_CITY', '패밀리 스위트 시티뷰',
  'FAMILY', 6, TRUE,
  3200000, 650000,
  '만 6~12세 아동 300,000동 (5번째 인원부터 추가요금) / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '60m². 킹베드1+트윈베드. 단독 발코니. 시티뷰만 제공(베이뷰 없음). 기준 성인4+아동2 (5번째 인원부터 추가비용). 2개 객실 제공. ⚠️ 타입 선택 필수: ①거실+방2개형 ②방2개형(거실無). 욕실 1개. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),

-- ─────────────── 이그제큐티브 스위트 ───────────────
(
  'SOLEIL_HALONG_EXECUTIVE_SUITE_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'EXECUTIVE_SUITE_CITY', '이그제큐티브 스위트 시티뷰',
  'SUITE', 3, TRUE,
  4500000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '68m². 킹베드. 단독 발코니. 시티뷰. 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),
(
  'SOLEIL_HALONG_EXECUTIVE_SUITE_BAY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'EXECUTIVE_SUITE_BAY', '이그제큐티브 스위트 베이뷰',
  'SUITE', 3, TRUE,
  4500000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '68m². 킹베드. 단독 발코니. 베이뷰(하롱베이 전망). 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),

-- ─────────────── 프레지덴셜 스위트 ───────────────
(
  'SOLEIL_HALONG_PRESIDENTIAL_SUITE_CITY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'PRESIDENTIAL_SUITE_CITY', '프레지덴셜 스위트 시티뷰',
  'SUITE', 3, TRUE,
  6300000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '98m². 킹베드. 단독 발코니. 시티뷰. 2개 객실 제공. 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
),
(
  'SOLEIL_HALONG_PRESIDENTIAL_SUITE_BAY',
  'SOLEIL_HALONG', '솔레일 하롱 호텔',
  'PRESIDENTIAL_SUITE_BAY', '프레지덴셜 스위트 베이뷰',
  'SUITE', 3, TRUE,
  6300000, 650000,
  '만 6~12세 아동 300,000동 / 만 6세 미만 무료',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '98m². 킹베드. 단독 발코니. 베이뷰(하롱베이 전망). 2개 객실 제공. 기준 성인2. 엑스트라베드 650,000동. 조식 포함. ⚠️ 5월 기준 요금, 시즌별 변동 가능.'
)

ON CONFLICT (hotel_price_code) DO UPDATE SET
  base_price         = EXCLUDED.base_price,
  extra_person_price = EXCLUDED.extra_person_price,
  child_policy       = EXCLUDED.child_policy,
  notes              = EXCLUDED.notes,
  updated_at         = NOW();

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'SOLEIL_HALONG';
--
-- SELECT hotel_price_code, room_name, base_price, extra_person_price
-- FROM hotel_price
-- WHERE hotel_code = 'SOLEIL_HALONG'
-- ORDER BY base_price, room_name;
-- 기대값: 13행
--
-- SELECT COUNT(*) FROM hotel_price WHERE hotel_code = 'SOLEIL_HALONG';

-- ============================================================================
-- ⚠️ 시즌별 가격 업데이트 템플릿 (실제 요금 확정 후 사용)
-- ============================================================================
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_DELUXE_TWIN_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_DELUXE_TWIN_BAY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_DELUXE_KING_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_DELUXE_KING_BAY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_PREMIER_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_PREMIER_BAY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_JUNIOR_SUITE_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_JUNIOR_SUITE_BAY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_FAMILY_SUITE_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_EXECUTIVE_SUITE_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_EXECUTIVE_SUITE_BAY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_PRESIDENTIAL_SUITE_CITY';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'SOLEIL_HALONG_PRESIDENTIAL_SUITE_BAY';
