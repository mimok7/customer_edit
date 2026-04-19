-- ============================================================================
-- L7 웨스트레이크 하노이 호텔 (L7 West Lake Hanoi by Lotte) 데이터
-- 하노이 5성급 라이프스타일 호텔 (롯데 운영)
-- ============================================================================
-- 실행 순서: 020-hotel-schema-rebuild.sql 이후 실행
-- ※ 시즌 구분: 없음 (연중 단일 가격)
-- ※ 요일 구분: 없음 (weekday_type: ALL)
-- ※ 위치: 하노이 서호(West Lake) 인근
-- ============================================================================
-- 객실 구성 (7행):
--   슈페리어 시티뷰                    (38~40m², 성인2,  3,450,000동)
--   슈페리어 레이크뷰                  (38~40m², 성인2,  4,000,000동)
--   슈페리어 패밀리 트리플             (38~40m², 성인3,  4,850,000동)
--   슈페리어 클럽 플로어 시티뷰        (38~40m², 성인2,  5,350,000동)
--   슈페리어 클럽 플로어 레이크뷰      (38~40m², 성인2,  5,900,000동)
--   스튜디오 스위트 레이크뷰           (82m²,    성인2,  개별문의)
--   어퍼 하우스 레이크뷰               (130m²,   성인2,  개별문의)
-- ============================================================================
-- 포함사항: 조식뷔페(21층), 봉사료+VAT, 무료 WIFI, GYM·사우나·인피니티풀
--           객실 내 생수2병, 티·커피 세트
-- 결제: 예약금 50% + 체크인 5일 전 잔금 (프로모션 시 100% 전액)
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. hotel_info INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location,
  star_rating, check_in_time, check_out_time,
  phone, currency, notes, active
) VALUES (
  'L7_WESTLAKE_HANOI',
  'L7 웨스트레이크 하노이',
  'HOTEL',
  '하노이 서호(West Lake) 인근, 롯데몰 하노이 연결',
  5,
  '15:00:00',
  '12:00:00',
  NULL,
  'VND',
  '5성급 라이프스타일 호텔 (Lotte 운영, L7 브랜드 해외 첫 5성급). 하노이 최대규모 롯데몰 직접 연결. 서호 인근. ▶포함사항: 조식뷔페(21층 Layered Restaurant), 봉사료+VAT, 무료 WIFI, GYM·사우나·인피니티풀, 객실 내 생수2병·티·커피 세트. ▶결제: 예약금 50%, 체크인 5일 전 잔금 (프로모션 시 100% 전액). ▶체크인 시 여권정보 호텔 제공 필요. ▶요금 정책 사전예고 없이 변경 가능.',
  TRUE
)
ON CONFLICT (hotel_code) DO UPDATE SET
  hotel_name      = EXCLUDED.hotel_name,
  location        = EXCLUDED.location,
  star_rating     = EXCLUDED.star_rating,
  check_in_time   = EXCLUDED.check_in_time,
  check_out_time  = EXCLUDED.check_out_time,
  notes           = EXCLUDED.notes,
  updated_at      = NOW();

-- ============================================================================
-- 2. hotel_price INSERT
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ─────────────── 슈페리어 시티뷰 ───────────────
(
  'L7_WESTLAKE_HANOI_SUPERIOR_CITY',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'SUPERIOR_CITY', '슈페리어 시티뷰',
  'STANDARD', 2, TRUE,
  3450000, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '38~40m² (발코니 포함). 더블베드 또는 트윈베드. 시티뷰. 기준 성인2. 조식뷔페(21층) 포함. 봉사료+VAT 포함. 엑스트라베드 가능 여부 문의 필요.'
),

-- ─────────────── 슈페리어 레이크뷰 ───────────────
(
  'L7_WESTLAKE_HANOI_SUPERIOR_LAKE',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'SUPERIOR_LAKE', '슈페리어 레이크뷰',
  'STANDARD', 2, TRUE,
  4000000, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '38~40m² (발코니 포함). 더블베드 또는 트윈베드. 레이크뷰(서호 전망). 기준 성인2. 조식뷔페(21층) 포함. 봉사료+VAT 포함.'
),

-- ─────────────── 슈페리어 패밀리 트리플 ───────────────
(
  'L7_WESTLAKE_HANOI_SUPERIOR_FAMILY',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'SUPERIOR_FAMILY', '슈페리어 패밀리 트리플',
  'FAMILY', 3, TRUE,
  4850000, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '38~40m² (발코니 포함). 패밀리 트윈타입(더블+싱글). 레이크뷰 또는 시티뷰. 기준 성인3. 조식뷔페(21층) 포함. 봉사료+VAT 포함.'
),

-- ─────────────── 슈페리어 클럽 플로어 시티뷰 ───────────────
(
  'L7_WESTLAKE_HANOI_CLUB_CITY',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'CLUB_FLOOR_CITY', '슈페리어 클럽 플로어 시티뷰',
  'STANDARD', 2, TRUE,
  5350000, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '38~40m² (발코니 포함). 더블베드. 시티뷰. 클럽 플로어 혜택 포함. 기준 성인2. 조식뷔페(21층) 포함. 봉사료+VAT 포함.'
),

-- ─────────────── 슈페리어 클럽 플로어 레이크뷰 ───────────────
(
  'L7_WESTLAKE_HANOI_CLUB_LAKE',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'CLUB_FLOOR_LAKE', '슈페리어 클럽 플로어 레이크뷰',
  'STANDARD', 2, TRUE,
  5900000, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '38~40m² (발코니 포함). 더블베드. 레이크뷰(서호 전망). 클럽 플로어 혜택 포함. 기준 성인2. 조식뷔페(21층) 포함. 봉사료+VAT 포함.'
),

-- ─────────────── 스튜디오 스위트 레이크뷰 (개별문의) ───────────────
(
  'L7_WESTLAKE_HANOI_STUDIO_SUITE_LAKE',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'STUDIO_SUITE_LAKE', '스튜디오 스위트 레이크뷰',
  'SUITE', 2, TRUE,
  0, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '82m² (발코니 포함). 더블 또는 트윈베드. 레이크뷰(서호 전망). 클럽 혜택 포함. 기준 성인2. 조식뷔페(21층) 포함. 봉사료+VAT 포함. ⚠️ 요금 개별문의 필요 (base_price 업데이트 필요).'
),

-- ─────────────── 어퍼 하우스 레이크뷰 (개별문의) ───────────────
(
  'L7_WESTLAKE_HANOI_UPPER_HOUSE_LAKE',
  'L7_WESTLAKE_HANOI', 'L7 웨스트레이크 하노이',
  'UPPER_HOUSE_LAKE', '어퍼 하우스 레이크뷰',
  'SUITE', 2, TRUE,
  0, 0,
  '아동 요금 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '130m² (발코니 포함). 더블베드. 레이크뷰(서호 전망). 클럽 혜택 포함. 기준 성인2. 조식뷔페(21층) 포함. 봉사료+VAT 포함. ⚠️ 요금 개별문의 필요 (base_price 업데이트 필요).'
)

ON CONFLICT (hotel_price_code) DO UPDATE SET
  base_price         = EXCLUDED.base_price,
  extra_person_price = EXCLUDED.extra_person_price,
  child_policy       = EXCLUDED.child_policy,
  notes              = EXCLUDED.notes,
  updated_at         = NOW();

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'L7_WESTLAKE_HANOI';
--
-- SELECT hotel_price_code, room_name, base_price
-- FROM hotel_price
-- WHERE hotel_code = 'L7_WESTLAKE_HANOI'
-- ORDER BY base_price DESC, room_name;
-- 기대값: 7행
--
-- SELECT COUNT(*) FROM hotel_price WHERE hotel_code = 'L7_WESTLAKE_HANOI';

-- ============================================================================
-- ⚠️ 가격 업데이트 템플릿 (스튜디오 스위트·어퍼 하우스 개별문의 확정 후 사용)
-- ============================================================================
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'L7_WESTLAKE_HANOI_STUDIO_SUITE_LAKE';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'L7_WESTLAKE_HANOI_UPPER_HOUSE_LAKE';
