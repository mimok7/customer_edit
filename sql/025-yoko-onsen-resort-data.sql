-- ============================================================================
-- 요코온센 리조트 (YOKO ONSEN RESORT - QUANG HANH) 데이터
-- 하롱베이 독채형 온천 풀빌라 리조트
-- ============================================================================
-- 실행 순서: 020-hotel-schema-rebuild.sql 이후 실행
-- ※ 시즌 구분: 하이시즌(05/17~08/30) / 로우시즌(그 외)
-- ※ 요일 구분: 평일(일~목) / 주말(금·토)
-- ※ 뷔페티켓: 별도 1인당 650,000동
-- ※ 4세 이상은 성인 요금 적용
-- ※ 야마 그랜드 스위트 4베드 및 야마 온센 4베드 로얄: 2026년 가격 업데이트 필요
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
  'YOKO_ONSEN',
  '요코온센 리조트',
  'RESORT_ONSEN',
  '하롱베이 꽝한',
  5,
  '14:00:00',
  '12:00:00',
  NULL,
  'VND',
  '온천 독채 빌라 리조트 / 빌라별 단독 온천탕 / 주방+거실+식사공간 제공 / 2베드(성인4인+4세이하2명) / 3베드(성인6인+4세이하3명) / 4베드(성인8인+4세이하4명) / 4세 이상 성인 요금 적용 / 뷔페티켓 1인당 650,000동 별도 / 요코온센 4베드 로얄은 사전 신청 후 호텔 승인 필요',
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
-- hotel_price_code 형식: YOKO_ONSEN_{빌라타입}_{시즌}_{요일}
-- 시즌: HIGH(05/17~08/30) / LOW(그 외)
-- 요일: WEEKDAY(일~목) / WEEKEND(금·토)
-- 금액: 빌라 1동 기준 (조식 미포함 / 뷔페티켓 별도)
-- ============================================================================

INSERT INTO hotel_price (
  hotel_price_code, hotel_code, hotel_name,
  room_type, room_name, room_category, occupancy_max, include_breakfast,
  base_price, extra_person_price, child_policy,
  season_name, start_date, end_date, weekday_type, notes
) VALUES

-- ════════════════════════════════════════════════════════════════════
-- 야마 온센 2베드 빌라 (YAMA ONSEN 2BED)
-- 기준인원: 성인 4인 + 4세 이하 아동 2명
-- ════════════════════════════════════════════════════════════════════

-- 하이시즌 평일
(
  'YOKO_ONSEN_YAMA_2BED_HIGH_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_2BED', '야마 온센 2베드 빌라', 'VILLA_POOL', 6, FALSE,
  10400000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 2명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 평일', '2026-05-17', '2026-08-30', 'WEEKDAY',
  '빌라 1동 기준 / 마당+단독온천탕+주방+거실+식사공간 / 객실 2개(더블+트윈) 사용(나머지 1개는 잠김) / 공용화장실+마스터룸+서브룸 화장실 / 하이시즌: 05/17~08/30'
),
-- 하이시즌 주말(금·토)
(
  'YOKO_ONSEN_YAMA_2BED_HIGH_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_2BED', '야마 온센 2베드 빌라', 'VILLA_POOL', 6, FALSE,
  11600000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 2명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 주말', '2026-05-17', '2026-08-30', 'WEEKEND',
  '빌라 1동 기준 / 마당+단독온천탕+주방+거실+식사공간 / 객실 2개 사용 / 하이시즌 금·토 요금'
),
-- 로우시즌 평일
(
  'YOKO_ONSEN_YAMA_2BED_LOW_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_2BED', '야마 온센 2베드 빌라', 'VILLA_POOL', 6, FALSE,
  9100000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 2명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 평일', '2026-09-04', '2026-12-30', 'WEEKDAY',
  '빌라 1동 기준 / 마당+단독온천탕+주방+거실+식사공간 / 객실 2개 사용 / 로우시즌: 09/04~12/30 및 01/01~05/16'
),
-- 로우시즌 주말(금·토)
(
  'YOKO_ONSEN_YAMA_2BED_LOW_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_2BED', '야마 온센 2베드 빌라', 'VILLA_POOL', 6, FALSE,
  10400000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 2명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 주말', '2026-09-04', '2026-12-30', 'WEEKEND',
  '빌라 1동 기준 / 마당+단독온천탕+주방+거실+식사공간 / 객실 2개 사용 / 로우시즌 금·토 요금'
),

-- ════════════════════════════════════════════════════════════════════
-- 야마 온센 3베드 빌라 (YAMA ONSEN 3BED)
-- 기준인원: 성인 6인 + 4세 이하 아동 3명
-- ════════════════════════════════════════════════════════════════════

-- 하이시즌 평일
(
  'YOKO_ONSEN_YAMA_3BED_HIGH_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_3BED', '야마 온센 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  12600000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 평일', '2026-05-17', '2026-08-30', 'WEEKDAY',
  '빌라 1동 기준 / 마당+단독온천탕+주방+거실+식사공간 / 객실 3개 전체 사용 / 공용화장실+마스터룸+서브룸 화장실 / 하이시즌: 05/17~08/30'
),
-- 하이시즌 주말
(
  'YOKO_ONSEN_YAMA_3BED_HIGH_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_3BED', '야마 온센 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  14100000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 주말', '2026-05-17', '2026-08-30', 'WEEKEND',
  '빌라 1동 기준 / 객실 3개 전체 사용 / 하이시즌 금·토 요금'
),
-- 로우시즌 평일
(
  'YOKO_ONSEN_YAMA_3BED_LOW_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_3BED', '야마 온센 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  11100000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 평일', '2026-09-04', '2026-12-30', 'WEEKDAY',
  '빌라 1동 기준 / 객실 3개 전체 사용 / 로우시즌: 09/04~12/30 및 01/01~05/16'
),
-- 로우시즌 주말
(
  'YOKO_ONSEN_YAMA_3BED_LOW_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'YAMA_3BED', '야마 온센 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  12600000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 주말', '2026-09-04', '2026-12-30', 'WEEKEND',
  '빌라 1동 기준 / 객실 3개 전체 사용 / 로우시즌 금·토 요금'
),

-- ════════════════════════════════════════════════════════════════════
-- 야마 프리미엄 3베드 빌라 (YAMA PREMIUM 3BED)
-- 기준인원: 성인 6인 + 4세 이하 아동 3명 / YAMA ONSEN 3BED보다 넓은 거실
-- ════════════════════════════════════════════════════════════════════

-- 하이시즌 평일
(
  'YOKO_ONSEN_PREMIUM_3BED_HIGH_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'PREMIUM_3BED', '야마 프리미엄 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  15600000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 평일', '2026-05-17', '2026-08-30', 'WEEKDAY',
  '빌라 1동 기준 / 야마 온센 3베드보다 넓은 거실 / 마당+단독온천탕+주방+거실+식사공간 / 객실 3개 전체 사용 / 하이시즌: 05/17~08/30'
),
-- 하이시즌 주말
(
  'YOKO_ONSEN_PREMIUM_3BED_HIGH_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'PREMIUM_3BED', '야마 프리미엄 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  17500000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 주말', '2026-05-17', '2026-08-30', 'WEEKEND',
  '빌라 1동 기준 / 넓은 거실 / 객실 3개 전체 사용 / 하이시즌 금·토 요금'
),
-- 로우시즌 평일
(
  'YOKO_ONSEN_PREMIUM_3BED_LOW_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'PREMIUM_3BED', '야마 프리미엄 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  13700000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 평일', '2026-09-04', '2026-12-30', 'WEEKDAY',
  '빌라 1동 기준 / 넓은 거실 / 객실 3개 전체 사용 / 로우시즌: 09/04~12/30 및 01/01~05/16'
),
-- 로우시즌 주말
(
  'YOKO_ONSEN_PREMIUM_3BED_LOW_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'PREMIUM_3BED', '야마 프리미엄 3베드 빌라', 'VILLA_POOL', 9, FALSE,
  15600000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 3명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 주말', '2026-09-04', '2026-12-30', 'WEEKEND',
  '빌라 1동 기준 / 넓은 거실 / 객실 3개 전체 사용 / 로우시즌 금·토 요금'
),

-- ════════════════════════════════════════════════════════════════════
-- 야마 그랜드 스위트 4베드 빌라 (YAMA GRAND SUITE 4BED)
-- 기준인원: 성인 8인 + 4세 이하 아동 4명 / 고급형
-- ⚠️ 2026년 가격 업데이트 필요 (아래는 2024년 기준 가격)
-- ════════════════════════════════════════════════════════════════════

-- 하이시즌 평일
(
  'YOKO_ONSEN_GRAND_4BED_HIGH_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'GRAND_4BED', '야마 그랜드 스위트 4베드 빌라', 'VILLA_POOL', 12, FALSE,
  91000000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 4명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 평일', '2026-05-17', '2026-08-30', 'WEEKDAY',
  '빌라 1동 기준 / 고급형 빌라 / 마당+단독온천탕+주방+거실+식사공간 / 객실 4개 전체 사용 / ⚠️ 2026년 가격 업데이트 필요 (현재 2024 기준 91,000,000동)'
),
-- 하이시즌 주말
(
  'YOKO_ONSEN_GRAND_4BED_HIGH_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'GRAND_4BED', '야마 그랜드 스위트 4베드 빌라', 'VILLA_POOL', 12, FALSE,
  102300000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 4명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '하이시즌 주말', '2026-05-17', '2026-08-30', 'WEEKEND',
  '빌라 1동 기준 / 고급형 / 객실 4개 전체 사용 / ⚠️ 2026년 가격 업데이트 필요'
),
-- 로우시즌 평일
(
  'YOKO_ONSEN_GRAND_4BED_LOW_WEEKDAY',
  'YOKO_ONSEN', '요코온센 리조트',
  'GRAND_4BED', '야마 그랜드 스위트 4베드 빌라', 'VILLA_POOL', 12, FALSE,
  79800000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 4명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 평일', '2026-09-04', '2026-12-30', 'WEEKDAY',
  '빌라 1동 기준 / 고급형 / 객실 4개 전체 사용 / ⚠️ 2026년 가격 업데이트 필요'
),
-- 로우시즌 주말
(
  'YOKO_ONSEN_GRAND_4BED_LOW_WEEKEND',
  'YOKO_ONSEN', '요코온센 리조트',
  'GRAND_4BED', '야마 그랜드 스위트 4베드 빌라', 'VILLA_POOL', 12, FALSE,
  91000000, 0,
  '4세 이상 성인 요금 적용 / 4세 이하 아동 최대 4명 포함 / 뷔페티켓 1인당 650,000동 별도',
  '로우시즌 주말', '2026-09-04', '2026-12-30', 'WEEKEND',
  '빌라 1동 기준 / 고급형 / 객실 4개 전체 사용 / ⚠️ 2026년 가격 업데이트 필요'
),

-- ════════════════════════════════════════════════════════════════════
-- 야마 온센 4베드 로얄 빌라 (YAMA ONSEN 4BED ROYAL)
-- 최고급 VIP 전용 / 사전 신청 후 호텔 승인 필요 / 가격 업데이트 준비중
-- ════════════════════════════════════════════════════════════════════
(
  'YOKO_ONSEN_ROYAL_4BED',
  'YOKO_ONSEN', '요코온센 리조트',
  'ROYAL_4BED', '야마 온센 4베드 로얄 빌라', 'VILLA_POOL', 12, FALSE,
  0, 0,
  '4세 이상 성인 요금 적용 / 뷔페티켓 1인당 650,000동 별도',
  '연중', '2026-01-01', '2026-12-31', 'ALL',
  '빌라 1동 기준 / 최고급 VIP 전용 / 사전 신청 후 호텔 측 승인 필요 / 1박 1천만원 이상 / ⚠️ 가격 업데이트 준비중 (별도 문의)'
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
-- SELECT * FROM hotel_info WHERE hotel_code = 'YOKO_ONSEN';
-- SELECT hotel_price_code, room_name, season_name, weekday_type, base_price
-- FROM hotel_price WHERE hotel_code = 'YOKO_ONSEN'
-- ORDER BY room_type, season_name, weekday_type;
-- SELECT COUNT(*) FROM hotel_price WHERE hotel_code = 'YOKO_ONSEN'; -- 예상: 17

-- ============================================================================
-- 2026년 가격 업데이트 템플릿 (그랜드 4베드 및 로얄)
-- ============================================================================
-- UPDATE hotel_price SET base_price = 00000000, updated_at = NOW()
-- WHERE hotel_price_code = 'YOKO_ONSEN_GRAND_4BED_HIGH_WEEKDAY';
--
-- UPDATE hotel_price SET base_price = 00000000, updated_at = NOW()
-- WHERE hotel_price_code = 'YOKO_ONSEN_GRAND_4BED_HIGH_WEEKEND';
--
-- UPDATE hotel_price SET base_price = 00000000, updated_at = NOW()
-- WHERE hotel_price_code = 'YOKO_ONSEN_GRAND_4BED_LOW_WEEKDAY';
--
-- UPDATE hotel_price SET base_price = 00000000, updated_at = NOW()
-- WHERE hotel_price_code = 'YOKO_ONSEN_GRAND_4BED_LOW_WEEKEND';
--
-- UPDATE hotel_price SET base_price = 00000000, updated_at = NOW()
-- WHERE hotel_price_code = 'YOKO_ONSEN_ROYAL_4BED';
