-- GoGo Maps branch autonomy / global oversight
-- Applied separately in Supabase as migration gogo_branch_management_foundation.
-- Role memberships and branch settings are private by default. No logins granted yet.
create table if not exists public.gogo_management_memberships (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null check (role in ('global_owner','global_admin','branch_manager','branch_staff','branch_representative')),
 location_code text references public.gogo_locations(location_code),
 active boolean not null default true,
 appointed_at timestamptz not null default now(),
 created_at timestamptz not null default now(),
 check ((role in ('global_owner','global_admin') and location_code is null)
 or (role in ('branch_manager','branch_staff','branch_representative') and location_code is not null)),
 unique(user_id,role,location_code)
);
create unique index if not exists gogo_management_global_role_unique
on public.gogo_management_memberships(user_id,role) where location_code is null;
create index if not exists gogo_management_memberships_location_idx
on public.gogo_management_memberships(location_code,user_id) where active;
alter table public.gogo_management_memberships enable row level security;
revoke all on public.gogo_management_memberships from anon,authenticated;
create table if not exists public.gogo_branch_settings (
 location_code text primary key references public.gogo_locations(location_code),
 branch_display_name text not null,
 branch_status text not null default 'planned'
 check (branch_status in ('planned','active','suspended')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
alter table public.gogo_branch_settings enable row level security;
revoke all on public.gogo_branch_settings from anon,authenticated;
insert into public.gogo_branch_settings(location_code,branch_display_name,branch_status)
select location_code,location_name,case when active then 'active' else 'planned' end
from public.gogo_locations on conflict(location_code) do nothing;
