-- ============================================================
-- cruise_document: 여권 사진 다중 업로드 허용
-- 기존 1인 1여권 유니크 인덱스를 제거
-- ============================================================

BEGIN;

DROP INDEX IF EXISTS idx_cruise_document_passport_user;

-- 조회 성능 보장을 위한 일반 인덱스
CREATE INDEX IF NOT EXISTS idx_cruise_document_user_type
    ON cruise_document(user_id, document_type);

COMMIT;
