-- GoGo Maps private branch customer registry (migration applied to Supabase)
-- Existing public.businesses and BAT customer numbering are unchanged.
create table public.gogo_branch_customers (
 id uuid primary key default gen_random_uuid(),
 location_code text not null references public.gogo_locations(location_code),
 customer_number bigint not null,
 customer_code text not null unique,
 business_name text not null check (length(btrim(business_name)) between 1 and 200),
 contact_name text,email text,phone text,address text,notes text,
 created_by uuid not null default auth.uid() references auth.users(id),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(location_code,customer_number)
);
create index gogo_branch_customers_location_idx on public.gogo_branch_customers(location_code,created_at desc);
alter table public.gogo_branch_customers enable row level security;
revoke all on public.gogo_branch_customers from anon,authenticated;
grant select,insert on public.gogo_branch_customers to authenticated;
create policy gogo_branch_customers_read_authorized on public.gogo_branch_customers
for select to authenticated using (
 exists(select 1 from public.gogo_management_memberships m
 where m.user_id=(select auth.uid()) and m.active
 and (m.role in ('global_owner','global_admin')
 or (m.location_code=gogo_branch_customers.location_code and m.role in ('branch_manager','branch_staff'))))
);
create policy gogo_branch_customers_insert_authorized on public.gogo_branch_customers
for insert to authenticated with check (
 created_by=(select auth.uid()) and
 exists(select 1 from public.gogo_management_memberships m
 where m.user_id=(select auth.uid()) and m.active
 and (m.role in ('global_owner','global_admin')
 or (m.location_code=gogo_branch_customers.location_code and m.role in ('branch_manager','branch_staff'))))
);
create function public.gogo_assign_branch_customer_number()
returns trigger language plpgsql security definer set search_path='' as $$
declare issued bigint;
begin
 if new.location_code='BAT' then
   raise exception 'Batumi registrations continue through the legacy customer workflow until migration is approved';
 end if;
 insert into public.gogo_location_customer_counters(location_code,last_issued,updated_at)
 values(new.location_code,100001,now())
 on conflict(location_code) do update
 set last_issued=public.gogo_location_customer_counters.last_issued+1,updated_at=now()
 returning last_issued into issued;
 new.customer_number:=issued;
 new.customer_code:=new.location_code||lpad(issued::text,6,'0');
 return new;
end $$;
revoke all on function public.gogo_assign_branch_customer_number() from public,anon,authenticated;
create trigger gogo_assign_branch_customer_number_before_insert
before insert on public.gogo_branch_customers
for each row execute function public.gogo_assign_branch_customer_number();
