-- ============================================================================
-- Catherine Horizon Cruise - One-Day Tour
-- 캐서린 호라이즌 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   출항연도: 2026년 4월
--   적용 기간: 2026-04-01 ~ 2026-12-31
--   층별 요금:
--     1층 PREMIUM   : 성인 1,800,000 / 5-12세 1,550,000 / 2-4세 1,200,000
--     2층 ELITE     : 성인 2,025,000 / 5-12세 1,725,000 / 2-4세 1,350,000
--     3층 SIGNATURE : 성인 2,150,000 / 5-12세 1,825,000 / 2-4세 1,425,000
--   추가 옵션:
--     카약킹 1인당 150,000동
--     셔틀리무진 왕복 1인당 850,000동
--     셔틀리무진 편도 1인당 500,000동
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. 기존 데이터 정리 (재실행 가능)
-- ============================================================================
DELETE FROM public.cruise_rate_card
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY'
  AND valid_year = 2026;

DELETE FROM public.cruise_holiday_surcharge
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY'
  AND valid_year = 2026;

DELETE FROM public.cruise_tour_options
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
-- ============================================================================
INSERT INTO public.cruise_rate_card (
  cruise_name,
  schedule_type,
  room_type,
  room_type_en,
  price_adult,
  price_child,
  price_infant,
  price_extra_bed,
  price_child_extra_bed,
  price_single,
  extra_bed_available,
  valid_year,
  valid_from,
  valid_to,
  currency,
  season_name,
  child_age_range,
  infant_policy,
  is_active,
  display_order,
  notes
) VALUES
(
  '캐서린 호라이즌 크루즈',
  'DAY',
  '1층 PREMIUM',
  '1F PREMIUM',
  1800000,
  1550000,
  1200000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-04-01',
  '2026-12-31',
  'VND',
  '층별 요금',
  '5~12세',
  '2~4세',
  true,
  1,
  '층에 따라 메뉴 다름 | 음료,주류 별도요금 | 비가 오더라도 크루즈는 정상출항 합니다 | 투어일정은 크루즈사측의 사정이나 관광지 사정 등에 따라 달라질 수 있습니다 | 비가 많이 올 경우 외부투어는 안전을 위해 취소될 수 있습니다 | 이용일자 31일 전 까지 : 100만동 위약금 발생 | 이용일자 21일전 부터 30일 전 까지 : 10% 위약금 발생 | 이용일자 11일 전 부터 20일 전 까지 : 20% 위약금 발생 | 이용일자 10일 전 부터 : 취소 및 환불, 날짜변경 불가 | 천재지변, 태풍으로 인한 정부명령, 크루즈 승선인원 미달에 따른 크루즈 결항, 크루즈사측 사정에 떠른 크루즈 결항은 위 취소규정과 무관하게 전액 반환이 보장 됩니다'
),
(
  '캐서린 호라이즌 크루즈',
  'DAY',
  '2층 ELITE',
  '2F ELITE',
  2025000,
  1725000,
  1350000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-04-01',
  '2026-12-31',
  'VND',
  '층별 요금',
  '5~12세',
  '2~4세',
  true,
  2,
  '층에 따라 메뉴 다름 | 음료,주류 별도요금 | 비가 오더라도 크루즈는 정상출항 합니다 | 투어일정은 크루즈사측의 사정이나 관광지 사정 등에 따라 달라질 수 있습니다 | 비가 많이 올 경우 외부투어는 안전을 위해 취소될 수 있습니다 | 이용일자 31일 전 까지 : 100만동 위약금 발생 | 이용일자 21일전 부터 30일 전 까지 : 10% 위약금 발생 | 이용일자 11일 전 부터 20일 전 까지 : 20% 위약금 발생 | 이용일자 10일 전 부터 : 취소 및 환불, 날짜변경 불가 | 천재지변, 태풍으로 인한 정부명령, 크루즈 승선인원 미달에 따른 크루즈 결항, 크루즈사측 사정에 떠른 크루즈 결항은 위 취소규정과 무관하게 전액 반환이 보장 됩니다'
),
(
  '캐서린 호라이즌 크루즈',
  'DAY',
  '3층 SIGNATURE',
  '3F SIGNATURE',
  2150000,
  1825000,
  1425000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-04-01',
  '2026-12-31',
  'VND',
  '층별 요금',
  '5~12세',
  '2~4세',
  true,
  3,
  '층에 따라 메뉴 다름 | 음료,주류 별도요금 | 비가 오더라도 크루즈는 정상출항 합니다 | 투어일정은 크루즈사측의 사정이나 관광지 사정 등에 따라 달라질 수 있습니다 | 비가 많이 올 경우 외부투어는 안전을 위해 취소될 수 있습니다 | 이용일자 31일 전 까지 : 100만동 위약금 발생 | 이용일자 21일전 부터 30일 전 까지 : 10% 위약금 발생 | 이용일자 11일 전 부터 20일 전 까지 : 20% 위약금 발생 | 이용일자 10일 전 부터 : 취소 및 환불, 날짜변경 불가 | 천재지변, 태풍으로 인한 정부명령, 크루즈 승선인원 미달에 따른 크루즈 결항, 크루즈사측 사정에 떠른 크루즈 결항은 위 취소규정과 무관하게 전액 반환이 보장 됩니다'
);

-- ============================================================================
-- 3. 선택 옵션 데이터 (cruise_tour_options)
-- ============================================================================
INSERT INTO public.cruise_tour_options (
  cruise_name,
  schedule_type,
  option_name,
  option_name_en,
  option_price,
  option_type,
  description,
  is_active
) VALUES
(
  '캐서린 호라이즌 크루즈',
  'DAY',
  '카약킹',
  'Kayaking',
  150000,
  'addon',
  '별도 추가옵션 | 카약킹 1인당 150,000동',
  true
),
(
  '캐서린 호라이즌 크루즈',
  'DAY',
  '크루즈 셔틀리무진 왕복',
  'Cruise Shuttle Limousine Round Trip',
  850000,
  'addon',
  '하노이 올드쿼터(호안끼엠 인근) 기준 1인 왕복요금',
  true
),
(
  '캐서린 호라이즌 크루즈',
  'DAY',
  '크루즈 셔틀리무진 편도',
  'Cruise Shuttle Limousine One Way',
  500000,
  'addon',
  '하노이 올드쿼터(호안끼엠 인근) 기준 1인 편도요금',
  true
);

COMMIT;

-- ============================================================================
-- 4. 검증 쿼리
-- ============================================================================
SELECT '=== Catherine Horizon Day Tour | 기본 요금 ===' AS status;

SELECT
  room_type,
  season_name,
  TO_CHAR(price_adult, 'FM999,999,999') || '동' AS adult_price,
  TO_CHAR(price_child, 'FM999,999,999') || '동' AS child_5_12_price,
  TO_CHAR(price_infant, 'FM999,999,999') || '동' AS child_2_4_price,
  valid_from,
  valid_to
FROM public.cruise_rate_card
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY'
ORDER BY display_order;

SELECT '=== Catherine Horizon Day Tour | 선택 옵션 ===' AS status;

SELECT
  option_name,
  option_name_en,
  TO_CHAR(option_price, 'FM999,999,999') || '동' AS option_price,
  option_type,
  description
FROM public.cruise_tour_options
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price;

SELECT '✅ Catherine Horizon One-Day Tour 데이터 입력 SQL 준비 완료'::TEXT AS status;
