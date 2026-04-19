-- ============================================================================
-- 호텔 시스템 마이그레이션: V3 (정규화) → 단순화 (옵션B)
-- ============================================================================
-- 목표: room_type + pricing_model 통합 → hotel_price_v3
-- 기존 테이블 유지: hotel_info (간소화)
-- 삭제 테이블: room_type, pricing_model, current_pricing_2026
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1단계: 백업 (기존 데이터 보존)
-- ============================================================================

-- 기존 room_type 백업
CREATE TABLE IF NOT EXISTS room_type_backup AS
SELECT * FROM room_type;

-- 기존 pricing_model 백업
CREATE TABLE IF NOT EXISTS pricing_model_backup AS
SELECT * FROM pricing_model;

-- 기존 hotel_info 백업
CREATE TABLE IF NOT EXISTS hotel_info_backup AS
SELECT * FROM hotel_info;

-- ============================================================================
-- 2단계: hotel_price_v3 테이블 생성 (통합 테이블)
-- ============================================================================

CREATE TABLE IF NOT EXISTS hotel_price_v3 (
  price_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_code VARCHAR(10) NOT NULL,
  
  -- 객실 정보 (room_type에서 통합)
  room_code VARCHAR(30) NOT NULL,
  room_name TEXT NOT NULL,
  room_category VARCHAR(50),  -- STANDARD_ROOM, SUITE, FAMILY_ROOM, VILLA
  room_area_sqm INTEGER,
  bed_config TEXT,
  occupancy_base INTEGER,
  occupancy_max INTEGER,
  amenities TEXT,  -- JSON 문자열 또는 배열 텍스트
  view_options TEXT,  -- 쉼표 구분
  extra_bed_allowed INTEGER DEFAULT 0,
  max_children INTEGER,
  
  -- 가격 정보 (pricing_model에서 통합)
  season_key VARCHAR(100) NOT NULL,
  season_name TEXT,
  date_range_start DATE NOT NULL,
  date_range_end DATE NOT NULL,
  day_of_week VARCHAR(20),  -- WEEKDAY, WEEKEND, ANY
  base_price DECIMAL(15,2) NOT NULL,
  extra_person_price DECIMAL(15,2),
  child_policy TEXT,
  surcharge_holiday DECIMAL(15,2),
  include_breakfast BOOLEAN DEFAULT TRUE,
  include_facilities TEXT,
  notes TEXT,
  calendar_year INTEGER DEFAULT 2026,
  
  -- 메타
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  -- 제약조건
  CONSTRAINT fk_hotel_code FOREIGN KEY (hotel_code) REFERENCES hotel_info(hotel_code),
  CONSTRAINT unique_price_per_room_season UNIQUE(hotel_code, room_code, season_key, day_of_week)
);

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_hotel_price_v3_hotel_code ON hotel_price_v3(hotel_code);
CREATE INDEX IF NOT EXISTS idx_hotel_price_v3_room_code ON hotel_price_v3(room_code);
CREATE INDEX IF NOT EXISTS idx_hotel_price_v3_date_range ON hotel_price_v3(date_range_start, date_range_end);
CREATE INDEX IF NOT EXISTS idx_hotel_price_v3_calendar_year ON hotel_price_v3(calendar_year);

-- ============================================================================
-- 3단계: 데이터 마이그레이션 (room_type + pricing_model → hotel_price_v3)
-- ============================================================================

INSERT INTO hotel_price_v3 (
  hotel_code,
  room_code,
  room_name,
  room_category,
  room_area_sqm,
  bed_config,
  occupancy_base,
  occupancy_max,
  amenities,
  view_options,
  extra_bed_allowed,
  max_children,
  season_key,
  season_name,
  date_range_start,
  date_range_end,
  day_of_week,
  base_price,
  extra_person_price,
  child_policy,
  surcharge_holiday,
  include_breakfast,
  include_facilities,
  notes,
  calendar_year
)
SELECT
  h.hotel_code,
  rt.room_code,
  rt.room_name,
  rt.room_category::TEXT,
  rt.area_sqm,
  rt.bed_config,
  rt.occupancy_base,
  rt.occupancy_max,
  rt.amenities::TEXT,  -- JSONB → TEXT 변환
  ARRAY_TO_STRING(rt.view_options, ', '),  -- 배열 → 쉼표 구분 문자열
  rt.extra_bed_allowed,
  rt.max_children,
  pm.season_key,
  pm.season_name,
  pm.date_range_start,
  pm.date_range_end,
  pm.day_of_week::TEXT,
  pm.base_price,
  pm.extra_person_price,
  pm.child_policy,
  pm.surcharge_holiday,
  pm.include_breakfast,
  pm.include_facilities,
  pm.notes,
  pm.calendar_year
FROM pricing_model pm
INNER JOIN room_type rt ON pm.room_id = rt.room_id
INNER JOIN hotel_info h ON rt.hotel_id = h.hotel_id
ORDER BY h.hotel_code, rt.room_code, pm.date_range_start;

-- ============================================================================
-- 4단계: hotel_info 정규화 (불필요한 JSONB 제거)
-- ============================================================================

-- 새로운 hotel_info 생성 (간소화된 구조)
CREATE TABLE IF NOT EXISTS hotel_info_v2 (
  hotel_code VARCHAR(10) PRIMARY KEY,
  hotel_name TEXT NOT NULL,
  product_type VARCHAR(50),  -- HOTEL, RESORT_ONSEN, VILLA_POOL, VILLA_RESORT
  location TEXT,
  star_rating INTEGER CHECK (star_rating >= 1 AND star_rating <= 5),
  check_in_time TIME DEFAULT '14:00:00',
  check_out_time TIME DEFAULT '11:00:00',
  active_year INTEGER DEFAULT 2026,
  currency VARCHAR(3) DEFAULT 'VND',
  phone TEXT,
  email TEXT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 데이터 마이그레이션 (특수 기능은 notes에 통합)
INSERT INTO hotel_info_v2 (
  hotel_code,
  hotel_name,
  product_type,
  location,
  star_rating,
  check_in_time,
  check_out_time,
  active_year,
  currency,
  phone,
  email,
  notes
)
SELECT
  hotel_code,
  hotel_name,
  product_type::TEXT,
  location,
  star_rating,
  check_in_time,
  check_out_time,
  active_year[1],  -- 배열의 첫 번째 연도
  currency,
  contact_info->>'phone',  -- JSONB 추출
  contact_info->>'email',  -- JSONB 추출
  special_features::TEXT  -- JSONB → TEXT 변환
FROM hotel_info;

-- ============================================================================
-- 5단계: 기존 테이블 정리
-- ============================================================================

-- 옵션 A: 기존 테이블 유지 (마이그레이션 검증용)
-- → 주석 처리 (필요시 수동으로 실행)

/*
DROP TRIGGER IF EXISTS update_pricing_model_timestamp ON pricing_model;
DROP TRIGGER IF EXISTS update_room_type_timestamp ON room_type;
DROP VIEW IF EXISTS current_pricing_2026;
DROP TABLE IF EXISTS pricing_model CASCADE;
DROP TABLE IF EXISTS room_type CASCADE;
DROP TABLE IF EXISTS hotel_info CASCADE;

-- hotel_info_v2 → hotel_info로 이름 변경
ALTER TABLE hotel_info_v2 RENAME TO hotel_info;
*/

-- ============================================================================
-- 6단계: 검증 쿼리
-- ============================================================================

-- 마이그레이션 확인 1: 호텔 수
-- SELECT '호텔 수' as check_item, COUNT(DISTINCT hotel_code) as count FROM hotel_price_v3;

-- 마이그레이션 확인 2: 객실 타입 수
-- SELECT '객실 타입' as check_item, COUNT(DISTINCT room_code) as count FROM hotel_price_v3 WHERE hotel_code = 'ALACARTE';

-- 마이그레이션 확인 3: 가격 데이터 수
-- SELECT '가격 데이터' as check_item, COUNT(*) as count FROM hotel_price_v3;

-- 마이그레이션 확인 4: 시즌별 데이터
-- SELECT season_key, COUNT(*) as count FROM hotel_price_v3 GROUP BY season_key ORDER BY season_key;

-- 마이그레이션 확인 5: 호텔 기본정보
-- SELECT * FROM hotel_info_v2 WHERE hotel_code = 'ALACARTE';

-- 마이그레이션 확인 6: 호텔 가격 샘플 (ALACARTE)
-- SELECT hotel_code, room_code, season_key, day_of_week, base_price FROM hotel_price_v3 
-- WHERE hotel_code = 'ALACARTE' LIMIT 10;

COMMIT;

-- ============================================================================
-- 실행 후 필수 작업 (별도 실행)
-- ============================================================================

/*
-- 1. 검증을 통해 데이터 확인 후, 아래를 실행하여 기존 테이블 제거:

DROP TRIGGER IF EXISTS update_pricing_model_timestamp ON pricing_model;
DROP TRIGGER IF EXISTS update_room_type_timestamp ON room_type;
DROP TRIGGER IF EXISTS update_hotel_info_timestamp ON hotel_info;
DROP VIEW IF EXISTS current_pricing_2026;
DROP TABLE IF EXISTS pricing_model CASCADE;
DROP TABLE IF EXISTS room_type CASCADE;
DROP TABLE IF EXISTS hotel_info CASCADE;

-- 2. hotel_info_v2 → hotel_info로 이름 변경
ALTER TABLE hotel_info_v2 RENAME TO hotel_info;

-- 3. 백업 테이블 제거 (선택사항 - 안전을 위해 1주일 후 제거)
-- DROP TABLE room_type_backup;
-- DROP TABLE pricing_model_backup;
-- DROP TABLE hotel_info_backup;

-- 4. 새로운 예약 통합 (reservation_hotel을 기반으로 재작성)
-- (별도 마이그레이션 스크립트 필요)
*/
