-- 999-delete-reservations-no-quote.sql
-- 목적: reservation 테이블에서 re_quote_id가 비어있는(또는 빈 문자열) 행을 안전하게 삭제하기 위한 SQL
-- 사용 전 주의: 프로덕션에서 실행하기 전에 반드시 데이터베이스 백업 및 관리자 승인 필요

-- 1) 미리보기: 삭제 대상 확인
-- 실행: 조회 후 결과를 확인하세요
SELECT *
FROM reservation
WHERE COALESCE(re_quote_id::text, '') = '';

-- 2) 개수 확인
SELECT COUNT(*) AS cnt
FROM reservation
WHERE COALESCE(re_quote_id::text, '') = '';

-- 3) (권장) 삭제 대상 백업
-- 백업 테이블을 생성하여 삭제 전 원본을 보관합니다.
CREATE TABLE IF NOT EXISTS reservation_no_quote_backup AS
SELECT *
FROM reservation
WHERE COALESCE(re_quote_id::text, '') = '';

-- 4) 안전한 삭제: 트랜잭션 사용, 관련 하위 테이블도 먼저 백업/삭제
-- 하위 테이블 이름은 환경에 따라 다를 수 있습니다. 아래는 일반적인 reservation_* 테이블 예시입니다.
BEGIN;

-- 임시 테이블에 삭제 대상 ID 저장
CREATE TEMP TABLE tmp_res_no_quote AS
SELECT re_id FROM reservation WHERE COALESCE(re_quote_id::text, '') = '';

-- (선택) 하위 테이블 백업 — 필요에 따라 주석/해제하세요
CREATE TABLE IF NOT EXISTS reservation_no_quote_reservation_tour_backup AS
SELECT rt.* FROM reservation_tour rt JOIN tmp_res_no_quote t ON rt.reservation_id = t.re_id;

CREATE TABLE IF NOT EXISTS reservation_no_quote_reservation_airport_backup AS
SELECT ra.* FROM reservation_airport ra JOIN tmp_res_no_quote t ON ra.reservation_id = t.re_id;

CREATE TABLE IF NOT EXISTS reservation_no_quote_reservation_cruise_backup AS
SELECT rc.* FROM reservation_cruise rc JOIN tmp_res_no_quote t ON rc.reservation_id = t.re_id;

-- 하위 테이블 먼저 삭제 (FK 제약으로 인해 순서 중요)
DELETE FROM reservation_tour WHERE reservation_id IN (SELECT re_id FROM tmp_res_no_quote);
DELETE FROM reservation_airport WHERE reservation_id IN (SELECT re_id FROM tmp_res_no_quote);
DELETE FROM reservation_cruise WHERE reservation_id IN (SELECT re_id FROM tmp_res_no_quote);

-- 필요하면 다른 reservation_* 테이블들도 동일 방식으로 추가하세요

-- 최종적으로 reservation 행 삭제
DELETE FROM reservation WHERE re_id IN (SELECT re_id FROM tmp_res_no_quote);

COMMIT;

-- 정리: 임시 테이블은 세션 종료 시 자동 삭제되지만, 필요시 명시적으로 삭제할 수 있습니다.
-- DROP TABLE IF EXISTS tmp_res_no_quote;

-- 실패 시 롤백 예시 (수동 실행 시 사용)
-- ROLLBACK;

-- 참고: 대량 삭제 시 인덱스/로그 영향 고려. 트랜잭션이 너무 커서 문제가 발생하면
-- 작은 배치(예: LIMIT, OFFSET 또는 re_id 범위로 분할)로 나눠 실행하세요.
