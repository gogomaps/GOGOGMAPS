-- Applied in Supabase as gogo_branch_context_read_policies.
-- Signed-in users may read their own appointments, but cannot create appointments.
grant select on public.gogo_management_memberships to authenticated;
create policy gogo_membership_read_own
on public.gogo_management_memberships for select to authenticated
using (user_id = (select auth.uid()));

-- Branch settings visible to global roles or staff assigned to that branch.
grant select on public.gogo_branch_settings to authenticated;
create policy gogo_branch_settings_read_authorized
on public.gogo_branch_settings for select to authenticated
using (exists (
 select 1 from public.gogo_management_memberships m
 where m.user_id = (select auth.uid()) and m.active
 and (m.role in ('global_owner','global_admin') or
 (m.location_code = gogo_branch_settings.location_code
 and m.role in ('branch_manager','branch_staff','branch_representative')))
));

-- Global roles can see all locations; branch users see only their assigned locations.
grant select on public.gogo_locations to authenticated;
create policy gogo_locations_read_authorized
on public.gogo_locations for select to authenticated
using (exists (
 select 1 from public.gogo_management_memberships m
 where m.user_id = (select auth.uid()) and m.active
 and (m.role in ('global_owner','global_admin')
 or m.location_code = gogo_locations.location_code)
));
-- Existing businesses, advertisements, commission payments and public map
-- are intentionally untouched. Appointments must be created via trusted admin workflow.
