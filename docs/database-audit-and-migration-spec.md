# Database audit and first migration specification — 2026-10-27

**Environment:** production Supabase project `adifwwlmdditbdxjwbjn`. Read-only inspection only. **No migration has been applied.**

## Verified existing behaviour
- `businesses.customer_number` is a bigint using `customer_number_seq`; `businesses.customer_code` is unique.
- `set_customer_code` BEFORE INSERT trigger calls `generate_customer_code()`, which creates `BAT` + six-digit zero-padded `customer_number` when code is null.
- `advertisement_commission_trigger` BEFORE INSERT/UPDATE calculates `commission_amount` from `amount * commission_percentage / 100` when `representative_id` and the other fields are populated.
- `check_commission_payment_trigger` BEFORE INSERT guards against payments exceeding aggregate earned minus paid commission.
- `sales_rep_commission_summary` view joins sales representatives, advertisement aggregates and payment aggregates.
- Anonymous SELECT on `businesses` currently allows **all rows and columns** granted to the API role. This is unsafe for new private contact fields without a public/private redesign.
- Existing security advisories: `sales_rep_commission_summary` definer view; `generate_customer_code` mutable search path; API-executable definer functions; leaked password protection disabled.

## Important design decisions
1. **Do not change the existing BAT sequence or customer codes** as part of initial migration. Audit actual values and application dependencies first.
2. Add a `cities` table keyed by stable three-letter `city_code` with country ISO code, currency, timezone, active flag, and optional local pricing configuration. Initial city BAT; later TBI/JHB/CPT/PLU/MOS.
3. Add nullable `city_code` foreign key to businesses and advertisements during transition; backfill existing Batumi data only after verifying all records belong to Batumi; then enforce NOT NULL after application rollout. Ensure city consistency across related records.
4. Create an atomic **per-city customer-number allocator** protected from concurrency; only invoke for newly created non-BAT city businesses. Preserve existing customer identifiers and numbering scheme. Protect code immutability at database layer.
5. **Privacy prerequisite:** replace unrestricted anonymous access to base `businesses` with a public listing interface that exposes only approved public fields. Coordinate public map code updates and policy rollout together to avoid breaking live map. Do not add private contact fields while base table remains publicly readable.
6. Add private business profile/contact data in an admin-only table with field-level public visibility flags; keep contact person private by default. Expose approved contact data only through controlled projection.
7. Add `representative_commission_rates` with effective start date and management-only permissions. Snapshot the effective percentage at the time of a new sale; preserve historical `advertisements.commission_percentage` and `commission_amount`.
8. Investigate how legacy `staff_users`, sales representatives, and dashboard login interact before introducing city-scoped membership and Office PIN.
9. Do not replace `sales_rep_commission_summary` view or revoke function grants without testing all dashboard and trigger dependencies.

## Proposed next work (not yet executed)
- Inspect current customer codes, column privileges, storage policies, public map SQL/API queries, and representative assignment.
- Draft first *additive* migration for `cities`, `city_staff_memberships`, and a city sequence allocator with RLS.
- Design the public listing transition separately, with a testable rollback plan.
- Ask user approval before any schema or live access-policy changes.

## Verification plan
- Confirm old BAT codes unchanged and old business listing still works.
- Confirm simultaneous allocations in same city produce distinct codes.
- Confirm cross-city user access is denied and anonymous users cannot read private contact data.
- Confirm commissions and payment checks remain correct for existing sales.
- Confirm public map Version 8 still loads and displays approved listings.
