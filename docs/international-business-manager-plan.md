# GoGo Maps — International Business Manager: development plan

Status: planning only. This file is on the development branch. No production database migration has been applied.

## Existing system confirmed (2026-10-27)
- Repository: gogomaps/GOGOGMAPS; main branch remains production.
- Test dashboard: business-manager-dashboard-test.html.
- Supabase project: adifwwlmdditbdxjwbjn.
- Existing public tables: businesses, promotions, advertisements, staff_users, sales_representatives, commission_payments.
- Existing customer_code/customer_number fields, sequences and trigger/function require inspection before altering.
- Existing RLS: public can SELECT all rows in businesses; anon can SELECT date-active promotions; staff/admin policies are mixed.
- Security advisor: public.sales_rep_commission_summary SECURITY DEFINER view; public.generate_customer_code mutable search_path; public.check_commission_payment() and public.is_gogomaps_admin() are SECURITY DEFINER functions executable by API roles; leaked password protection disabled.
- Never expose service-role keys in browser.

## Delivery stages
1. Audit current SQL objects, triggers, policies, public map queries, and data shape. Identify dependencies before changing anything.
2. Create city configuration (city code, country, currency, timezone, language, contact dialing code, active flag) and city-scoped staff memberships. Start BAT; allow TBI, JHB, CPT, PLU, MOS later.
3. Plan customer identifiers with immutable city prefix and per-city sequence. Preserve any existing customer_code values and foreign keys. No renumbering.
4. Add private business contact fields (contact person, email, WhatsApp, social URLs) and per-field visibility settings. Restrict direct public SELECT of private fields: use a carefully scoped public projection with explicit access grants and RLS, or separate public listing tables. Test anonymous API access.
5. Add advertising package versions by city/currency; snapshot price, discount, term, and commission rate on each sale.
6. Add representative commission rate history with effective dates; never automatically change rates based on volume.
7. Add application submissions, approval/rejection history, scheduled publishing, and notifications. No public publication without approval and valid dates.
8. Add admin-only Office area with server-side authorization and secure PIN verification/rate limits; no PIN stored or checked in HTML/JavaScript.
9. Implement renewal reminder queue and payment-provider integration after merchant eligibility and payment gateway are chosen.
10. Build test-only dashboard and portals, verify role permissions, then propose production deployment separately.

## Security gates before rollout
- Review security-definer functions and view definitions before changing grants or invoker mode (avoid breaking admin checks and commission calculations).
- Review RLS for each new table and city membership; authenticated != authorized.
- Review public-facing SELECT permissions before adding private business data.
- Validate anonymous vs rep vs city admin vs head office API access.
- Use staged, reversible migrations with backups and explicit user approval before touching the live database.

## Next engineering step
Read-only inspect triggers, sequences, SQL function/view definitions, current public API consumers, and schema dependencies. Produce a concrete migration SQL proposal and test plan; do not execute it on the live project without approval.
