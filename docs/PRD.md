# PRD — my-sowai-app

## Problem
Private and premium bankers must perform AML/KYC Source of Wealth (SOW) assessments for high-net-worth onboarding. The process — name/PEP screening, adverse media review, plausibility scoring, and written report — is manual, time-consuming, and inconsistently documented. Non-compliance carries regulatory and reputational risk.

## Target User
Private bankers and KYC analysts at private banks and wealth management firms performing ACIP-aligned SOW assessments.

## Core Objects
- **Subject** — the individual being screened
- **Screening Result** — PEP/sanctions and adverse media findings per subject
- **Assessment** — plausibility scoring and wealth-source breakdown
- **Report** — AI-drafted + banker-edited SOW document (PDF exportable)
- **Report Count** — usage metric per user per month
- **Subscription** — Stripe-linked paid access status

## MVP Must-Haves
- [ ] Subject intake form (name, DOB, nationality, occupation, wealth narrative)
- [ ] Name screening panel with manual result entry
- [ ] Adverse media screening panel with manual result entry
- [ ] Plausibility assessment form with wealth-source breakdown
- [ ] AI-drafted SOW report (ACIP-aligned, editable by banker)
- [ ] PDF export of finalised report
- [ ] Report count dashboard
- [ ] Stripe checkout — monthly subscription gates report generation
- [ ] Demo mode: full app viewable without login

## Non-Goals (v1)
- ML scoring model
- Direct API feed to Refinitiv / Dow Jones
- Multi-user team workspaces
- Compliance officer approval workflow
- Bulk CSV import

## Success Criteria
A banker visits the app, enters a new subject's details, runs screening panels, completes the plausibility assessment, receives an AI-drafted SOW report, edits and exports it as PDF, and pays via Stripe — all in a single session. Report count increments by 1.