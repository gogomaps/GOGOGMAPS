-- GoGo Maps global locations foundation.
-- Additive only: no existing customers, ads, promotions or policies are changed.
-- Location codes are immutable reporting/customer prefixes, not necessarily 3 characters.
begin;
create table if not exists public.gogo_locations (
  location_code text primary key check (location_code ~ '^[A-Z]{3}(-[A-Z])?$'),
  location_name text not null,
  country_code text not null check (country_code ~ '^[A-Z]{2}$'),
  country_name text not null,
  parent_location_code text references public.gogo_locations(location_code),
  currency_code text not null check (currency_code ~ '^[A-Z]{3}$'),
  timezone_name text not null,
  default_language text not null default 'en',
  telephone_country_code text,
  active boolean not null default false,
  created_at timestamptz not null default now(),
  check (parent_location_code is distinct from location_code)
);
alter table public.gogo_locations enable row level security;
revoke all on public.gogo_locations from anon, authenticated;

-- Counter is reserved for future server-side customer-number allocation.
-- BAT retains its current customer_number_seq and existing BAT100001+ values.
create table if not exists public.gogo_location_customer_counters (
  location_code text primary key references public.gogo_locations(location_code),
  last_issued bigint not null default 0 check (last_issued >= 0),
  updated_at timestamptz not null default now()
);
alter table public.gogo_location_customer_counters enable row level security;
revoke all on public.gogo_location_customer_counters from anon, authenticated;

insert into public.gogo_locations
(location_code,location_name,country_code,country_name,parent_location_code,currency_code,timezone_name,default_language,telephone_country_code,active)
values
('BAT','Batumi','GE','Georgia',null,'GEL','Asia/Tbilisi','en','+995',true),
('TIB','Tbilisi','GE','Georgia',null,'GEL','Asia/Tbilisi','en','+995',false),
('MAU','Mauritius','MU','Mauritius',null,'MUR','Indian/Mauritius','en','+230',false),
('JHB-C','Johannesburg Central','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('JHB-E','Johannesburg East','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('JHB-N','Johannesburg North','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('JHB-S','Johannesburg South','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('JHB-W','Johannesburg West','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('PTA','Pretoria','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('BLM','Bloemfontein','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('CPT','Cape Town','ZA','South Africa',null,'ZAR','Africa/Johannesburg','en','+27',false),
('TUS','Tashkent','UZ','Uzbekistan',null,'UZS','Asia/Tashkent','en','+998',false),
('MOS','Moscow','RU','Russia',null,'RUB','Europe/Moscow','en','+7',false)
on conflict (location_code) do nothing;
commit;
-- Location code JHB-C etc is a *prefix*: final customer IDs will append digits.
-- Future: management-only read API, hierarchical reporting, per-location roles,
-- ledger for income/expenses, city-scoped pricing and approval workflows.
