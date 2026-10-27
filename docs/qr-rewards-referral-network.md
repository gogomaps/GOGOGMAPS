# GoGo Maps — QR, Rewards & Referral Network
## Product specification · Development branch

### Objective
Turn participating businesses into distribution channels for GoGo Maps without requiring registration to view an offer. Every branch runs local campaigns; Global Head Office sees aggregated international performance.

### QR visitor journey
1. A branch manager creates a business campaign with an opaque, non-guessable public QR slug.
2. A printable tent card links to a mobile-friendly GoGo Maps landing page showing the actual offer, expiry and participating business.
3. A visitor may view the offer without creating an account.
4. Optional: visitor creates a GoGo Member account, follows a business or city, opts in to a particular marketing channel, and saves the offer.
5. Offer redemption must use a one-time server-validated token or equivalent staff confirmation; scanning alone never proves redemption.
6. The visitor can share a personal referral link. Referral qualification requires verified new-member activity and anti-fraud checks.
7. Notifications go only to opted-in members; each channel has a separate preference and unsubscribe mechanism.

### Reporting and permissions
- Branch managers: only campaigns, anonymised analytics and approved customer data for assigned locations.
- Participating businesses: only their own campaigns and aggregated statistics; no unconsented member contact data.
- Global Owner/Admin: cross-country reporting with currency-aware income and expense totals.
- Members: their own profile, follows, rewards, referrals and preferences.
- Scan tracking should avoid collecting unnecessary personal data; aggregate anonymous analytics where possible.
- Staff and representatives must not have unrestricted direct access to personal member records.

### Database migration 005
Tables:
- gogo_members
- gogo_member_follows
- gogo_qr_campaigns
- gogo_qr_events
- gogo_referrals
- gogo_reward_ledger
- gogo_notification_preferences

All tables use RLS and are closed to browser roles pending audited server-side APIs. No member, reward or campaign has been created by this migration.

### Next implementation steps
1. Server-side campaign creation, QR slug validation and signed redemption flows.
2. Public offer landing page that never exposes contact information.
3. Member sign-up, explicit marketing opt-in and privacy notices.
4. Branch-scoped campaign management with manager test accounts.
5. Referral qualification, abuse prevention, capped rewards, and auditable ledger.
6. Opt-in email/push/WhatsApp notifications; deliverability and country-specific legal review.
7. QR tent-card generator and global/branch campaign reports.

### Important boundaries
- Existing public Version 8, Batumi customer numbering, and current Business Manager dashboard remain unchanged.
- Marketing consent is not inferred from scanning or visiting a page.
- Never claim a scan is a new registration or verified sale.
- No reward points are promised or issued until terms, budget and qualification rules are approved.
