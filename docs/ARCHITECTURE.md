# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + Auth:** Supabase (Postgres + RLS + Storage for PDFs)
- **AI:** OpenAI GPT-4o via server-side API route
- **Payments:** Stripe Checkout + Webhooks
- **PDF:** `react-pdf` or `puppeteer` server-side render

## Now vs Later
**Now:** subject intake → screening panels → assessment form → AI SOW draft → edit → PDF export → Stripe payment
**Later:** auth/RLS lock-down, team workspaces, screening API integrations, ML scoring

## Key User Action — Step-by-Step
1. Banker fills subject intake form → row written to `subjects`
2. Banker enters screening findings → rows written to `screening_results`
3. Banker completes plausibility form → row written to `assessments`
4. Server calls OpenAI with subject + screening + assessment context → AI draft returned
5. Draft stored in `reports` (ai_draft + source + confidence + review_status = unreviewed)
6. Banker edits draft in-app → `reports.final_content` updated, status → `finalised`
7. PDF generated server-side → delivered to browser
8. `report_counts` incremented; `audit_logs` entry written
9. Stripe Checkout session opened → payment captured → subscription activated via webhook

## Layer Plan
1. **Data layer first** — all tables, RLS, seed data
2. **App logic** — forms, CRUD, report engine, PDF, Stripe
3. **Smart layer** — AI draft generation, confidence scoring, future ML

## Core Without AI
If OpenAI is unavailable, the banker receives a blank editable report template pre-populated with subject and screening data — no functionality is blocked.