-- Run this in Supabase Dashboard > SQL Editor.
create table if not exists public.starrock_journals (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"trades":[],"shots":{},"prop":{}}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.starrock_journals enable row level security;

-- Each signed-in user can access only their own journal row.
drop policy if exists "Users can read their own Starrock journal" on public.starrock_journals;
create policy "Users can read their own Starrock journal"
  on public.starrock_journals for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own Starrock journal" on public.starrock_journals;
create policy "Users can insert their own Starrock journal"
  on public.starrock_journals for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own Starrock journal" on public.starrock_journals;
create policy "Users can update their own Starrock journal"
  on public.starrock_journals for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
