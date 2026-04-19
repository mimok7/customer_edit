-- ============================================================================
-- 드래곤펄 동굴 저녁 투어 데이터 (크루즈 고객용)
-- ============================================================================
-- 실행 전: 011-tour-system-tables-2026.sql, 020-tour-schema-extensions.sql 완료 필수
-- 프로그램: 저녁 프로그램 (16:30-21:10, 약 4.5시간)
-- 특징: 카드/와이어 결제방식별 가격 구분, 크루즈 통합 상품, 일몰/야경 관광

BEGIN;

-- ============================================================================
-- 1. 투어 기본 정보 INSERT
-- ============================================================================

INSERT INTO tour (
  tour_code, tour_name, category, description, overview,
  duration, guide_language, group_type, location, starting_point, meeting_time,
  image_url, rating, is_active,
  contact_info, payment_notes, cancellation_policy_url,
  program_type, is_cruise_addon
) VALUES (
  'HANOI_DRAGONPEARL_EVENING_001',
  '드래곤펄 동굴 저녁 투어 (크루즈 고객용)',
  '하롱베이',
  '하롱베이 크루즈 고객을 위한 드래곤펄 카이 저녁 일일투어. 신비로운 동굴 탐험, 베트남식 해산물 저녁식사(랍스터 또는 생선 선택), 하롱베이 일몰 및 야경을 즐기는 프리미엄 투어.',
  '하롱베이의 하이라이트 명소 드래곤펄 카이(Dragon Pearl Kai)에서 진행되는 저녁 프로그램. 크루즈 선착장에서 정시 출발하여 신비로운 동굴 탐험, 베트남 최고급 해산물 저녁식사(랍스터완전구성 또는 생선요리), 수상마을 방문, 하롱베이 일몰과 야경을 포함한 알찬 4.5시간 투어.',
  '당일 (16:30-21:10, 약 4.5시간)',
  ARRAY['한국어', '영어'],
  'group',
  '하롱베이',
  '크루즈 선착장 또는 지정 출발지',
  '16:30',
  'https://stayhalong.com/images/tours/dragon-pearl-evening.jpg',
  4.9,
  true,
  '{"kakao": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84)039 433 4065", "phone_kr": "070-4554-5185"}',
  '기본가격: 신용카드 1,350,000동 | 국제송금(Wire): 1,300,000동 (-5만동 할인) | 현장결제: 베트남동 현금만 가능',
  'https://stayhalong.com/cancellation-policy',
  'evening',
  true
);

-- ============================================================================
-- 2. 기본 인원별 가격 정보 INSERT
-- ============================================================================

INSERT INTO tour_pricing (
  tour_id, min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, deposit_rate,
  deposit_payment_method, balance_payment_method, balance_currency,
  season_key, valid_from, valid_until, default_payment_method
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 4, 1350000, '보트', 450000, 0.33, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 5, 8, 1300000, '보트', 430000, 0.33, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 9, 12, 1250000, '보트', 410000, 0.33, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE, 'card');

-- ============================================================================
-- 3. 결제방식별 가격 정보 INSERT (카드 vs 국제송금)
-- ============================================================================

INSERT INTO tour_payment_pricing (
  tour_id, payment_method, price, price_adjustment, currency, notes, is_active,
  valid_from, valid_until
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'card', 1350000, NULL, 'VND', '신용카드 결제 (기본가격)', true, '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'wire', 1300000, -50000, 'VND', '해외 국제송금(Wire Transfer) - 5만동 할인', true, '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'cash', 1350000, NULL, 'VND', '현장 현금결제 (기본가격)', true, '2026-01-01'::DATE, '2026-12-31'::DATE);

-- ============================================================================
-- 4. 크루즈 통합 설정 INSERT
-- ============================================================================

INSERT INTO tour_cruise_integration (
  tour_id, is_cruise_compatible, cruise_addon_type, requires_cruise_booking,
  cruise_linking_note, cruise_contact_info, is_active
) VALUES (
  (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'),
  true,
  'main_cruise_addon',
  false,
  '크루즈 선착장에서 16:30 정시 출발. 크루즈 투숙객 전용 또는 일반 고객 신청 가능. 크루즈 투어데스크에 사전 등록 필수. 일몰 및 야경 프로그램으로 가장 인기 높음.',
  '{"contact": "tour.desk@cruise.vn", "phone": "(+84) 123 456 789", "booking_requirement": "24시간 전 사전 등록 필수", "special_note": "일몰/야경 프로그램 - 성수기 선착순 마감"}',
  true
);

-- ============================================================================
-- 5. 포함사항 INSERT
-- ============================================================================

INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, '크루즈 선착장에서 드래곤펄 카이까지 왕복 보트 이동', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 2, '외국인 자격 한국어/영어 능숙 가이드', 'guide', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 3, '드래곤펄 카이 동굴 입장료', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 4, '베트남 전통 저녁식사 (랍스터 또는 생선 선택)', 'meal', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 5, '각종 음료 (물, 차, 커피)', 'meal', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 6, '수상마을(Floating Village) 투어 및 야경감상', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 7, '하롱베이 일몰 및 야경 감상', 'activity', '✓');

-- ============================================================================
-- 6. 불포함사항 INSERT
-- ============================================================================

INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, '호텔/공항으로부터 크루즈 선착장까지의 픽업 및 드롭 (별도 비용)', 'transportation', 400000),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 2, '가이드 팁 (의무 아님, 약 15-20만동 권장)', 'tip', 170000),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 3, '추가 주류 (맥주, 와인 등)', 'beverage', 50000),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 4, '현지 쇼핑 및 기념품 구매', 'shopping', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 5, '개인 보험료', 'other', NULL);

-- ============================================================================
-- 7. 추가옵션 INSERT
-- ============================================================================

INSERT INTO tour_addon_options (
  tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq,
  is_guide_escort_fee, is_post_tour_optional, is_available
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '식사 메뉴 선택: 랍스터 vs 생선', 'meal', '저녁식사 시 랍스터 또는 싱싱한 생선 중 선택 (기본 제공 항목)', 0, 'per_person', 0, 1, false, false, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '호텔 픽업 서비스', 'transport', '하노이 시내 또는 크루즈 인근 호텔에서 투어 출발지까지 픽업 (왕복)', 400000, 'per_team', 30, 2, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '공항 픽업 서비스', 'transport', '노이바이 공항 또는 시내에서 크루즈 선착장까지 픽업', 600000, 'per_team', 45, 3, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '셔틀 서비스 (선택사항)', 'service', '크루즈 내부 셔틀 서비스 - 투어 후 호텔/공항 드롭 (사전 예약)', 0, 'per_team', 0, 4, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '추가 음료 (맥주/와인)', 'meal', '프레미엄 알코올 음료 추가 제공 (일몰 시간 특별 제공)', 100000, 'per_person', 0, 5, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '전문 사진촬영 서비스', 'other', '전문 사진가가 투어 중 고품질 사진 촬영 및 USB 제공', 250000, 'per_team', 270, 6, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '비디오 촬영 및 편집', 'other', '전문 가이드가 투어 중 촬영 후 편집하여 제공 (4K 영상, 5-6분)', 300000, 'per_team', 270, 7, false, true, true);

-- ============================================================================
-- 8. 투어 일정/스케줄 INSERT
-- ============================================================================

INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 1, '16:15', '16:30', '크루즈 선착장에서 가이드 미팅 및 탑승', 15, false, '{"location": "크루즈 선착장", "note": "16:30 정시 출발이므로 최소 15분 전 도착"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 2, '16:30', '17:15', '보트로 드래곤펄 카이 이동 (일몰 시간대)', 45, false, '{"transportation": "traditional longtail boat", "distance": "약 45분 거리", "special": "일몰 감상 중 이동"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 3, '17:15', '18:00', '드래곤펄 카이 동굴 투어 (야경 조명)', 45, false, '{"activities": ["limestone cave exploration with lighting", "floating village nighttime view", "evening atmosphere", "photography opportunities"], "guide_led": true}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 4, '18:00', '19:00', '베트남 전통 저녁식사 (랍스터 또는 생선)', 60, false, '{"meal": true, "menu": "Fresh seafood dinner with lobster or fish selection", "beverage": "water, tea, coffee, optional beer/wine"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 5, '19:00', '19:40', '수상마을 야경투어 및 자유시간', 40, false, '{"activities": ["floating village nighttime visit", "local night life observation", "photo opportunity under stars"], "optional": false}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 6, '19:40', '20:40', '하롱베이 야경 감상 및 자유시간', 60, false, '{"activities": ["stargazing", "night sky observation", "relaxation", "final views"], "comfort": "open air viewing deck"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 7, '20:40', '21:10', '크루즈 선착장으로 복귀', 30, false, '{"transportation": "return boat journey", "comfort": "calm return evening trip"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 1, 8, '21:10', '21:15', '투어 종료 및 드롭', 5, false, '{"end": true, "note": "크루즈 또는 호텔 드롭 (픽업 옵션 선택 시)"}');

-- ============================================================================
-- 9. 취소정책 INSERT
-- ============================================================================

INSERT INTO tour_cancellation_policy (
  tour_id, policy_name, order_seq, days_before_min, days_before_max,
  penalty_type, penalty_amount, penalty_rate, description, refundable
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '7일 이상 전 취소', 1, 7, 999, 'rate', NULL, NULL, '투어 예정일 7일 전까지는 무료 취소 가능 (수수료 없음)', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '3~6일 전 취소', 2, 3, 6, 'rate', NULL, 0.50, '투어 3~6일 전 취소 시 예약금의 50% 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '1~2일 전 취소', 3, 1, 2, 'rate', NULL, 0.25, '투어 1~2일 전 취소 시 예약금의 25% 환불만 가능', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '투어당일 취소', 4, 0, 0, 'rate', NULL, 0.00, '투어 당일 취소 시 환불 불가 (예약금 전액 미환불)', false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), '기상악화/불가항력', 5, 0, 999, 'rate', NULL, NULL, '악천후로 투어 안전에 위협 시 전액 환불 또는 일정 변경', true);

-- ============================================================================
-- 10. 중요 정보/주의사항 INSERT
-- ============================================================================

INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'notice', 'DRAGON PEARL EVENING TOUR - 크루즈 고객 전용 저녁 프로그램입니다 (일몰/야경 포함).', 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'caution', '16:30 정시 출발 (12시간 이상 지각 시 불참 처리)', 2, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'guide', '식사 메뉴: 랍스터 또는 싱싱한 생선 선택 (사전 공지 필수)', 3, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'notice', '결제방식: 카드 1,350,000동 또는 국제송금 1,300,000동 (-5만동)', 4, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'warning', '임산부, 유아, 심장질환자는 투어 참가 전 의료 상담 권장', 5, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'guide', '일몰 시간대에 출발하므로 카메라 준비 권장', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'notice', '호텔/공항 픽업은 선택사항입니다 (추가 요금 발생)', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'caution', '수심이 깊으므로 수영 불가 (보트 탑승만 가능)', 8, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'guide', '나이 또는 체력 제한: 없음 (다만 적절한 신체 조건 필요)', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'notice', '취소정책: 7일 이상 전 무료 취소, 이후 단계적 패널티 적용', 10, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'guide', '투어 예약 및 상담: 카카오채널 (http://pf.kakao.com/_zvsxaG/chat)', 11, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'notice', '크루즈 선착장 미팅 - 최소 15분 전 도착하여 가이드 확인 필수', 12, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001'), 'notice', '성수기(4월-10월) 선착순 마감 가능 - 조기 예약 권장', 13, false);

SELECT 'DRAGON PEARL EVENING INSERT COMPLETE' AS status;

COMMIT;

-- ============================================================================
-- 검증 쿼리 (주석 처리 - 필요시 실행)
-- ============================================================================

-- 투어 정보 확인
-- SELECT tour_code, tour_name, program_type, is_cruise_addon, duration 
-- FROM tour 
-- WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001';

-- 기본 가격 확인
-- SELECT min_guests, max_guests, price_per_person, default_payment_method 
-- FROM tour_pricing 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001');

-- 결제방식별 가격 확인
-- SELECT payment_method, price, price_adjustment, notes 
-- FROM tour_payment_pricing 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001');

-- 크루즈 통합 정보 확인
-- SELECT cruise_addon_type, requires_cruise_booking, cruise_linking_note 
-- FROM tour_cruise_integration 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001');

-- 전체 데이터 수 확인
-- SELECT
--   'Pricing' AS type, COUNT(*) FROM tour_pricing 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Payment Pricing', COUNT(*) FROM tour_payment_pricing 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Inclusions', COUNT(*) FROM tour_inclusions 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Exclusions', COUNT(*) FROM tour_exclusions 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Add-on Options', COUNT(*) FROM tour_addon_options 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Schedules', COUNT(*) FROM tour_schedule 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Cancellation Policy', COUNT(*) FROM tour_cancellation_policy 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001')
-- UNION ALL
-- SELECT 'Info', COUNT(*) FROM tour_important_info 
--   WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_DRAGONPEARL_EVENING_001');
