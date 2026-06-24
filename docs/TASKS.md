# Tasks & Sprints

## Sprint 1 — DB, demo data, intake & screening UI
**Goal:** App renders with realistic demo data; banker can create a new subject and enter screening results.

- [ ] Apply migration SQL (all tables + seed data)
- [ ] Build `/subjects/new` intake form — persists to `subjects`
- [ ] Build `/subjects/[id]/screening` panel — persists to `screening_results`
- [ ] Subject list page `/subjects` — reads from DB, shows seeded demo rows
- [ ] All pages accessible without login
- [ ] Empty state on subject list when no rows exist

**DoD:** Seeded subjects visible on load; new subject form saves to DB; screening results save to DB; no login required.

---

## Sprint 2 — Assessment + AI SOW report engine ✅ v1 FUNCTIONAL MILESTONE
**Goal:** End-to-end: intake → screen → assess → AI draft → edit → export PDF.

- [ ] Build `/subjects/[id]/assessment` form — persists to `assessments`
- [ ] Rule-based plausibility scorer (`/lib/scoring.ts`) writes `plausibility_score`
- [ ] `/api/ai/generate-draft` — calls OpenAI, stores draft in `reports` with ai_draft + source + confidence + review_status
- [ ] Report editor page `/reports/[id]` — inline edit of `final_content`; status updates to `finalised`
- [ ] `/api/reports/export` — generates PDF server-side; sets `exported_at`
- [ ] `report_counts` incremented on report creation
- [ ] Dashboard `/` — shows report count, list of reports, risk ratings
- [ ] Audit log entries on report.created, report.exported
- [ ] Fallback: if OpenAI unavailable, serve blank template pre-filled with subject data

**DoD:** Full workflow from new subject to downloaded PDF works end-to-end against live DB. Success scenario from PRD is completable.

---

## Sprint 3 — Stripe paid tier
**Goal:** App charges for access from day one.

- [ ] Stripe product + monthly price created in Stripe dashboard
- [ ] `/pricing` page with plan details and CTA
- [ ] `/api/stripe/checkout` — creates Checkout session server-side; secret key never in frontend
- [ ] `/api/stripe/webhook` — validates signature; writes to `subscriptions` on success/cancellation
- [ ] Report generation gated: >1 report requires active subscription; shows upgrade prompt
- [ ] `/payment/success` and `/payment/cancel` pages

**DoD:** Full payment flow completable in Stripe test mode; subscription status written to DB; gating logic blocks free overuse.

---

## Sprint 4 — Auth + lock it down
**Goal:** Per-user data isolation; no cross-user data leakage.

- [ ] Supabase Auth: email/password sign-up + login pages
- [ ] `user_id` populated on all new rows post-login
- [ ] Replace permissive RLS policies with `auth.uid() = user_id` owner-scoped policies
- [ ] Subscription linked to `auth.uid()`
- [ ] Unauthenticated write attempts redirect to `/login`
- [ ] Seed demo rows remain readable (no user_id) for landing demo

**DoD:** Logged-in user sees only their own data; anonymous visitor sees only seeded demo rows.

---

## Sprint 5 — Polish & launch
**Goal:** Production-ready, fully tested.

- [ ] Empty states on all list views
- [ ] Error handling: AI timeout, Stripe failure, DB error
- [ ] Loading skeletons on async operations
- [ ] Copy review (banker-friendly language throughout)
- [ ] Full manual test pass per TEST_PLAN.md
- [ ] Environment variables documented in README

**DoD:** All TEST_PLAN.md steps pass; no console errors in production build.

---

## Gantt
```
Week 1:  Sprint 1 (DB + intake + screening)
Week 1:  Sprint 2 (assessment + AI report + PDF)  ← v1 functional
Week 2:  Sprint 3 (Stripe)
Week 2:  Sprint 4 (Auth + RLS lock-down)
Week 2:  Sprint 5 (Polish + launch)
```