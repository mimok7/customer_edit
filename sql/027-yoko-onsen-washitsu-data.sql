-- ============================================================================
-- 요코온센 리조트 (Yoko Onsen) - 와시츠 객실 추가 데이터
-- 하롱베이 온천 휴양 리조트 (YOKO WASHITSU 객실)
-- ============================================================================
-- 실행 순서: 025-yoko-onsen-resort-data.sql 이후 실행
-- ※ 프로그램: 대실 (당일 6시간) + 1박 2일 숙박
-- ※ 하이시즌: 2026/05/17 ~ 2026/08/29
-- ※ 홀리데이 적용일: 2026/08/30~09/03, 2026/12/31~2027/01/01
-- ※ 조식: 대실 별도 (뷔페티켓 650,000동/인), 1박 포함
-- ============================================================================
-- 객실 구성:
--   와시츠 이치      (40m², 성인2+만4세아동1, 최대성인3명) - 디럭스룸 수준
--   와시츠 니        (40m², 성인2+만4세아동1)              - 디럭스 프리미엄룸 수준
--   와시츠 오모테아시 (75m², 성인2+만12세아동2 또는 성인4)  - 이그제큐티브룸 수준
--   와시츠 카조쿠    (63m², 성인2+만12세아동2 또는 성인4)  - 패밀리룸 수준
-- ============================================================================

BEGIN;

-- hotel_info는 025 파일에 이미 삽입됨 (hotel_code: YOKO_ONSEN)
-- 와시츠 정보 반영하여 notes 갱신
UPDATE hotel_info SET
  notes = '온천 휴양 리조트. 3구역 운영: 공용온천(모닝/에프터눈/나이트 3타임), 와시츠 객실(단독 온천탕+사우나), 야마 빌라(독채형). 뷔페티켓 650,000동/인 별도. 솔레일 호텔 앞 썬월드 입구 무료셔틀버스 운행. 예약 후 취소 불가.',
  updated_at = NOW()
WHERE hotel_code = 'YOKO_ONSEN';

-- ============================================================================
-- 1. 와시츠 객실 대실 프로그램 (당일 6시간 이내) - 하이시즌
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ─────────────── 와시츠 이치 대실 ───────────────
(
  'YOKO_ONSEN_WASHITSU_ICHI_DAYPASS_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_ICHI_DAYPASS', '와시츠 이치 (대실)',
  'STANDARD', 3, FALSE,
  3100000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 평일 대실', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '당일 6시간 이내 이용권. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 최대 성인3명. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_ICHI_DAYPASS_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_ICHI_DAYPASS', '와시츠 이치 (대실)',
  'STANDARD', 3, FALSE,
  4300000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 주말 대실', '2026-05-17', '2026-08-29', 'WEEKEND',
  '당일 6시간 이내 이용권. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 최대 성인3명. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_ICHI_DAYPASS_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_ICHI_DAYPASS', '와시츠 이치 (대실)',
  'STANDARD', 3, FALSE,
  4900000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '홀리데이 대실', '2026-08-30', '2026-09-03', 'ALL',
  '당일 6시간 이내 이용권. 40m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 뷔페티켓 650,000동/인 별도.'
),

-- ─────────────── 와시츠 니 대실 ───────────────
(
  'YOKO_ONSEN_WASHITSU_NI_DAYPASS_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_NI_DAYPASS', '와시츠 니 (대실)',
  'STANDARD', 3, FALSE,
  3700000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 평일 대실', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '당일 6시간 이내 이용권. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 디럭스 프리미엄룸 수준. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_NI_DAYPASS_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_NI_DAYPASS', '와시츠 니 (대실)',
  'STANDARD', 3, FALSE,
  5200000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 주말 대실', '2026-05-17', '2026-08-29', 'WEEKEND',
  '당일 6시간 이내 이용권. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 디럭스 프리미엄룸 수준. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_NI_DAYPASS_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_NI_DAYPASS', '와시츠 니 (대실)',
  'STANDARD', 3, FALSE,
  5900000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '홀리데이 대실', '2026-08-30', '2026-09-03', 'ALL',
  '당일 6시간 이내 이용권. 40m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 뷔페티켓 650,000동/인 별도.'
),

-- ─────────────── 와시츠 오모테아시 대실 ───────────────
(
  'YOKO_ONSEN_WASHITSU_OMOTEASHI_DAYPASS_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_OMOTEASHI_DAYPASS', '와시츠 오모테아시 (대실)',
  'SUITE', 4, FALSE,
  4300000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 평일 대실', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '당일 6시간 이내 이용권. 75m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만12세 아동2 또는 성인4. 이그제큐티브룸 수준. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_OMOTEASHI_DAYPASS_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_OMOTEASHI_DAYPASS', '와시츠 오모테아시 (대실)',
  'SUITE', 4, FALSE,
  6000000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 주말 대실', '2026-05-17', '2026-08-29', 'WEEKEND',
  '당일 6시간 이내 이용권. 75m². 기준 성인2+만12세 아동2 또는 성인4. 이그제큐티브룸 수준. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_OMOTEASHI_DAYPASS_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_OMOTEASHI_DAYPASS', '와시츠 오모테아시 (대실)',
  'SUITE', 4, FALSE,
  6850000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '홀리데이 대실', '2026-08-30', '2026-09-03', 'ALL',
  '당일 6시간 이내 이용권. 75m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 뷔페티켓 650,000동/인 별도.'
),

-- ─────────────── 와시츠 카조쿠 대실 ───────────────
(
  'YOKO_ONSEN_WASHITSU_KAZOKU_DAYPASS_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_KAZOKU_DAYPASS', '와시츠 카조쿠 (대실)',
  'FAMILY', 4, FALSE,
  5250000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 평일 대실', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '당일 6시간 이내 이용권. 63m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만12세 아동2 또는 성인4. 패밀리룸 수준. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_KAZOKU_DAYPASS_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_KAZOKU_DAYPASS', '와시츠 카조쿠 (대실)',
  'FAMILY', 4, FALSE,
  7300000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 주말 대실', '2026-05-17', '2026-08-29', 'WEEKEND',
  '당일 6시간 이내 이용권. 63m². 기준 성인2+만12세 아동2 또는 성인4. 패밀리룸 수준. 뷔페티켓 650,000동/인 별도.'
),
(
  'YOKO_ONSEN_WASHITSU_KAZOKU_DAYPASS_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_KAZOKU_DAYPASS', '와시츠 카조쿠 (대실)',
  'FAMILY', 4, FALSE,
  8300000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '홀리데이 대실', '2026-08-30', '2026-09-03', 'ALL',
  '당일 6시간 이내 이용권. 63m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 뷔페티켓 650,000동/인 별도.'
)

ON CONFLICT (hotel_price_code) DO UPDATE SET
  base_price         = EXCLUDED.base_price,
  extra_person_price = EXCLUDED.extra_person_price,
  child_policy       = EXCLUDED.child_policy,
  notes              = EXCLUDED.notes,
  updated_at         = NOW();

-- ============================================================================
-- 2. 와시츠 객실 1박 숙박 프로그램 - 하이시즌
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ─────────────── 와시츠 이치 1박 ───────────────
(
  'YOKO_ONSEN_WASHITSU_ICHI_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_ICHI', '와시츠 이치',
  'STANDARD', 3, TRUE,
  3350000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 평일', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '1박 2일 숙박. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 최대 성인3명. 조식 포함 (뷔페). 디럭스룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_ICHI_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_ICHI', '와시츠 이치',
  'STANDARD', 3, TRUE,
  6050000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 주말', '2026-05-17', '2026-08-29', 'WEEKEND',
  '1박 2일 숙박. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 최대 성인3명. 조식 포함. 디럭스룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_ICHI_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_ICHI', '와시츠 이치',
  'STANDARD', 3, TRUE,
  6850000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '홀리데이', '2026-08-30', '2026-09-03', 'ALL',
  '1박 2일 숙박. 40m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 조식 포함. 예약 후 취소 불가.'
),

-- ─────────────── 와시츠 니 1박 ───────────────
(
  'YOKO_ONSEN_WASHITSU_NI_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_NI', '와시츠 니',
  'STANDARD', 3, TRUE,
  5200000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 평일', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '1박 2일 숙박. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 조식 포함. 디럭스 프리미엄룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_NI_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_NI', '와시츠 니',
  'STANDARD', 3, TRUE,
  7200000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '하이시즌 주말', '2026-05-17', '2026-08-29', 'WEEKEND',
  '1박 2일 숙박. 40m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만4세 아동1. 조식 포함. 디럭스 프리미엄룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_NI_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_NI', '와시츠 니',
  'STANDARD', 3, TRUE,
  8200000, 0,
  '만 4세 미만 무료 / 만 4세 이상 성인 요금 적용',
  '홀리데이', '2026-08-30', '2026-09-03', 'ALL',
  '1박 2일 숙박. 40m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 조식 포함. 예약 후 취소 불가.'
),

-- ─────────────── 와시츠 오모테아시 1박 ───────────────
(
  'YOKO_ONSEN_WASHITSU_OMOTEASHI_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_OMOTEASHI', '와시츠 오모테아시',
  'SUITE', 4, TRUE,
  6050000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 평일', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '1박 2일 숙박. 75m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만12세 아동2 또는 성인4. 조식 포함. 이그제큐티브룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_OMOTEASHI_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_OMOTEASHI', '와시츠 오모테아시',
  'SUITE', 4, TRUE,
  8400000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 주말', '2026-05-17', '2026-08-29', 'WEEKEND',
  '1박 2일 숙박. 75m². 기준 성인2+만12세 아동2 또는 성인4. 조식 포함. 이그제큐티브룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_OMOTEASHI_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_OMOTEASHI', '와시츠 오모테아시',
  'SUITE', 4, TRUE,
  9600000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '홀리데이', '2026-08-30', '2026-09-03', 'ALL',
  '1박 2일 숙박. 75m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 조식 포함. 예약 후 취소 불가.'
),

-- ─────────────── 와시츠 카조쿠 1박 ───────────────
(
  'YOKO_ONSEN_WASHITSU_KAZOKU_HIGH_WD',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_KAZOKU', '와시츠 카조쿠',
  'FAMILY', 4, TRUE,
  7300000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 평일', '2026-05-17', '2026-08-29', 'WEEKDAY',
  '1박 2일 숙박. 63m². 단독 마당 프라이빗 온천탕, 사우나, 욕조, 좌식 테이블. 기준 성인2+만12세 아동2 또는 성인4. 조식 포함. 패밀리룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_KAZOKU_HIGH_WE',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_KAZOKU', '와시츠 카조쿠',
  'FAMILY', 4, TRUE,
  10200000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '하이시즌 주말', '2026-05-17', '2026-08-29', 'WEEKEND',
  '1박 2일 숙박. 63m². 기준 성인2+만12세 아동2 또는 성인4. 조식 포함. 패밀리룸 수준. 예약 후 취소 불가.'
),
(
  'YOKO_ONSEN_WASHITSU_KAZOKU_HOLIDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'WASHITSU_KAZOKU', '와시츠 카조쿠',
  'FAMILY', 4, TRUE,
  11650000, 0,
  '만 12세 미만 무료 / 만 12세 이상 성인 요금 적용',
  '홀리데이', '2026-08-30', '2026-09-03', 'ALL',
  '1박 2일 숙박. 63m². 홀리데이 적용일: 08/30~09/03, 12/31~01/01. 조식 포함. 예약 후 취소 불가.'
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
-- SELECT hotel_price_code, room_name, season_name, weekday_type, base_price
-- FROM hotel_price
-- WHERE hotel_code = 'YOKO_ONSEN' AND room_type LIKE 'WASHITSU%'
-- ORDER BY room_type, season_name, weekday_type;
--
-- SELECT
--   COUNT(*) AS total,
--   SUM(CASE WHEN room_type LIKE '%_DAYPASS' THEN 1 ELSE 0 END) AS 대실,
--   SUM(CASE WHEN room_type NOT LIKE '%_DAYPASS' THEN 1 ELSE 0 END) AS 숙박
-- FROM hotel_price
-- WHERE hotel_code = 'YOKO_ONSEN' AND room_type LIKE 'WASHITSU%';
-- 기대값: total=24, 대실=12, 숙박=12
