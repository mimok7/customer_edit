-- ============================================================
-- cruise_document: 여권(passport) 업로드 시 크루즈 예약 연결 강제
-- 조건:
-- 1) reservation_id 필수
-- 2) 본인(auth.uid())의 cruise 예약이어야 함
-- 3) reservation_cruise.checkin 이 오늘(KST) 이후/당일이어야 함
-- ============================================================

BEGIN;

DROP POLICY IF EXISTS cruise_document_insert ON cruise_document;

CREATE POLICY cruise_document_insert ON cruise_document
    FOR INSERT TO authenticated
    WITH CHECK (
        user_id = auth.uid()
        AND (
            document_type <> 'passport'
            OR (
                reservation_id IS NOT NULL
                AND EXISTS (
                    SELECT 1
                    FROM reservation r
                    JOIN reservation_cruise rc ON rc.reservation_id = r.re_id
                    WHERE r.re_id = cruise_document.reservation_id
                      AND r.re_user_id = auth.uid()
                      AND r.re_type = 'cruise'
                      AND rc.checkin::date >= (now() AT TIME ZONE 'Asia/Seoul')::date
                )
            )
        )
    );

COMMIT;
