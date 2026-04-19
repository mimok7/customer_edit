-- ============================================================================
-- 투어 시스템 스키마 확장 (Dragon Pearl Cave 및 프로그램 타입 지원)
-- ============================================================================
-- 실행 전: 011-tour-system-tables-2026.sql 완료 필수
-- 역할: 프로그램 타입(Lunch/Evening), 결제방식별 가격, 크루즈 통합 관리 추가

BEGIN;

-- ============================================================================
-- 1. tour 테이블 확장
-- ============================================================================

-- 프로그램 타입 추가 (lunch, evening, fullday, custom 등)
ALTER TABLE tour
ADD COLUMN IF NOT EXISTS program_type TEXT DEFAULT NULL 
CHECK (program_type IS NULL OR program_type IN ('lunch', 'evening', 'fullday', 'half_day', 'custom'));

-- 크루즈 추가상품 여부 추가
ALTER TABLE tour
ADD COLUMN IF NOT EXISTS is_cruise_addon BOOLEAN DEFAULT false;

-- ============================================================================
-- 2. tour_payment_pricing 테이블 생성 (결제방식별 가격 관리)
-- ============================================================================

CREATE TABLE IF NOT EXISTS tour_payment_pricing (
  payment_pricing_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL,
  payment_method TEXT NOT NULL, -- card, wire, cash
  price DECIMAL(12, 0) NOT NULL,
  price_adjustment DECIMAL(12, 0), -- 기본가격 대비 조정금액 (예: -50000)
  currency TEXT DEFAULT 'VND',
  valid_from DATE DEFAULT CURRENT_DATE,
  valid_until DATE,
  notes TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_tour FOREIGN KEY (tour_id) REFERENCES tour(tour_id) ON DELETE CASCADE,
  CONSTRAINT ck_payment_method CHECK (payment_method IN ('card', 'wire', 'cash', 'other')),
  CONSTRAINT ck_currency CHECK (currency IN ('VND', 'KRW', 'USD', 'EUR'))
);

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_tour_payment_pricing_tour_id 
  ON tour_payment_pricing(tour_id);
CREATE INDEX IF NOT EXISTS idx_tour_payment_pricing_method 
  ON tour_payment_pricing(tour_id, payment_method);
CREATE INDEX IF NOT EXISTS idx_tour_payment_pricing_active 
  ON tour_payment_pricing(tour_id, is_active);

-- ============================================================================
-- 3. tour_cruise_integration 테이블 생성 (크루즈 통합 관리)
-- ============================================================================

CREATE TABLE IF NOT EXISTS tour_cruise_integration (
  cruise_integration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL,
  is_cruise_compatible BOOLEAN DEFAULT true,
  cruise_addon_type TEXT DEFAULT 'standalone', -- main_cruise_addon, standalone, hybrid
  cruise_linking_note TEXT,
  requires_cruise_booking BOOLEAN DEFAULT false,
  cruise_booking_code TEXT,
  cruise_contact_info JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_cruise_tour FOREIGN KEY (tour_id) REFERENCES tour(tour_id) ON DELETE CASCADE,
  CONSTRAINT ck_cruise_addon_type CHECK (cruise_addon_type IN ('main_cruise_addon', 'standalone', 'hybrid'))
);

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_tour_cruise_integration_tour_id 
  ON tour_cruise_integration(tour_id);
CREATE INDEX IF NOT EXISTS idx_tour_cruise_integration_active 
  ON tour_cruise_integration(is_active);
CREATE INDEX IF NOT EXISTS idx_tour_cruise_integration_addon_type 
  ON tour_cruise_integration(cruise_addon_type);

-- ============================================================================
-- 4. tour_pricing 테이블 확장 (선택적 - 결제방식 기본값)
-- ============================================================================

ALTER TABLE tour_pricing
ADD COLUMN IF NOT EXISTS default_payment_method TEXT DEFAULT 'cash' 
CHECK (default_payment_method IN ('cash', 'card', 'wire', 'both'));

-- ============================================================================
-- 5. 기본 인덱스 추가 (성능 최적화)
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_tour_program_type ON tour(program_type);
CREATE INDEX IF NOT EXISTS idx_tour_is_cruise_addon ON tour(is_cruise_addon);

-- ============================================================================
-- 데이터 확인용 쿼리
-- ============================================================================

SELECT 'SCHEMA EXTENSION COMPLETE' AS status;

COMMIT;

-- ============================================================================
-- 검증 쿼리 (주석 처리 - 필요시 실행)
-- ============================================================================

-- tour 테이블 구조 확인
-- SELECT column_name, data_type, is_nullable 
-- FROM information_schema.columns 
-- WHERE table_name = 'tour' 
-- AND column_name IN ('program_type', 'is_cruise_addon')
-- ORDER BY ordinal_position;

-- tour_payment_pricing 테이블 확인
-- SELECT 'tour_payment_pricing' AS table_name, COUNT(*) AS row_count FROM tour_payment_pricing;

-- tour_cruise_integration 테이블 확인
-- SELECT 'tour_cruise_integration' AS table_name, COUNT(*) AS row_count FROM tour_cruise_integration;
