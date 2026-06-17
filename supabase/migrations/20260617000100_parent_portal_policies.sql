-- Migration: Add policies for anon (parent portal) to select and perform top-up updates
-- Date: 2026-06-17

-- 1. Profiles Table Policies
CREATE POLICY "Semua user anon dapat membaca data profil"
    ON public.profiles FOR SELECT TO anon USING (true);

-- 2. Students Table Policies
CREATE POLICY "Semua user anon dapat membaca data siswa"
    ON public.students FOR SELECT TO anon USING (true);

CREATE POLICY "Semua user anon dapat memperbarui data siswa"
    ON public.students FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- 3. Canteen Operators Table Policies
CREATE POLICY "Semua user anon dapat membaca data operator kantin"
    ON public.canteen_operators FOR SELECT TO anon USING (true);

-- 4. Products Table Policies
CREATE POLICY "Semua user anon dapat melihat daftar jajanan"
    ON public.products FOR SELECT TO anon USING (true);

-- 5. Transactions Table Policies
CREATE POLICY "Semua user anon dapat membaca data transaksi"
    ON public.transactions FOR SELECT TO anon USING (true);

CREATE POLICY "Semua user anon dapat menambah transaksi"
    ON public.transactions FOR INSERT TO anon WITH CHECK (true);

-- 6. Transaction Items Table Policies
CREATE POLICY "Semua user anon dapat membaca data item transaksi"
    ON public.transaction_items FOR SELECT TO anon USING (true);

-- 7. Notifications Table Policies
CREATE POLICY "Semua user anon dapat membaca data notifikasi"
    ON public.notifications FOR SELECT TO anon USING (true);

CREATE POLICY "Semua user anon dapat menambah notifikasi"
    ON public.notifications FOR INSERT TO anon WITH CHECK (true);
