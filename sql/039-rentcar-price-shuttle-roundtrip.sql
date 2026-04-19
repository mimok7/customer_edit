-- ============================================================
-- 039-rentcar-price-shuttle-roundtrip.sql
-- 스테이하롱 셔틀 리무진 4종 당일왕복/다른날왕복 추가
-- 
-- 문제: 편도(way_type='편도')에는 9개의 하노이-하롱베이 차량이 있으나
--       당일왕복/다른날왕복에는 일반차량 5개만 있고,
--       스테이하롱 셔틀 리무진 4개가 누락됨.
-- 
-- 원본: car_price 테이블 왕복 항목
--   C013: 스테이하롱 셔틀 리무진 A,    왕복, 1,000,000동
--   C014: 스테이하롱 셔틀 리무진 B,    왕복,   800,000동
--   C015: 스테이하롱 셔틀 리무진 C,    왕복,   650,000동
--   C016: 스테이하롱 셔틀 리무진 단독, 왕복, 5,200,000동
--
-- 추가 대상: 당일왕복 4개 + 다른날왕복 4개 = 8개
-- 경로: 하노이 ↔ 하롱베이
-- ============================================================

-- 중복 방지: 이미 존재하는 경우 건너뜀
INSERT INTO rentcar_price (
    rent_code,
    category,
    car_category_code,
    vehicle_type,
    route,
    route_from,
    route_to,
    way_type,
    price,
    capacity,
    duration_hours,
    rental_type,
    year,
    description,
    is_active,
    cruise,
    memo
)
SELECT * FROM (VALUES
    -- ★ 당일왕복 4개
    (
        'SHT_LIMO_A_HN_HL_2WAY',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 A',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '당일왕복',
        1000000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 A 당일왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C013',
        true,
        '공통',
        '크루즈'
    ),
    (
        'SHT_LIMO_B_HN_HL_2WAY',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 B',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '당일왕복',
        800000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 B 당일왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C014',
        true,
        '공통',
        '크루즈'
    ),
    (
        'SHT_LIMO_C_HN_HL_2WAY',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 C',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '당일왕복',
        650000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 C 당일왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C015',
        true,
        '공통',
        '크루즈'
    ),
    (
        'SHT_LIMO_SOLO_HN_HL_2WAY',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 단독',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '당일왕복',
        5200000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 단독 당일왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C016',
        true,
        '공통',
        '크루즈'
    ),
    -- ★ 다른날왕복 4개
    (
        'SHT_LIMO_A_HN_HL_2WAY_DIFF',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 A',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '다른날왕복',
        1000000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 A 다른날왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C013',
        true,
        '공통',
        '크루즈'
    ),
    (
        'SHT_LIMO_B_HN_HL_2WAY_DIFF',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 B',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '다른날왕복',
        800000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 B 다른날왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C014',
        true,
        '공통',
        '크루즈'
    ),
    (
        'SHT_LIMO_C_HN_HL_2WAY_DIFF',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 C',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '다른날왕복',
        650000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 C 다른날왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C015',
        true,
        '공통',
        '크루즈'
    ),
    (
        'SHT_LIMO_SOLO_HN_HL_2WAY_DIFF',
        '공통',
        '크루즈',
        '스테이하롱 셔틀 리무진 단독',
        '하노이 - 하롱베이',
        '하노이',
        '하롱베이',
        '다른날왕복',
        5200000,
        NULL::integer,
        NULL::integer,
        '공유차량',
        2026,
        '스테이하롱 셔틀 리무진 단독 다른날왕복 | 하노이 ↔ 하롱베이 | migrated from car_price:C016',
        true,
        '공통',
        '크루즈'
    )
) AS v(
    rent_code, category, car_category_code, vehicle_type,
    route, route_from, route_to, way_type, price, capacity,
    duration_hours, rental_type, year, description, is_active,
    cruise, memo
)
WHERE NOT EXISTS (
    SELECT 1 FROM rentcar_price rp
    WHERE rp.rent_code = v.rent_code
);

-- ============================================================
-- 검증 쿼리 (삽입 후 확인)
-- ============================================================
-- 하노이-하롱베이 경로 way_type별 차량 수 확인
-- SELECT way_type, COUNT(*) AS cnt, 
--        STRING_AGG(vehicle_type, ', ' ORDER BY vehicle_type) AS vehicles
-- FROM rentcar_price
-- WHERE route = '하노이 - 하롱베이'
-- GROUP BY way_type
-- ORDER BY way_type;

-- 새로 추가된 항목 확인
-- SELECT rent_code, vehicle_type, way_type, price, description
-- FROM rentcar_price
-- WHERE rent_code LIKE 'SHT_LIMO_%'
-- ORDER BY way_type, vehicle_type;
