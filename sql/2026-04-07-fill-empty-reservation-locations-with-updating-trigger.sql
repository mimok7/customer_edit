-- 2026-04-07
-- 목적: 예약 관련 상세 테이블의 장소 컬럼이 NULL/공백으로 저장될 때 자동으로 'Updating'을 입력
-- 적용: reservation_airport, reservation_car_sht, reservation_cruise_car, reservation_rentcar, reservation_tour
-- 주의: 기존 데이터도 아래 BACKFILL 구문으로 일괄 보정 가능

BEGIN;

-- =========================================================
-- 1) reservation_airport
-- =========================================================
CREATE OR REPLACE FUNCTION public.fn_fill_reservation_airport_locations()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.ra_airport_location IS NULL OR btrim(NEW.ra_airport_location) = '' THEN
    NEW.ra_airport_location := 'Updating';
  END IF;

  IF NEW.ra_stopover_location IS NULL OR btrim(NEW.ra_stopover_location) = '' THEN
    NEW.ra_stopover_location := 'Updating';
  END IF;

  IF NEW.accommodation_info IS NULL OR btrim(NEW.accommodation_info) = '' THEN
    NEW.accommodation_info := 'Updating';
  END IF;

  IF NEW.ra_airport_name IS NULL OR btrim(NEW.ra_airport_name) = '' THEN
    NEW.ra_airport_name := 'Updating';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fill_reservation_airport_locations ON public.reservation_airport;
CREATE TRIGGER trg_fill_reservation_airport_locations
BEFORE INSERT OR UPDATE OF ra_airport_location, ra_stopover_location, accommodation_info, ra_airport_name
ON public.reservation_airport
FOR EACH ROW
EXECUTE FUNCTION public.fn_fill_reservation_airport_locations();

-- =========================================================
-- 2) reservation_car_sht
-- =========================================================
CREATE OR REPLACE FUNCTION public.fn_fill_reservation_car_sht_locations()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.pickup_location IS NULL OR btrim(NEW.pickup_location) = '' THEN
    NEW.pickup_location := 'Updating';
  END IF;

  IF NEW.dropoff_location IS NULL OR btrim(NEW.dropoff_location) = '' THEN
    NEW.dropoff_location := 'Updating';
  END IF;

  IF NEW.accommodation_info IS NULL OR btrim(NEW.accommodation_info) = '' THEN
    NEW.accommodation_info := 'Updating';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fill_reservation_car_sht_locations ON public.reservation_car_sht;
CREATE TRIGGER trg_fill_reservation_car_sht_locations
BEFORE INSERT OR UPDATE OF pickup_location, dropoff_location, accommodation_info
ON public.reservation_car_sht
FOR EACH ROW
EXECUTE FUNCTION public.fn_fill_reservation_car_sht_locations();

-- =========================================================
-- 3) reservation_cruise_car
-- =========================================================
CREATE OR REPLACE FUNCTION public.fn_fill_reservation_cruise_car_locations()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.pickup_location IS NULL OR btrim(NEW.pickup_location) = '' THEN
    NEW.pickup_location := 'Updating';
  END IF;

  IF NEW.dropoff_location IS NULL OR btrim(NEW.dropoff_location) = '' THEN
    NEW.dropoff_location := 'Updating';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fill_reservation_cruise_car_locations ON public.reservation_cruise_car;
CREATE TRIGGER trg_fill_reservation_cruise_car_locations
BEFORE INSERT OR UPDATE OF pickup_location, dropoff_location
ON public.reservation_cruise_car
FOR EACH ROW
EXECUTE FUNCTION public.fn_fill_reservation_cruise_car_locations();

-- =========================================================
-- 4) reservation_rentcar
-- =========================================================
CREATE OR REPLACE FUNCTION public.fn_fill_reservation_rentcar_locations()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.pickup_location IS NULL OR btrim(NEW.pickup_location) = '' THEN
    NEW.pickup_location := 'Updating';
  END IF;

  IF NEW.destination IS NULL OR btrim(NEW.destination) = '' THEN
    NEW.destination := 'Updating';
  END IF;

  IF NEW.via_location IS NULL OR btrim(NEW.via_location) = '' THEN
    NEW.via_location := 'Updating';
  END IF;

  IF NEW.return_pickup_location IS NULL OR btrim(NEW.return_pickup_location) = '' THEN
    NEW.return_pickup_location := 'Updating';
  END IF;

  IF NEW.return_destination IS NULL OR btrim(NEW.return_destination) = '' THEN
    NEW.return_destination := 'Updating';
  END IF;

  IF NEW.return_via_location IS NULL OR btrim(NEW.return_via_location) = '' THEN
    NEW.return_via_location := 'Updating';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fill_reservation_rentcar_locations ON public.reservation_rentcar;
CREATE TRIGGER trg_fill_reservation_rentcar_locations
BEFORE INSERT OR UPDATE OF pickup_location, destination, via_location, return_pickup_location, return_destination, return_via_location
ON public.reservation_rentcar
FOR EACH ROW
EXECUTE FUNCTION public.fn_fill_reservation_rentcar_locations();

-- =========================================================
-- 5) reservation_tour
-- =========================================================
CREATE OR REPLACE FUNCTION public.fn_fill_reservation_tour_locations()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.pickup_location IS NULL OR btrim(NEW.pickup_location) = '' THEN
    NEW.pickup_location := 'Updating';
  END IF;

  IF NEW.dropoff_location IS NULL OR btrim(NEW.dropoff_location) = '' THEN
    NEW.dropoff_location := 'Updating';
  END IF;

  IF NEW.accommodation_info IS NULL OR btrim(NEW.accommodation_info) = '' THEN
    NEW.accommodation_info := 'Updating';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fill_reservation_tour_locations ON public.reservation_tour;
CREATE TRIGGER trg_fill_reservation_tour_locations
BEFORE INSERT OR UPDATE OF pickup_location, dropoff_location, accommodation_info
ON public.reservation_tour
FOR EACH ROW
EXECUTE FUNCTION public.fn_fill_reservation_tour_locations();

-- =========================================================
-- Optional BACKFILL (기존 데이터 보정)
-- =========================================================
UPDATE public.reservation_airport
SET
  ra_airport_location = CASE WHEN ra_airport_location IS NULL OR btrim(ra_airport_location) = '' THEN 'Updating' ELSE ra_airport_location END,
  ra_stopover_location = CASE WHEN ra_stopover_location IS NULL OR btrim(ra_stopover_location) = '' THEN 'Updating' ELSE ra_stopover_location END,
  accommodation_info = CASE WHEN accommodation_info IS NULL OR btrim(accommodation_info) = '' THEN 'Updating' ELSE accommodation_info END,
  ra_airport_name = CASE WHEN ra_airport_name IS NULL OR btrim(ra_airport_name) = '' THEN 'Updating' ELSE ra_airport_name END;

UPDATE public.reservation_car_sht
SET
  pickup_location = CASE WHEN pickup_location IS NULL OR btrim(pickup_location) = '' THEN 'Updating' ELSE pickup_location END,
  dropoff_location = CASE WHEN dropoff_location IS NULL OR btrim(dropoff_location) = '' THEN 'Updating' ELSE dropoff_location END,
  accommodation_info = CASE WHEN accommodation_info IS NULL OR btrim(accommodation_info) = '' THEN 'Updating' ELSE accommodation_info END;

UPDATE public.reservation_cruise_car
SET
  pickup_location = CASE WHEN pickup_location IS NULL OR btrim(pickup_location) = '' THEN 'Updating' ELSE pickup_location END,
  dropoff_location = CASE WHEN dropoff_location IS NULL OR btrim(dropoff_location) = '' THEN 'Updating' ELSE dropoff_location END;

UPDATE public.reservation_rentcar
SET
  pickup_location = CASE WHEN pickup_location IS NULL OR btrim(pickup_location) = '' THEN 'Updating' ELSE pickup_location END,
  destination = CASE WHEN destination IS NULL OR btrim(destination) = '' THEN 'Updating' ELSE destination END,
  via_location = CASE WHEN via_location IS NULL OR btrim(via_location) = '' THEN 'Updating' ELSE via_location END,
  return_pickup_location = CASE WHEN return_pickup_location IS NULL OR btrim(return_pickup_location) = '' THEN 'Updating' ELSE return_pickup_location END,
  return_destination = CASE WHEN return_destination IS NULL OR btrim(return_destination) = '' THEN 'Updating' ELSE return_destination END,
  return_via_location = CASE WHEN return_via_location IS NULL OR btrim(return_via_location) = '' THEN 'Updating' ELSE return_via_location END;

UPDATE public.reservation_tour
SET
  pickup_location = CASE WHEN pickup_location IS NULL OR btrim(pickup_location) = '' THEN 'Updating' ELSE pickup_location END,
  dropoff_location = CASE WHEN dropoff_location IS NULL OR btrim(dropoff_location) = '' THEN 'Updating' ELSE dropoff_location END,
  accommodation_info = CASE WHEN accommodation_info IS NULL OR btrim(accommodation_info) = '' THEN 'Updating' ELSE accommodation_info END;

COMMIT;
