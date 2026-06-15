-- Migration: Add username and nisn columns to profiles table
-- Date: 2026-06-15

-- 1. Add username and nisn columns to public.profiles if they do not exist
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS username TEXT UNIQUE;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS nisn TEXT UNIQUE;

-- 2. Populate username and nisn columns for existing accounts to match their current emails/roles
-- For Cashier/Petugas
UPDATE public.profiles
SET username = 'petugas'
WHERE email = 'petugas@sekolah.sch.id';

-- For Student (Ahmad)
UPDATE public.profiles
SET username = 'ahmad', nisn = '20260012'
WHERE email = '20260012@sekolah.sch.id';
