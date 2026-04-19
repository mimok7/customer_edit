-- ============================================================================
-- 호텔 스키마 재설계 (간소화)
-- ============================================================================
-- 삭제: pricing_model, room_type, hotel_info (복잡 버전) + 관련 ENUM 타입
-- 유지: hotel (견적 서비스), reservation_hotel (예약 상세)
-- 신규: hotel_info (간소화), hotel_price (개선)
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1단계: 불필요한 테이블 삭제
-- ============================================================================

-- 뷰 먼저 삭제 (의존성)
DROP VIEW IF EXISTS current_pricing_2026 CASCADE;

-- V3 복잡 테이블 삭제 (트리거는 테이블 존재 시에만 삭제)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'pricing_model') THEN
    DROP TRIGGER IF EXISTS update_pricing_model_timestamp ON pricing_model;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'room_type') THEN
    DROP TRIGGER IF EXISTS update_room_type_timestamp ON room_type;
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'hotel_info') THEN
    DROP TRIGGER IF EXISTS update_hotel_info_timestamp ON hotel_info;
  END IF;
END $$;
DROP TABLE IF EXISTS pricing_model CASCADE;
DROP TABLE IF EXISTS room_type CASCADE;
DROP TABLE IF EXISTS hotel_info CASCADE;

-- 백업 테이블 잔여물 삭제
DROP TABLE IF EXISTS pricing_model_backup CASCADE;
DROP TABLE IF EXISTS room_type_backup CASCADE;
DROP TABLE IF EXISTS hotel_info_backup CASCADE;
DROP TABLE IF EXISTS hotel_price_v3 CASCADE;
DROP TABLE IF EXISTS hotel_info_v2 CASCADE;
DROP TABLE IF EXISTS hotel_price_code_mapping CASCADE;
DROP TABLE IF EXISTS reservation_hotel_backup CASCADE;

-- ENUM 타입 삭제 (의존 테이블 삭제 후 가능)
DROP TYPE IF EXISTS hotel_product_type CASCADE;
DROP TYPE IF EXISTS room_category_type CASCADE;
DROP TYPE IF EXISTS pricing_model_type CASCADE;
DROP TYPE IF EXISTS day_of_week_type CASCADE;
DROP TYPE IF EXISTS reservation_status_type CASCADE;

-- ============================================================================
-- 2단계: hotel_info 재생성 (간소화 - ENUM/JSONB/ARRAY 제거)
-- ============================================================================

CREATE TABLE IF NOT EXISTS hotel_info (
  hotel_code  VARCHAR(20)  PRIMARY KEY,
  hotel_name  TEXT         NOT NULL,
  product_type TEXT        NOT NULL DEFAULT 'HOTEL',
  -- 상품 타입: HOTEL / RESORT_ONSEN / VILLA_POOL / VILLA_RESORT
  location    TEXT,
  star_rating INTEGER      CHECK (star_rating >= 1 AND star_rating <= 5),
  check_in_time  TIME      DEFAULT '14:00:00',
  check_out_time TIME      DEFAULT '11:00:00',
  phone       TEXT,
  currency    VARCHAR(3)   DEFAULT 'VND',
  notes       TEXT,
  active      BOOLEAN      DEFAULT TRUE,
  created_at  TIMESTAMP    DEFAULT NOW(),
  updated_at  TIMESTAMP    DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hotel_info_active ON hotel_info(active);

-- ============================================================================
-- 3단계: hotel_price 재생성 (hotel_price_code PK + 개선 컬럼)
-- ============================================================================
-- 기존 hotel_price 테이블: hotel_code, hotel_name, room_name, room_type, price,
--   start_date, end_date, weekday_type, updated_at
-- → hotel_price_code (PK 추가), hotel_info FK 추가, 필요 컬럼 보강

-- 기존 hotel_price 데이터 백업
CREATE TABLE IF NOT EXISTS hotel_price_backup AS
SELECT * FROM hotel_price;

-- 기존 hotel_price 삭제 후 재생성
DROP TABLE IF EXISTS hotel_price CASCADE;

CREATE TABLE hotel_price (
  hotel_price_code  TEXT         PRIMARY KEY,
  -- 코드 형식: {HOTEL_CODE}_{ROOM_TYPE}_{SEASON_KEY}_{DAY_TYPE}
  -- 예: ALACARTE_DELUXE_KING_LOW_2026_WEEKDAY
  hotel_code        VARCHAR(20)  NOT NULL REFERENCES hotel_info(hotel_code),
  hotel_name        TEXT         NOT NULL,

  -- 객실 정보
  room_type         TEXT         NOT NULL,
  -- 코드: DELUXE_KING / DELUXE_TWIN / SUPERIOR_KING / JUNIOR_SUITE 등
  room_name         TEXT         NOT NULL,
  -- 표시명: Deluxe King Room
  room_category     TEXT         DEFAULT 'STANDARD',
  -- STANDARD / SUITE / FAMILY / VILLA / DAY_PASS
  occupancy_max     INTEGER,
  include_breakfast BOOLEAN      DEFAULT TRUE,

  -- 가격 정보
  base_price        NUMERIC      NOT NULL,
  extra_person_price NUMERIC,
  child_policy      TEXT,

  -- 시즌 / 날짜
  season_name       TEXT,
  -- 예: LOW SEASON - 평일
  start_date        DATE         NOT NULL,
  end_date          DATE         NOT NULL,
  weekday_type      TEXT         DEFAULT 'ALL',
  -- WEEKDAY / WEEKEND / ALL

  notes             TEXT,
  created_at        TIMESTAMP    DEFAULT NOW(),
  updated_at        TIMESTAMP    DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hotel_price_hotel_code   ON hotel_price(hotel_code);
CREATE INDEX IF NOT EXISTS idx_hotel_price_room_type    ON hotel_price(room_type);
CREATE INDEX IF NOT EXISTS idx_hotel_price_date_range   ON hotel_price(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_hotel_price_weekday_type ON hotel_price(weekday_type);

COMMIT;
