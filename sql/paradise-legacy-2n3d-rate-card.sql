-- ============================================
-- 파라다이스 레거시 크루즈 2026년 2박3일 가격 추가
-- 1박2일 가격의 2배로 설정
-- ============================================

-- ============================================
-- 기간 1: 2026/01/01 - 04/30 (정가)
-- 1박2일 가격의 2배
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 디럭스 발코니 (4,550,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '디럭스 발코니', 'Deluxe Balcony',
   9100000, 7200000, 9100000, 8550000, 16200000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 이그제큐티브 발코니 (4,800,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '이그제큐티브 발코니', 'Executive Balcony',
   9600000, 7200000, 9600000, 8550000, 17200000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 레거시 스위트 (5,850,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '레거시 스위트', 'Legacy Suite',
   11700000, 7200000, 11700000, 8550000, 20600000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 갤러리 스위트 (13,100,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '갤러리 스위트', 'Gallery Suite',
   26200000, 7200000, 26200000, 8550000, 45800000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30');

-- ============================================
-- 기간 2: 2026/05/01 - 09/30 (프로모션, 1박2일 기준 -3~5%)
-- 1박2일 가격의 2배
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 디럭스 발코니 (4,400,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '디럭스 발코니', 'Deluxe Balcony',
   8800000, 6700000, 8800000, 8050000, 15000000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 이그제큐티브 발코니 (4,650,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '이그제큐티브 발코니', 'Executive Balcony',
   9300000, 6700000, 9300000, 8050000, 16000000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 레거시 스위트 (5,600,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '레거시 스위트', 'Legacy Suite',
   11200000, 6700000, 11200000, 8050000, 19100000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 갤러리 스위트 (13,000,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '갤러리 스위트', 'Gallery Suite',
   26000000, 6700000, 26000000, 8050000, 44600000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30');

-- ============================================
-- 기간 3: 2026/10/01 - 12/31 (정가)
-- 1박2일 가격의 2배
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 디럭스 발코니 (4,550,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '디럭스 발코니', 'Deluxe Balcony',
   9100000, 7200000, 9100000, 8550000, 16200000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 이그제큐티브 발코니 (4,800,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '이그제큐티브 발코니', 'Executive Balcony',
   9600000, 7200000, 9600000, 8550000, 17200000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 레거시 스위트 (5,850,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '레거시 스위트', 'Legacy Suite',
   11700000, 7200000, 11700000, 8550000, 20600000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 갤러리 스위트 (13,100,000 × 2)
  ('파라다이스 레거시 크루즈', '2N3D', '갤러리 스위트', 'Gallery Suite',
   26200000, 7200000, 26200000, 8550000, 45800000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31');

-- ============================================
-- Step 1: 2박3일 추가요금 (Holiday Surcharge) 입력
-- 1박2일 기준 추가요금의 2배
-- ============================================

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  ('파라다이스 레거시 크루즈', '2N3D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 2700000, 2026, 'VND'),
  ('파라다이스 레거시 크루즈', '2N3D', '2026-12-31', NULL, '연말 추가요금', 2700000, 2026, 'VND');

-- ============================================
-- Step 2: 최종 검증
-- ============================================

SELECT '✅ 파라다이스 레거시 크루즈 2박3일 레이트카드 데이터 추가 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type,
  COUNT(DISTINCT room_type) as 객실수,
  COUNT(DISTINCT valid_from) as 기간수
FROM cruise_rate_card
WHERE cruise_name = '파라다이스 레거시 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type
ORDER BY schedule_type;

SELECT 
  schedule_type,
  room_type,
  valid_from,
  price_adult as 성인가격,
  price_child as 아동가격,
  price_extra_bed as 엑스트라베드,
  price_single as 싱글룸
FROM cruise_rate_card
WHERE cruise_name = '파라다이스 레거시 크루즈'
  AND valid_year = 2026
ORDER BY schedule_type, valid_from, room_type;

SELECT '✅ 파라다이스 레거시 크루즈 2박3일 추가요금 데이터 추가 완료' AS 결과;

SELECT 
  schedule_type,
  holiday_name,
  surcharge_per_person as 추가요금
FROM cruise_holiday_surcharge
WHERE cruise_name = '파라다이스 레거시 크루즈'
  AND valid_year = 2026
ORDER BY schedule_type, holiday_date;
