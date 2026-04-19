-- ============================================================================
-- 윈덤 가든 레전드 하롱 호텔 (WYNDHAM GARDEN LEGEND HALONG) 데이터
-- 하롱베이 5성급 가성비 호텔 / 하롱 국제 크루즈 선착장 도보 5분
-- ============================================================================
-- 실행 순서: 020-hotel-schema-rebuild.sql 이후 실행
-- ※ 아동(6세 이상) 요금: 업데이트 준비중 (현재 0 처리)
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
  'WYNDHAM_LEGEND',
  '윈덤 가든 레전드 하롱 호텔',
  'HOTEL',
  '하롱베이 국제크루즈 선착장 인근',
  5,
  '14:00:00',
  '12:00:00',
  NULL,
  'VND',
  '2024년 8월 오픈 / 하롱 국제 크루즈 선착장 도보 5분 거리 (엠바사더, 사퀼라, 아이리스, 씨옥토퍼스 등) / 선착장 야경 조망 / 체크인15일전까지 취소가능 수수료없음, 숙박일변경 20일전까지 / 결제방법: 원화송금(신용카드 3.1% 수수료) / 조식포함: The Greenery Restaurant 06:00~10:00, 웰컴드링크, 수영장&피트니스 무료, 무료와이파이, 생수2병/일, 무료커피&차/일',
  TRUE
)
ON CONFLICT (hotel_code) DO UPDATE SET
  hotel_name     = EXCLUDED.hotel_name,
  location       = EXCLUDED.location,
  star_rating    = EXCLUDED.star_rating,
  notes          = EXCLUDED.notes,
  updated_at     = NOW();

-- ============================================================================
-- 2. hotel_price INSERT
-- hotel_price_code 형식: WYNDHAM_LEGEND_{객실타입}
-- 시즌 구분 없음 (연중 동일 가격)
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ─────────────────────────────────────────
-- 슈페리어 가든 더블 (33m², 힐뷰, 12개, 엑스트라 불가)
-- ─────────────────────────────────────────
(
  'WYNDHAM_LEGEND_SUPERIOR_GARDEN_DOUBLE',
  'WYNDHAM_LEGEND', '윈덤 가든 레전드 하롱 호텔',
  'SUPERIOR_GARDEN_DOUBLE', '슈페리어 가든 더블', 'STANDARD', 2, TRUE,
  1400000, 0,
  '6세 이상 아동 요금 업데이트 준비중 / 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 33m² / 12개 룸 / 힐뷰(시티뷰) / 더블베드 / 무료와이파이, HDTV 위성방송, 미니냉장고, 무료음료, 커피포트, 개별냉난방, 샤워&욕조, 가운&슬리퍼, 도어락 / ※ 엑스트라베드 불가'
),

-- ─────────────────────────────────────────
-- 슈페리어 가든 트윈 (33m², 힐뷰, 35개, 엑스트라 불가)
-- ─────────────────────────────────────────
(
  'WYNDHAM_LEGEND_SUPERIOR_GARDEN_TWIN',
  'WYNDHAM_LEGEND', '윈덤 가든 레전드 하롱 호텔',
  'SUPERIOR_GARDEN_TWIN', '슈페리어 가든 트윈', 'STANDARD', 2, TRUE,
  1400000, 0,
  '6세 이상 아동 요금 업데이트 준비중 / 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 33m² / 35개 룸 / 힐뷰(시티뷰) / 트윈베드 / 무료와이파이, HDTV 위성방송, 미니냉장고, 무료음료, 커피포트, 개별냉난방, 샤워&욕조, 가운&슬리퍼, 도어락 / ※ 엑스트라베드 불가'
),

-- ─────────────────────────────────────────
-- 슈페리어 가든 트리플 (33m², 힐뷰, 13개, 기준 3인, 엑스트라 불가)
-- ─────────────────────────────────────────
(
  'WYNDHAM_LEGEND_SUPERIOR_GARDEN_TRIPLE',
  'WYNDHAM_LEGEND', '윈덤 가든 레전드 하롱 호텔',
  'SUPERIOR_GARDEN_TRIPLE', '슈페리어 가든 트리플', 'STANDARD', 3, TRUE,
  2000000, 0,
  '6세 이상 아동 요금 업데이트 준비중 / 별도 문의',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 33m² / 13개 룸 / 힐뷰(시티뷰) / 트리플 기준 3인 / 무료와이파이, HDTV 위성방송, 미니냉장고, 무료음료, 커피포트, 개별냉난방, 샤워&욕조, 가운&슬리퍼, 도어락 / ※ 엑스트라베드 불가'
),

-- ─────────────────────────────────────────
-- 디럭스 오션 더블 (34m², 오션뷰, 23개, 엑스트라 800,000동)
-- ─────────────────────────────────────────
(
  'WYNDHAM_LEGEND_DELUXE_OCEAN_DOUBLE',
  'WYNDHAM_LEGEND', '윈덤 가든 레전드 하롱 호텔',
  'DELUXE_OCEAN_DOUBLE', '디럭스 오션 더블', 'STANDARD', 3, TRUE,
  1700000, 800000,
  '6세 이상 아동 요금 업데이트 준비중 / 별도 문의 / 엑스트라베드 800,000동(조식포함)',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 34m² / 23개 룸 / 오션뷰 / 더블베드 / 무료와이파이, HDTV 위성방송, 미니냉장고, 무료음료, 커피포트, 개별냉난방, 샤워&욕조, 가운&슬리퍼, 도어락 / 엑스트라베드 800,000동'
),

-- ─────────────────────────────────────────
-- 디럭스 오션 트윈 (34m², 오션뷰, 76개, 엑스트라 800,000동)
-- ─────────────────────────────────────────
(
  'WYNDHAM_LEGEND_DELUXE_OCEAN_TWIN',
  'WYNDHAM_LEGEND', '윈덤 가든 레전드 하롱 호텔',
  'DELUXE_OCEAN_TWIN', '디럭스 오션 트윈', 'STANDARD', 3, TRUE,
  1700000, 800000,
  '6세 이상 아동 요금 업데이트 준비중 / 별도 문의 / 엑스트라베드 800,000동(조식포함)',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 34m² / 76개 룸 / 오션뷰 / 트윈베드 / 무료와이파이, HDTV 위성방송, 미니냉장고, 무료음료, 커피포트, 개별냉난방, 샤워&욕조, 가운&슬리퍼, 도어락 / 엑스트라베드 800,000동'
),

-- ─────────────────────────────────────────
-- 프리미어 스위트 (71m², 오션뷰, 3개, 엑스트라 800,000동)
-- ─────────────────────────────────────────
(
  'WYNDHAM_LEGEND_PREMIER_SUITE',
  'WYNDHAM_LEGEND', '윈덤 가든 레전드 하롱 호텔',
  'PREMIER_SUITE', '프리미어 스위트', 'SUITE', 3, TRUE,
  4500000, 800000,
  '6세 이상 아동 요금 업데이트 준비중 / 별도 문의 / 엑스트라베드 800,000동(조식포함)',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '객실면적 71m² / 3개 룸 / 오션뷰 / 더블베드 / 무료와이파이, HDTV 위성방송, 미니냉장고, 무료음료, 커피포트, 개별냉난방, 샤워&욕조, 가운&슬리퍼, 도어락 / 엑스트라베드 800,000동'
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
-- SELECT * FROM hotel_info WHERE hotel_code = 'WYNDHAM_LEGEND';
-- SELECT hotel_price_code, room_name, base_price, extra_person_price, occupancy_max
-- FROM hotel_price WHERE hotel_code = 'WYNDHAM_LEGEND' ORDER BY base_price;
-- SELECT COUNT(*) FROM hotel_price WHERE hotel_code = 'WYNDHAM_LEGEND'; -- 예상: 6

-- ============================================================================
-- 아동 요금 업데이트 시 사용할 쿼리 템플릿
-- ============================================================================
-- UPDATE hotel_price SET child_policy = '아동 요금 내용', updated_at = NOW()
-- WHERE hotel_code = 'WYNDHAM_LEGEND';
