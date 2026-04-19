-- ============================================================================
-- 043-remove-catherine-horizon-shuttle-tour-options.sql
-- 목적: 캐서린 호라이즌 DAY 상품의 셔틀리무진 편도/왕복을 tour option에서 제거
-- ============================================================================

BEGIN;

DELETE FROM public.cruise_tour_options
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY'
  AND (
    option_name IN ('크루즈 셔틀리무진 왕복', '크루즈 셔틀리무진 편도')
    OR option_name_en IN (
      'Cruise Shuttle Limousine Round Trip',
      'Cruise Shuttle Limousine One Way'
    )
  );

COMMIT;

-- 검증
SELECT
  option_name,
  option_name_en,
  option_price,
  option_type,
  is_active
FROM public.cruise_tour_options
WHERE cruise_name = '캐서린 호라이즌 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price, option_name;
