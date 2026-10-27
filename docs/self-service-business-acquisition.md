# GoGo Maps — Self-Service Business Acquisition Plan
Status: Approved concept; implementation planned. No outbound email campaign is authorised or active.

## Domain and channels
Preferred domain: gogomaps.com, subject to live availability check and user purchase.
Proposed public entry points:
- /business/join — free business registration
- /business/advertise — paid campaigns
- /business/verify — verification
- /help — support and complaints
- /legal/business-terms and /privacy — versioned legal notices
- /invite/<campaign-token> — tracked invitation landing page
All links are proposed routes; none should be presented as deployed.

## Business onboarding
1. Business receives invitation by an approved lawful channel or discovers GoGo Maps organically.
2. QR code and clickable invitation link open the same mobile-friendly self-service page.
3. Business owner chooses free listing or advertising.
4. Owner enters name, country, branch, category, address, location, contact and authorised representative.
5. Confirm email ownership; verify the business and prevent duplicate listings.
6. Present versioned Business Listing Terms, Privacy Notice and optional separate marketing permissions; record explicit checkbox acceptance, timestamp, user ID, terms version and source.
7. Branch manager reviews registration; assign a permanent branch customer number server-side only on approval.
8. Publish verified free listing without inventing offers or specials.
9. Advertising upgrade: select package and dates, enter offer and restrictions, accept Advertising Terms, complete payment through hosted provider, verify webhook server-side, then branch approval and publication.
10. Notify owner of approval, rejection, payment status and upcoming renewal.

## Invitation QR and outreach
A printable and shareable invitation links to a dedicated business sign-up page, not directly to payment.
Track invite source, branch and conversion; do not expose contact details in the QR token.
Offer referral attribution to representatives and existing participating businesses.
Allow sharing by website, social channels, printed invitations, partner networks, trade associations, events and lawful opted-in email campaigns.
Never purchase/scrape 500,000 contacts and assume bulk unsolicited marketing is permitted.
South Africa: POPIA section 69 generally requires prior consent for unsolicited electronic direct marketing to prospective recipients, with a limited one-time consent-request mechanism subject to prescribed requirements. Document source, consent scope, proof and withdrawal; maintain suppression lists.
Scale gradually after consent, deliverability, security, legal and support checks. Email sender identity, unsubscribe, SPF, DKIM and DMARC required.

## Global vs branch permissions
Branch manager sees pending/approved applications in assigned branch only.
Global Head Office sees international totals and can review escalations.
Applicant sees only their own application; public sees only approved published business data.
Private contact information never copied into public listing without express publishing choices.
No direct public writes to existing businesses, promotions or advertisements.

## Data and services to implement
- gogo_business_applications (private submissions, assigned location, status, owner)
- gogo_business_terms_versions and gogo_terms_acceptances
- gogo_invitation_campaigns and aggregate invitation events
- gogo_outreach_consents and suppression lists
- business verification and duplicate review
- checkout orders, server-verified payments, refunds and financial reconciliation
- audit trail, abuse controls, customer support and complaints
- authenticated applicant portal and manager review
- QR invitation landing page and print-ready artwork

## Launch sequence
1. Verify/register domain and connect public homepage without replacing live map Version 8.
2. Publish draft legal documents after country-specific legal review.
3. Build secure free business registration, verification and branch approval.
4. Launch self-service paid advertising and verified payment webhooks.
5. Create invitation QR artwork and lawful outreach campaign tools.
6. Pilot with small groups, measure applications and support load, then expand.

## Safeguards
Keep existing BAT customer codes, live map, legacy business manager and current records unchanged.
Do not send emails, create real customers or accept payments until explicitly configured and tested.
