-- reservation_cruise 테이블에 커넥팅룸 선택 여부 컬럼 추가
-- 역할: 예약 시 고객이 커넥팅룸 신청 여부를 저장

-- reservation_cruise 테이블에 connecting_room 컬럼 추가 (boolean, 기본값: false)
ALTER TABLE reservation_cruise
ADD COLUMN connecting_room BOOLEAN DEFAULT FALSE;

-- 컬럼 설명 추가 (선택사항)
COMMENT ON COLUMN reservation_cruise.connecting_room IS '커넥팅룸 신청 여부 (true: 신청함, false: 신청 안함)';

-- 기존 데이터는 모두 false로 초기화됨 (DEFAULT 값 적용)
-- 변경사항 확인 (실행 후 주석 처리 해제하여 테스트)
-- SELECT id, connecting_room FROM reservation_cruise LIMIT 10;
