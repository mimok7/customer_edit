-- ============================================================================
-- 044-add-catherine-horizon-shuttle-rentcar-price.sql
-- 목적: 캐서린 호라이즌 DAY 셔틀리무진(편도/왕복)을 차량(rentcar_price)으로 등록
-- ============================================================================

BEGIN;

-- 중복 방지: 동일 rent_code는 교체
DELETE FROM public.rentcar_price
WHERE rent_code IN (
  'CRUISE_SHUTTLE_CATHERINE_HORIZON_ONEWAY_2026',
  'CRUISE_SHUTTLE_CATHERINE_HORIZON_ROUNDTRIP_2026'
);

INSERT INTO public.rentcar_price (
  rent_code,
  category,
  car_category_code,
  vehicle_type,
  route,
  route_from,
  route_to,
  way_type,
  price,
  capacity,
  duration_hours,
  rental_type,
  year,
  cruise,
  memo,
  description,
  is_active
) VALUES
(
  'CRUISE_SHUTTLE_CATHERINE_HORIZON_ONEWAY_2026',
  '캐서린 호라이즌 크루즈',
  '크루즈',
  '크루즈 셔틀 리무진',
  '하노이 - 하롱베이',
  '하노이',
  '하롱베이',
  '편도',
  500000,
  NULL,
  NULL,
  '공유차량',
  2026,
  '캐서린 호라이즌 크루즈',
  '캐서린 호라이즌 DAY 셔틀리무진 편도',
  '하노이 올드쿼터(호안끼엠 인근) 픽업/드랍 | 1인당 편도요금 500,000동',
  true
),
(
  'CRUISE_SHUTTLE_CATHERINE_HORIZON_ROUNDTRIP_2026',
  '캐서린 호라이즌 크루즈',
  '크루즈',
  '크루즈 셔틀 리무진',
  '하노이 - 하롱베이',
  '하노이',
  '하롱베이',
  '당일왕복',
  850000,
  NULL,
  NULL,
  '공유차량',
  2026,
  '캐서린 호라이즌 크루즈',
  '캐서린 호라이즌 DAY 셔틀리무진 왕복',
  '하노이 올드쿼터(호안끼엠 인근) 픽업/드랍 | 1인당 왕복요금 850,000동',
  true
);

COMMIT;

-- 검증
SELECT
  rent_code,
  vehicle_type,
  way_type,
  route,
  price,
  cruise,
  is_active
FROM public.rentcar_price
WHERE cruise = '캐서린 호라이즌 크루즈'
  AND vehicle_type = '크루즈 셔틀 리무진'
  AND year = 2026
ORDER BY way_type, price;
