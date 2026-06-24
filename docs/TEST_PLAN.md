# Test Plan

## v1 Success Scenario (manual walkthrough)
1. Open app homepage — 3 demo subjects visible, no login required
2. Click **New Subject** — fill all fields (name, DOB, nationality, occupation, wealth narrative, estimated wealth) → Submit → redirected to subject page; row exists in `subjects` table
3. Navigate to **Screening** tab — enter PEP/Sanctions result (hit_count, risk_level, notes) → Save → row in `screening_results`; repeat for Adverse Media
4. Navigate to **Assessment** tab — select wealth sources, enter amounts, complete checklist → Submit → row in `assessments`; `plausibility_score` populated
5. Click **Generate SOW Report** — loading state shown; AI draft appears in editor within 15 s; `reports` row created with `ai_draft_review_status = unreviewed`
6. Edit draft text inline → Click **Finalise** → `status = finalised`
7. Click **Export PDF** → PDF downloads; `exported_at` set; `report_counts.count` incremented by 1
8. Navigate to `/pricing` → Click **Subscribe** → Stripe Checkout opens → complete with test card `4242 4242 4242 4242` → redirected to `/payment/success`
9. Check `subscriptions` table — `status = active`

## Empty State Tests
- New account with no subjects → `/subjects` shows "No subjects yet. Add your first subject."
- Subject with no screening results → Screening panel shows "No screening results recorded yet."
- Report generation with no assessment → Button disabled with tooltip "Complete assessment first"

## Error / Edge Case Tests
- OpenAI timeout (mock 30 s delay) → fallback template rendered; no crash
- Stripe webhook with invalid signature → 400 returned; no DB write
- Submit intake form with missing required fields → inline validation messages; no DB write
- Attempt second report generation without subscription → upgrade prompt shown; no OpenAI call made
- Navigate to `/reports/[non-existent-id]` → 404 page rendered cleanly