-- ============================================================================
-- 예약 시스템 마이그레이션: reservation_hotel ↔ hotel_price_v3 연동
-- ============================================================================
-- 목표: 기존 reservation_hotel의 hotel_price_code 
--      → hotel_price_v3.price_id로 매핑
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1단계: 기존 예약 데이터 백업
-- ============================================================================

CREATE TABLE IF NOT EXISTS reservation_hotel_backup AS
SELECT * FROM reservation_hotel;

-- ============================================================================
-- 2단계: 가격 코드 매핑 테이블 생성 (v3 ↔ V3 호환성)
-- ============================================================================

CREATE TABLE IF NOT EXISTS hotel_price_code_mapping (
  old_code TEXT PRIMARY KEY,
  new_price_id UUID NOT NULL REFERENCES hotel_price_v3(price_id),
  hotel_code VARCHAR(10),
  room_code VARCHAR(30),
  season_key VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- 3단계: 기존 hotel_price_code를 새로운 price_id로 매핑
-- ============================================================================

-- 기존 가격 코드 확인 (마이그레이션 전)
-- SELECT DISTINCT hotel_price_code FROM reservation_hotel WHERE hotel_price_code IS NOT NULL;

-- 매핑 테이블 생성 - 기존 hotel_price_code 형식: "ALACARTE_DELUXE_KING_LOW_2026_WEEKDAY" 등
INSERT INTO hotel_price_code_mapping (old_code, new_price_id, hotel_code, room_code, season_key)
SELECT DISTINCT
  hp_old.hotel_price_code,
  hp_new.price_id,
  hp_new.hotel_code,
  hp_new.room_code,
  hp_new.season_key
FROM (
  SELECT DISTINCT hotel_price_code FROM reservation_hotel WHERE hotel_price_code IS NOT NULL
) hp_old
LEFT JOIN hotel_price_v3 hp_new ON (
  SUBSTRING(hp_old.hotel_price_code FROM 1 FOR 10) = hp_new.hotel_code
  AND SUBSTRING(hp_old.hotel_price_code FROM 11) LIKE CONCAT(hp_new.room_code, '%')
)
WHERE hp_new.price_id IS NOT NULL
ON CONFLICT (old_code) DO NOTHING;

-- ============================================================================
-- 4단계: reservation_hotel 테이블 확장 (새 컬럼 추가)
-- ============================================================================

-- 새 컬럼 추가 (기존 데이터 유지)
ALTER TABLE reservation_hotel 
ADD COLUMN IF NOT EXISTS price_id_v3 UUID REFERENCES hotel_price_v3(price_id);

-- 기존 hotel_price_code를 price_id_v3로 변환
UPDATE reservation_hotel rh
SET price_id_v3 = mapping.new_price_id
FROM hotel_price_code_mapping mapping
WHERE rh.hotel_price_code = mapping.old_code
  AND rh.price_id_v3 IS NULL;

-- ============================================================================
-- 5단계: 예약 데이터 검증
-- ============================================================================

-- 마이그레이션 후 상태 확인
-- SELECT 
--   COUNT(DISTINCT re_id)::TEXT as 총_예약수,
--   COUNT(DISTINCT CASE WHEN price_id_v3 IS NOT NULL THEN re_id END)::TEXT as 매핑된_예약수,
--   COUNT(DISTINCT CASE WHEN price_id_v3 IS NULL THEN re_id END)::TEXT as 미매핑_예약수
-- FROM reservation_hotel
-- WHERE schedule != 0;  -- 호텔 예약만 필터링

-- ============================================================================
-- 6단계: 매핑된 가격 데이터 샘플 확인
-- ============================================================================

-- SELECT 
--   r.re_id as 예약ID,
--   r.hotel_price_code as 기존_가격코드,
--   hp.hotel_code,
--   hp.room_code,
--   hp.season_key,
--   hp.base_price
-- FROM reservation_hotel r
-- LEFT JOIN hotel_price_v3 hp ON r.price_id_v3 = hp.price_id
-- WHERE r.price_id_v3 IS NOT NULL
-- LIMIT 10;

COMMIT;

-- ============================================================================
-- 실행 후 필수 작업 (별도 실행)
-- ============================================================================

/*
-- 1. 검증 쿼리 실행하여 매핑 상태 확인

-- 2. 모든 예약이 성공적으로 매핑되었으면 기존 컬럼 제거 (선택사항)
-- ALTER TABLE reservation_hotel DROP COLUMN hotel_price_code;

-- 3. 기존 예약 시스템이 price_id_v3를 사용하도록 코드 업데이트 필요
-- (app/mypage 및 manager 페이지에서 쿼리 변경)

-- 4. 안전 기간(1주일) 후 백업 테이블 제거
-- DROP TABLE reservation_hotel_backup;
-- DROP TABLE hotel_price_code_mapping;
*/
