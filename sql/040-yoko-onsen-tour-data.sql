-- ============================================================================
-- 요코온센 리조트 공용온천 당일 이용권 - 투어 테이블 데이터
-- ============================================================================
-- 실행 전: 011-tour-system-tables-2026.sql, 020-tour-schema-extensions.sql 완료 필수
-- 프로그램: 공용온천 3개 시간대 (모닝/에프터눈/나이트)
-- 특징: 1인당 당일권, 평일/주말 구분 가격, 비크루즈 티켓 상품

BEGIN;

-- ============================================================================
-- 1. 투어 기본 정보 INSERT (3개 프로그램별)
-- ============================================================================

INSERT INTO tour (
  tour_code, tour_name, category, description, overview,
  duration, guide_language, group_type, location, starting_point, meeting_time,
  image_url, rating, is_active, status,
  contact_info, payment_notes, cancellation_policy_url,
  program_type, is_cruise_addon
) VALUES
(
  'YOKO_ONSEN_MORNING_PASS_001',
  '요코온센 공용온천 모닝 당일권 (09:00~13:00)',
  '지역',
  '하롱베이 온천 휴양 리조트 - 공용온천 모닝 프로그램. 뷔페식 점심 식사 포함, 온천·샤워실·탈의실·스파 이용 가능.',
  '요코온센 리조트의 공용온천 모닝 프로그램. 09:00~13:00 (4시간) 동안 따뜻한 온천과 베트남식 뷔페 식사를 즐길 수 있습니다. 솔레일 호텔 앞 썬월드 입구에서 무료 셔틀버스 운행.',
  '당일 (09:00-13:00, 약 4시간)',
  ARRAY['한국어','영어'],
  'group',
  'Tổ 5, khu 9B, Cẩm Phả, Quảng Ninh, 베트남',
  '솔레일 호텔 앞 썬월드 입구 (무료 셔틀버스)',
  '09:00',
  'https://stayhalong.com/images/tours/yoko-onsen-morning.jpg',
  4.7,
  true,
  'active',
  '{"kakao": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84) 0334334065", "phone_kr": "070-4554-5185"}',
  '1인당 요금. 평일 1,400,000동 / 주말 1,850,000동 | 카카오톡 바우처 발송 (2~3일 소요)',
  'https://stayhalong.com/cancellation-policy',
  'half_day',
  false
),
(
  'YOKO_ONSEN_AFTERNOON_PASS_001',
  '요코온센 공용온천 에프터눈 당일권 (14:00~21:00)',
  '지역',
  '하롱베이 온천 휴양 리조트 - 공용온천 에프터눈 프로그램. 뷔페식 저녁 식사 포함, 온천·샤워실·탈의실·스파 이용 가능.',
  '요코온센 리조트의 공용온천 에프터눈 프로그램. 14:00~21:00 (7시간) 동안 느긋하고 여유로운 온천 휴양을 즐길 수 있습니다. 뷔페식 저녁 식사 포함. 솔레일 호텔 앞 썬월드 입구에서 무료 셔틀버스 운행.',
  '당일 (14:00-21:00, 약 7시간)',
  ARRAY['한국어','영어'],
  'group',
  'Tổ 5, khu 9B, Cẩm Phả, Quảng Ninh, 베트남',
  '솔레일 호텔 앞 썬월드 입구 (무료 셔틀버스)',
  '14:00',
  'https://stayhalong.com/images/tours/yoko-onsen-afternoon.jpg',
  4.7,
  true,
  'active',
  '{"kakao": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84) 0334334065", "phone_kr": "070-4554-5185"}',
  '1인당 요금. 평일 1,300,000동 / 주말 1,700,000동 | 카카오톡 바우처 발송 (2~3일 소요)',
  'https://stayhalong.com/cancellation-policy',
  'half_day',
  false
),
(
  'YOKO_ONSEN_NIGHT_PASS_001',
  '요코온센 공용온천 나이트 당일권 (18:00~21:00)',
  '지역',
  '하롱베이 온천 휴양 리조트 - 공용온천 나이트 프로그램. 식사 불포함, 온천·샤워실·탈의실·스파 이용 가능.',
  '요코온센 리조트의 공용온천 나이트 프로그램. 18:00~21:00 (3시간) 동안 야경을 감상하며 온천을 즐길 수 있습니다. 평일·주말 동일한 가격. 솔레일 호텔 앞 썬월드 입구에서 무료 셔틀버스 운행.',
  '당일 (18:00-21:00, 약 3시간)',
  ARRAY['한국어','영어'],
  'group',
  'Tổ 5, khu 9B, Cẩm Phả, Quảng Ninh, 베트남',
  '솔레일 호텔 앞 썬월드 입구 (무료 셔틀버스)',
  '18:00',
  'https://stayhalong.com/images/tours/yoko-onsen-night.jpg',
  4.7,
  true,
  'active',
  '{"kakao": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84) 0334334065", "phone_kr": "070-4554-5185"}',
  '1인당 요금. 평일·주말 동일 550,000동 | 카카오톡 바우처 발송 (2~3일 소요)',
  'https://stayhalong.com/cancellation-policy',
  'evening',
  false
);

-- ============================================================================
-- 2. 모닝 온센 가격 정보 INSERT
-- ============================================================================

INSERT INTO tour_pricing (
  tour_id, min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, deposit_rate,
  deposit_payment_method, balance_payment_method, balance_currency,
  season_key, valid_from, valid_until, default_payment_method
) VALUES
-- 모닝 온센 - 평일
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 1, 1, 1400000, '셔틀버스', 500000, 0.36, 'card', 'cash', 'VND', 'PEAK', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 2, 4, 1400000, '셔틀버스', 500000, 0.36, 'card', 'cash', 'VND', 'PEAK', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 5, 8, 1400000, '셔틀버스', 450000, 0.33, 'card', 'cash', 'VND', 'PEAK', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
-- 모닝 온센 - 주말
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 1, 1, 1850000, '셔틀버스', 650000, 0.35, 'card', 'cash', 'VND', 'OFF_SEASON', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 2, 4, 1850000, '셔틀버스', 650000, 0.35, 'card', 'cash', 'VND', 'OFF_SEASON', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 5, 8, 1850000, '셔틀버스', 600000, 0.33, 'card', 'cash', 'VND', 'OFF_SEASON', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),

-- ============================================================================
-- 3. 에프터눈 온센 가격 정보 INSERT
-- ============================================================================
-- 에프터눈 온센 - 평일
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 1, 1, 1300000, '셔틀버스', 450000, 0.35, 'card', 'cash', 'VND', 'PEAK', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 2, 4, 1300000, '셔틀버스', 450000, 0.35, 'card', 'cash', 'VND', 'PEAK', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 5, 8, 1300000, '셔틀버스', 400000, 0.31, 'card', 'cash', 'VND', 'PEAK', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
-- 에프터눈 온센 - 주말
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 1, 1, 1700000, '셔틀버스', 600000, 0.35, 'card', 'cash', 'VND', 'OFF_SEASON', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 2, 4, 1700000, '셔틀버스', 600000, 0.35, 'card', 'cash', 'VND', 'OFF_SEASON', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 5, 8, 1700000, '셔틀버스', 550000, 0.33, 'card', 'cash', 'VND', 'OFF_SEASON', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),

-- ============================================================================
-- 4. 나이트 온센 가격 정보 INSERT
-- ============================================================================
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 1, 1, 550000, '셔틀버스', 200000, 0.36, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 2, 4, 550000, '셔틀버스', 200000, 0.36, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 5, 8, 550000, '셔틀버스', 180000, 0.33, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card');

-- ============================================================================
-- 5. 포함사항 INSERT
-- ============================================================================

INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
-- 모닝 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 1, '솔레일 호텔 앞 썬월드 입구 왕복 무료 셔틀버스', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 2, '공용온천(남녀 분리) 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 3, '개별 프라이빗 샤워실 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 4, '남녀 탈의실 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 5, '스파 서비스', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 6, 'SET 뷔페식 점심 식사', 'meal', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 7, '음료 (물, 차, 커피)', 'meal', '✓'),

-- 에프터눈 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 1, '솔레일 호텔 앞 썬월드 입구 왕복 무료 셔틀버스', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 2, '공용온천(남녀 분리) 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 3, '개별 프라이빗 샤워실 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 4, '남녀 탈의실 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 5, '스파 서비스', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 6, 'SET 뷔페식 저녁 식사', 'meal', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 7, '음료 (물, 차, 커피)', 'meal', '✓'),

-- 나이트 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 1, '솔레일 호텔 앞 썬월드 입구 왕복 무료 셔틀버스', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 2, '공용온천(남녀 분리) 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 3, '개별 프라이빗 샤워실 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 4, '남녀 탈의실 이용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 5, '스파 서비스', 'activity', '✓');

-- ============================================================================
-- 6. 불포함사항 INSERT
-- ============================================================================

INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
-- 모닝 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 1, '추가 음식/음료 구매', 'meal', 0),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 2, '스파 추가 서비스 (마사지 등)', 'service', 0),

-- 에프터눈 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 1, '추가 음식/음료 구매', 'meal', 0),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 2, '스파 추가 서비스 (마사지 등)', 'service', 0),

-- 나이트 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 1, '식사 (비포함)', 'meal', 0),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 2, '추가 음식/음료 구매', 'meal', 0);

-- ============================================================================
-- 7. 중요 정보 INSERT
-- ============================================================================

INSERT INTO tour_important_info (tour_id, info_type, title, content, order_seq) VALUES
-- 모닝 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 'caution', '취소 불가 정책', '예약 후 어떠한 이유로든 취소 불가합니다.', 1),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 'guide', '바우처 발송', '예약 확정 후 2~3일 이내 모바일 바우처를 카카오톡으로 발송합니다.', 2),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 'guide', '셔틀버스 운행', '솔레일 호텔 앞 썬월드 입구에서 무료 셔틀버스 운행합니다.', 3),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_MORNING_PASS_001'), 'notice', '어린이 정책', '미취학 아동(만 6세 미만) 요금은 별도 문의하시기 바랍니다.', 4),

-- 에프터눈 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 'caution', '취소 불가 정책', '예약 후 어떠한 이유로든 취소 불가합니다.', 1),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 'guide', '바우처 발송', '예약 확정 후 2~3일 이내 모바일 바우처를 카카오톡으로 발송합니다.', 2),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 'guide', '셔틀버스 운행', '솔레일 호텔 앞 썬월드 입구에서 무료 셔틀버스 운행합니다.', 3),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_AFTERNOON_PASS_001'), 'notice', '어린이 정책', '미취학 아동(만 6세 미만) 요금은 별도 문의하시기 바랍니다.', 4),

-- 나이트 온센
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 'caution', '취소 불가 정책', '예약 후 어떠한 이유로든 취소 불가합니다.', 1),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 'guide', '바우처 발송', '예약 확정 후 2~3일 이내 모바일 바우처를 카카오톡으로 발송합니다.', 2),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 'guide', '셔틀버스 운행', '솔레일 호텔 앞 썬월드 입구에서 무료 셔틀버스 운행합니다.', 3),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 'notice', '어린이 정책', '미취학 아동(만 6세 미만) 요금은 별도 문의하시기 바랍니다.', 4),
((SELECT tour_id FROM tour WHERE tour_code = 'YOKO_ONSEN_NIGHT_PASS_001'), 'notice', '식사 미포함', '나이트 프로그램은 식사가 포함되지 않습니다. 현장 레스토랑에서 유료 식사 주문 가능합니다.', 5);

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT tour_code, tour_name, duration, is_cruise_addon
-- FROM tour
-- WHERE tour_code LIKE 'YOKO_ONSEN%'
-- ORDER BY tour_code;
-- 기대값: 3행 (모닝, 에프터눈, 나이트)
--
-- -- 가격 정보 확인
-- SELECT t.tour_code, t.tour_name, tp.season_key, tp.min_guests, tp.price_per_person
-- FROM tour t
-- JOIN tour_pricing tp ON t.tour_id = tp.tour_id
-- WHERE t.tour_code LIKE 'YOKO_ONSEN%'
-- ORDER BY t.tour_code, tp.season_key, tp.min_guests;
-- 기대값: 15행 (모닝6 + 에프터눈6 + 나이트3)
