-- ============================================================================
-- room_price 테이블 FK 제약 제거 및 room_price_code → cruise_rate_card 전환
-- ============================================================================
-- 실행 순서: Supabase Dashboard → SQL Editor에서 실행
-- 목적: reservation_cruise.room_price_code가 더 이상 room_price를 참조하지 않도록 변경
--        이후 cruise_rate_card.id(UUID)를 직접 저장
-- ============================================================================

BEGIN;

-- 1. reservation_cruise → room_price FK 제약 제거
ALTER TABLE reservation_cruise
  DROP CONSTRAINT IF EXISTS reservation_cruise_room_price_code_fkey;

-- 2. (선택) 기존 room_price 참조 데이터가 있다면, cruise_rate_card.id로 전환
--    기존 row의 room_price_code 값은 그대로 유지 (호환성)
--    새 예약부터 cruise_rate_card.id가 저장됨

-- 3. room_price 테이블 삭제 (주의: 되돌릴 수 없음!)
-- 아래 주석을 해제하여 실행하면 room_price 테이블이 완전히 삭제됩니다.
-- DROP TABLE IF EXISTS room_price CASCADE;

SELECT 'FK constraint dropped successfully. room_price_code now accepts cruise_rate_card.id' AS status;

COMMIT;
