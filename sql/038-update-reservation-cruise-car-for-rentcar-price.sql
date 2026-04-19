-- ============================================================
-- 038-update-reservation-cruise-car-for-rentcar-price.sql
-- 목적:
-- 1) reservation_cruise_car가 rentcar_price 기반 코드/속성을 함께 저장하도록 확장
-- 2) 기존 car_price_code 컬럼과 호환 유지
-- ============================================================

BEGIN;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS rentcar_price_code TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS way_type TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS route TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS vehicle_type TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS rental_type TEXT;

-- rentcar_price_code가 비어있고 car_price_code가 있을 때 1차 백필
UPDATE reservation_cruise_car
SET rentcar_price_code = car_price_code
WHERE (rentcar_price_code IS NULL OR rentcar_price_code = '')
  AND car_price_code IS NOT NULL;

-- rentcar_price와 조인 가능한 경우 상세 속성 백필
UPDATE reservation_cruise_car rcc
SET
  way_type = COALESCE(rcc.way_type, rp.way_type),
  route = COALESCE(rcc.route, rp.route),
  vehicle_type = COALESCE(rcc.vehicle_type, rp.vehicle_type),
  rental_type = COALESCE(rcc.rental_type, rp.rental_type)
FROM rentcar_price rp
WHERE rp.rent_code = rcc.rentcar_price_code;

-- 조회 성능용 인덱스
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_car_rentcar_price_code
  ON reservation_cruise_car(rentcar_price_code);

CREATE INDEX IF NOT EXISTS idx_reservation_cruise_car_way_type
  ON reservation_cruise_car(way_type);

COMMIT;

-- 검증
SELECT
  COUNT(*) AS total_rows,
  COUNT(rentcar_price_code) AS with_rentcar_price_code,
  COUNT(way_type) AS with_way_type,
  COUNT(route) AS with_route,
  COUNT(vehicle_type) AS with_vehicle_type
FROM reservation_cruise_car;
