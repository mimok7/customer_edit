-- 2026-04-06-create-airport-fasttrack-table.sql
-- 공항 서비스 패스트랙 신청자 저장 테이블 생성

BEGIN;

CREATE TABLE IF NOT EXISTS public.reservation_airport_fasttrack (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reservation_id uuid NOT NULL REFERENCES public.reservation(re_id) ON DELETE CASCADE,
  reservation_airport_id uuid NOT NULL REFERENCES public.reservation_airport(id) ON DELETE CASCADE,
  way_type text NOT NULL CHECK (way_type IN ('pickup', 'sending')),
  applicant_order integer NOT NULL CHECK (applicant_order > 0),
  applicant_name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT reservation_airport_fasttrack_upper_name_chk CHECK (applicant_name = upper(applicant_name)),
  CONSTRAINT reservation_airport_fasttrack_name_format_chk CHECK (applicant_name ~ '^[A-Z ]+$'),
  CONSTRAINT reservation_airport_fasttrack_unique_order UNIQUE (reservation_airport_id, applicant_order)
);

COMMENT ON TABLE public.reservation_airport_fasttrack IS
  '공항 예약 패스트랙 신청자 목록 (행당 신청자 1명, 영문 대문자 저장)';

COMMENT ON COLUMN public.reservation_airport_fasttrack.way_type IS
  '해당 공항 서비스 구분: pickup | sending';

COMMENT ON COLUMN public.reservation_airport_fasttrack.applicant_name IS
  '패스트랙 신청자 영문 이름 (대문자)';

CREATE INDEX IF NOT EXISTS idx_reservation_airport_fasttrack_reservation_id
  ON public.reservation_airport_fasttrack(reservation_id);

CREATE INDEX IF NOT EXISTS idx_reservation_airport_fasttrack_airport_id
  ON public.reservation_airport_fasttrack(reservation_airport_id);

COMMIT;
