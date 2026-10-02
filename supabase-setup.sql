-- Chino personal · v1.0
-- Ejecuta este script UNA vez en Supabase > SQL Editor.
-- Usa tablas propias (chino_*): no toca user_data / user_daily_events de la app de francés,
-- así que es seguro incluso si lo ejecutas en el mismo proyecto.

create table if not exists public.chino_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.chino_user_data enable row level security;

drop policy if exists "chino read own data" on public.chino_user_data;
drop policy if exists "chino insert own data" on public.chino_user_data;
drop policy if exists "chino update own data" on public.chino_user_data;
create policy "chino read own data" on public.chino_user_data
  for select using (auth.uid() = user_id);
create policy "chino insert own data" on public.chino_user_data
  for insert with check (auth.uid() = user_id);
create policy "chino update own data" on public.chino_user_data
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.chino_daily_events (
  user_id uuid not null references auth.users(id) on delete cascade,
  event_id text not null,
  event_date date not null,
  event_type text not null check (event_type in ('practice','audio')),
  value numeric not null default 0,
  created_at timestamptz not null default now(),
  primary key (user_id, event_id)
);
alter table public.chino_daily_events enable row level security;

drop policy if exists "chino read own events" on public.chino_daily_events;
drop policy if exists "chino insert own events" on public.chino_daily_events;
drop policy if exists "chino update own events" on public.chino_daily_events;
create policy "chino read own events" on public.chino_daily_events
  for select using (auth.uid() = user_id);
create policy "chino insert own events" on public.chino_daily_events
  for insert with check (auth.uid() = user_id);
create policy "chino update own events" on public.chino_daily_events
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
