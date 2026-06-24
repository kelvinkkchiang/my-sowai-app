# Agentic Layer

## Risk Levels & Actions

### Low — Auto-execute (no approval needed)
- **generate_sow_draft:** Send subject + screening + assessment to OpenAI; store ai_draft + confidence + review_status = unreviewed
- **summarise_screening:** Condense raw screening notes into structured result_summary
- **score_plausibility:** Apply rule-based scoring; write plausibility_score to assessments

### Medium — Light approval (banker confirms before writing)
- **update_report_status:** Change report status from draft → finalised (one-click confirm)
- **flag_high_risk:** Mark subject risk_level as high; adds note to audit_log

### High — Always requires explicit approval
- **export_pdf:** Generate and deliver PDF — banker clicks "Export & Download"
- **initiate_stripe_checkout:** Open Stripe Checkout session (server-side) — triggered by banker clicking "Subscribe"

### Critical — Human-only (no agent autonomy)
- **delete_subject:** Permanent deletion of subject and all linked records
- **issue_refund:** Any Stripe refund action
- **override_risk_rating:** Manual override of AI-assigned risk rating (requires written justification stored in audit_log)

## Named Tools (v1)
- `generate_sow_draft` — OpenAI GPT-4o via `/api/ai/generate-draft`
- `score_plausibility` — deterministic rule engine in `/lib/scoring.ts`
- `export_pdf` — server-side renderer at `/api/reports/export`
- `create_checkout_session` — Stripe SDK at `/api/stripe/checkout`
- `handle_stripe_webhook` — Stripe webhook at `/api/stripe/webhook`

## Audit Log Fields
`action | object_type | object_id | user_id | metadata (input snapshot, confidence, outcome) | created_at`

## v1 vs Later
- **v1:** generate_sow_draft, score_plausibility, export_pdf, Stripe checkout
- **Later:** automated screening API calls, compliance officer approval queue, multi-step re-screening trigger