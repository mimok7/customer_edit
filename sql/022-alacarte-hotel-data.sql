-- ============================================================================
-- 알라카르트 하롱 호텔 (À LA CARTE HALONG BAY) 데이터
-- 하롱베이 5성급
-- ============================================================================
-- 실행 순서: 020-hotel-schema-rebuild.sql 이후 실행
-- ※ 가격(base_price)은 추후 업데이트 필요 (현재 0 처리)
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
  'ALACARTE',
  '알라카르트 하롱 호텔',
  'HOTEL',
  '하롱베이 스코어베이',
  5,
  '15:00:00',
  '12:00:00',
  NULL,
  'VND',
  '하롱베이 5성급 레지던스+호텔 통합 / 스코어베이 오션뷰 / 40층 루프탑 실외 수영장 + 실내 온수풀 / 가족단위 2베드룸 보유 / 커넥팅 객실 미제공 / 얼리체크인 AM09~PM15 요금50% 부과, AM09 이전 1박 전액 부과 / 레이트체크아웃 PM12:30~18:00 요금50% 부과, PM18 이후 1박 전액 부과',
  TRUE
)
ON CONFLICT (hotel_code) DO UPDATE SET
  hotel_name     = EXCLUDED.hotel_name,
  location       = EXCLUDED.location,
  star_rating    = EXCLUDED.star_rating,
  check_in_time  = EXCLUDED.check_in_time,
  check_out_time = EXCLUDED.check_out_time,
  notes          = EXCLUDED.notes,
  updated_at     = NOW();

-- ============================================================================
-- 2. hotel_price INSERT
-- hotel_price_code 형식: ALACARTE_{객실타입}
-- 시즌 구분 없음 (연중 동일 / 가격 업데이트 시 수정 필요)
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ─────────────────────────────────────────
-- 프리미어 베이 뷰 (40~54m², 54개, 트윈베드)
-- ─────────────────────────────────────────
(
  'ALACARTE_PREMIER_BAY_VIEW',
  'ALACARTE', '알라카르트 하롱 호텔',
  'PREMIER_BAY_VIEW', '프리미어 베이 뷰', 'STANDARD', 4, TRUE,
  0, 0,
  '기본인원 성인2+아동2(또는 성인3인) / 성인3인 숙박 시 1인 엑스트라 필수 / 아동정책 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 40~54m² / 54개 룸 / 트윈베드 / 기본생수, 헤어드라이어, 샤워타월, 가운, 욕실어메니티, 커피포트, 무료커피&차, 미니냉장고, 옷장, TV, 미니금고, 인덕션, 슬리퍼, 일부 발코니, 소파, 욕조 / ※ 커넥팅 객실 미제공 / ⚠️ 가격 업데이트 필요'
),

-- ─────────────────────────────────────────
-- 이그제큐티브 베이 뷰 (45~58m², 67개, 킹 또는 트윈)
-- ─────────────────────────────────────────
(
  'ALACARTE_EXECUTIVE_BAY_VIEW',
  'ALACARTE', '알라카르트 하롱 호텔',
  'EXECUTIVE_BAY_VIEW', '이그제큐티브 베이 뷰', 'STANDARD', 4, TRUE,
  0, 0,
  '기본인원 성인2+아동2(또는 성인3인) / 성인3인 숙박 시 1인 엑스트라 필수 / 아동정책 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 45~58m² / 67개 룸 / 킹베드 또는 트윈베드 선택 / 기본생수, 헤어드라이어, 샤워타월, 가운, 욕실어메니티, 커피포트, 무료커피&차, 미니냉장고, 옷장, TV, 미니금고, 인덕션, 슬리퍼, 일부 발코니, 소파, 욕조 / ※ 커넥팅 객실 미제공 / ⚠️ 가격 업데이트 필요'
),

-- ─────────────────────────────────────────
-- 스위트 베이 비스타 (69~76m², 51개, 킹+트윈 또는 킹2개)
-- ─────────────────────────────────────────
(
  'ALACARTE_SUITE_BAY_VISTA',
  'ALACARTE', '알라카르트 하롱 호텔',
  'SUITE_BAY_VISTA', '스위트 베이 비스타', 'SUITE', 4, TRUE,
  0, 0,
  '기본인원 최대 4인 / 엑스트라 불가',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 69~76m² / 51개 룸 / 킹베드+트윈베드 또는 킹베드2개 선택 / 기본생수, 헤어드라이어, 샤워타월, 가운, 욕실어메니티, 커피포트, 무료커피&차, 미니냉장고, 옷장, TV, 미니금고, 인덕션, 슬리퍼, 소파, 욕조 / ※ 엑스트라베드 불가 / ※ 커넥팅 객실 미제공 / ⚠️ 가격 업데이트 필요'
),

-- ─────────────────────────────────────────
-- 이그제큐티브 스위트 베이 비스타 (83m², 18개, 킹+트윈 또는 킹2개)
-- ─────────────────────────────────────────
(
  'ALACARTE_EXECUTIVE_SUITE_BAY_VISTA',
  'ALACARTE', '알라카르트 하롱 호텔',
  'EXECUTIVE_SUITE_BAY_VISTA', '이그제큐티브 스위트 베이 비스타', 'SUITE', 4, TRUE,
  0, 0,
  '기본인원 최대 4인 / 엑스트라 불가',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 83m² / 18개 룸 / 킹베드+트윈베드 또는 킹베드2개 선택 / 기본생수, 헤어드라이어, 샤워타월, 가운, 욕실어메니티, 커피포트, 무료커피&차, 미니냉장고, 옷장, TV, 미니금고, 인덕션, 슬리퍼, 소파, 욕조 / ※ 엑스트라베드 불가 / ※ 커넥팅 객실 미제공 / ⚠️ 가격 업데이트 필요'
)

ON CONFLICT (hotel_price_code) DO UPDATE SET
  base_price         = EXCLUDED.base_price,
  extra_person_price = EXCLUDED.extra_person_price,
  child_policy       = EXCLUDED.child_policy,
  notes              = EXCLUDED.notes,
  updated_at         = NOW();

COMMIT;

-- ============================================================================
-- 검증 쿼리 (필요 시 주석 해제 후 실행)
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'ALACARTE';
-- SELECT hotel_price_code, room_name, base_price, occupancy_max, child_policy
-- FROM hotel_price WHERE hotel_code = 'ALACARTE' ORDER BY base_price;
-- SELECT COUNT(*) FROM hotel_price WHERE hotel_code = 'ALACARTE'; -- 예상: 4

-- ============================================================================
-- 가격 업데이트 시 사용할 쿼리 템플릿
-- ============================================================================
-- UPDATE hotel_price SET base_price = 0000000, extra_person_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'ALACARTE_PREMIER_BAY_VIEW';
--
-- UPDATE hotel_price SET base_price = 0000000, extra_person_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'ALACARTE_EXECUTIVE_BAY_VIEW';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'ALACARTE_SUITE_BAY_VISTA';
--
-- UPDATE hotel_price SET base_price = 0000000, updated_at = NOW()
-- WHERE hotel_price_code = 'ALACARTE_EXECUTIVE_SUITE_BAY_VISTA';
