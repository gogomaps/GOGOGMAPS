-- GoGo Maps international foundation — PROPOSED, NOT APPLIED
-- This is an additive schema proposal for review before production execution.
-- Existing BAT customer codes (e.g. BAT100001) remain unchanged.
-- No changes to businesses, promotions, advertisements, commission tables or RLS policies.

begin;

create table if not exists public.gogo_cities (
  city_code text primary key
    check (city_code ~ '^[A-Z]{3}$'),
  city_name text not null,
  country_code text not null
    check (country_code ~ '^[A-Z]{2}$'),
  currency_code text not null
    check (currency_code ~ '^[A-Z]{3}$'),
  timezone_name text not null,
  default_language text not null default 'en',
  telephone_country_code text,
  active boolean not null default false,
  created_at timestamptz not null default now()
);

-- Deliberately no anon/authenticated table grants or SELECT policies.
-- Admin operations use controlled back-office services only.
alter table public.gogo_cities enable row level security;
revoke all on public.gogo_cities from anon, authenticated;

insert into public.gogo_cities
  (city_code,city_name,country_code,currency_code,timezone_name,default_language,telephone_country_code,active)
values
  ('BAT','Batumi','GE','GEL','Asia/Tbilisi','en','+995',true),
  ('TBI','Tbilisi','GE','GEL','Asia/Tbilisi','en','+995',false),
  ('JHB','Johannesburg','ZA','ZAR','Africa/Johannesburg','en','+27',false),
  ('CPT','Cape Town','ZA','ZAR','Africa/Johannesburg','en','+27',false),
  ('PLU','Port Louis','MU','MUR','Indian/Mauritius','en','+230',false),
  ('MOS','Moscow','RU','RUB','Europe/Moscow','en','+7',false)
on conflict (city_code) do nothing;

-- New-city numbering only. Existing BAT numbering is NOT moved to this table.
-- No public client may modify counters directly.
create table if not exists public.gogo_city_customer_counters (
  city_code text primary key references public.gogo_cities(city_code),
  last_issued bigint not null default 0 check (last_issued >= 0),
  updated_at timestamptz not null default now()
);
alter table public.gogo_city_customer_counters enable row level security;
revoke all on public.gogo_city_customer_counters from anon, authenticated;

-- Next stage (separate migration): implement a guarded transactional allocator,
-- immutable customer codes, city memberships, and city foreign keys.
-- Do NOT directly allocate customer numbers from a browser client.

commit;

-- Read-only verification after approved deployment:
-- select city_code, city_name, currency_code, active from public.gogo_cities order by city_code;
-- select * from public.gogo_city_customer_counters;
-- select customer_code from public.businesses order by customer_code limit 10;
