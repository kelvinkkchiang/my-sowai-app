# Security

## Secret Handling
- `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `SUPABASE_SERVICE_ROLE_KEY` — server-side only, never in `NEXT_PUBLIC_*` env vars
- Only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` exposed to browser
- Stripe Checkout session created server-side; client receives only the session URL

## Permission Model (v1 → lock-down)
- **v1 (demo):** Permissive RLS — all reads and writes open for demo visibility
- **Lock-down sprint:** RLS policies replaced with `auth.uid() = user_id`; unauthenticated writes blocked; service-role key used only in server-side API routes
- Subscription status checked server-side before generating reports or serving PDFs

## Approved-Tools Rule
- Agents may only call explicitly named tools (`generate_sow_draft`, `score_plausibility`, `export_pdf`, `create_checkout_session`)
- No `eval`, `run_any`, or dynamic code execution
- Stripe webhook validated via signature (`stripe.webhooks.constructEvent`) before any DB write

## Audit Principle
- Every meaningful action writes an `audit_logs` row: who, what object, what outcome, when
- Audit logs are append-only — no update or delete policy on `audit_logs`
- PDF exports logged with exported_at timestamp on the report row