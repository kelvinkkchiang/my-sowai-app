create table if not exists subjects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  full_name text not null,
  date_of_birth date,
  nationality text,
  occupation text,
  wealth_narrative text,
  estimated_wealth_usd numeric,
  created_at timestamptz not null default now()
);
alter table subjects enable row level security;
drop policy if exists "subjects_v1_read" on subjects;
create policy "subjects_v1_read" on subjects for select using (true);
drop policy if exists "subjects_v1_write" on subjects;
create policy "subjects_v1_write" on subjects for all using (true) with check (true);

create table if not exists screening_results (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  subject_id uuid,
  screening_type text not null,
  provider text,
  raw_input text,
  result_summary text,
  result_summary_source text,
  result_summary_confidence numeric,
  result_summary_review_status text default 'unreviewed',
  hit_count integer default 0,
  risk_level text default 'unknown',
  notes text,
  created_at timestamptz not null default now()
);
alter table screening_results enable row level security;
drop policy if exists "screening_results_v1_read" on screening_results;
create policy "screening_results_v1_read" on screening_results for select using (true);
drop policy if exists "screening_results_v1_write" on screening_results;
create policy "screening_results_v1_write" on screening_results for all using (true) with check (true);

create table if not exists assessments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  subject_id uuid,
  wealth_sources jsonb,
  documented_amount_usd numeric,
  undocumented_amount_usd numeric,
  documentation_checklist jsonb,
  plausibility_score numeric,
  plausibility_score_source text,
  plausibility_score_confidence numeric,
  plausibility_score_review_status text default 'unreviewed',
  overall_risk_rating text,
  assessor_notes text,
  created_at timestamptz not null default now()
);
alter table assessments enable row level security;
drop policy if exists "assessments_v1_read" on assessments;
create policy "assessments_v1_read" on assessments for select using (true);
drop policy if exists "assessments_v1_write" on assessments;
create policy "assessments_v1_write" on assessments for all using (true) with check (true);

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  subject_id uuid,
  assessment_id uuid,
  title text,
  ai_draft text,
  ai_draft_source text,
  ai_draft_confidence numeric,
  ai_draft_review_status text default 'unreviewed',
  final_content text,
  status text default 'draft',
  exported_at timestamptz,
  created_at timestamptz not null default now()
);
alter table reports enable row level security;
drop policy if exists "reports_v1_read" on reports;
create policy "reports_v1_read" on reports for select using (true);
drop policy if exists "reports_v1_write" on reports;
create policy "reports_v1_write" on reports for all using (true) with check (true);

create table if not exists report_counts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  period_month text,
  count integer default 0,
  created_at timestamptz not null default now()
);
alter table report_counts enable row level security;
drop policy if exists "report_counts_v1_read" on report_counts;
create policy "report_counts_v1_read" on report_counts for select using (true);
drop policy if exists "report_counts_v1_write" on report_counts;
create policy "report_counts_v1_write" on report_counts for all using (true) with check (true);

create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  stripe_customer_id text,
  stripe_subscription_id text,
  plan_name text default 'professional',
  status text default 'inactive',
  current_period_end timestamptz,
  created_at timestamptz not null default now()
);
alter table subscriptions enable row level security;
drop policy if exists "subscriptions_v1_read" on subscriptions;
create policy "subscriptions_v1_read" on subscriptions for select using (true);
drop policy if exists "subscriptions_v1_write" on subscriptions;
create policy "subscriptions_v1_write" on subscriptions for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  action text not null,
  object_type text,
  object_id uuid,
  metadata jsonb,
  created_at timestamptz not null default now()
);
alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into subjects (id, full_name, date_of_birth, nationality, occupation, wealth_narrative, estimated_wealth_usd) values
  ('a1000000-0000-0000-0000-000000000001', 'Alexandre Fontaine', '1965-03-14', 'French', 'Founder & CEO, Fontaine Industrie SAS', 'Primary wealth derived from sale of majority stake in Fontaine Industrie SAS to Carlyle Group in 2019. Secondary income from board directorships and real estate portfolio in Paris and Monaco.', 42000000),
  ('a1000000-0000-0000-0000-000000000002', 'Priya Nair Menon', '1978-11-02', 'Indian', 'Managing Director, Meridian Capital Partners', 'Accumulated wealth through carried interest from three private equity funds managed over 14 years. Supplemented by inheritance from estate of late father (industrialist, Mumbai).', 18500000),
  ('a1000000-0000-0000-0000-000000000003', 'Lars-Erik Thorvaldsen', '1952-07-29', 'Norwegian', 'Retired — Former COO, NordOil AS', 'Wealth sourced from NordOil AS stock option programme vested between 2001–2015, pension fund payouts, and sale of family-owned salmon farming business in 2018.', 31000000);

insert into screening_results (subject_id, screening_type, provider, result_summary, result_summary_source, result_summary_confidence, result_summary_review_status, hit_count, risk_level) values
  ('a1000000-0000-0000-0000-000000000001', 'PEP/Sanctions', 'Manual', 'No PEP or sanctions matches identified. One name-alike found (Alexandre Fontaine, Belgian national, DOB mismatch). Resolved as non-match.', 'analyst', 0.95, 'reviewed', 1, 'low'),
  ('a1000000-0000-0000-0000-000000000001', 'Adverse Media', 'Manual', 'No adverse media found. Single 2021 article references Fontaine Industrie in context of Carlyle acquisition — no negative allegations.', 'analyst', 0.92, 'reviewed', 0, 'low'),
  ('a1000000-0000-0000-0000-000000000002', 'PEP/Sanctions', 'Manual', 'No matches on PEP or consolidated sanctions lists. Clear result.', 'analyst', 0.98, 'reviewed', 0, 'low');

insert into assessments (subject_id, wealth_sources, documented_amount_usd, undocumented_amount_usd, plausibility_score, plausibility_score_source, plausibility_score_confidence, plausibility_score_review_status, overall_risk_rating, assessor_notes) values
  ('a1000000-0000-0000-0000-000000000001', '["Business sale proceeds","Directorship fees","Real estate"]', 38000000, 4000000, 78, 'rule_engine', 0.80, 'reviewed', 'medium-low', 'Proceeds from Carlyle deal independently corroborated via press release and notarised sale agreement. Real estate valuations pending third-party appraisal.');

insert into reports (subject_id, assessment_id, title, ai_draft, ai_draft_source, ai_draft_confidence, ai_draft_review_status, final_content, status) values
  ('a1000000-0000-0000-0000-000000000001', (select id from assessments where subject_id = 'a1000000-0000-0000-0000-000000000001' limit 1), 'Source of Wealth Report — Alexandre Fontaine', 'DRAFT — Source of Wealth Assessment\n\nClient: Alexandre Fontaine\nDate: 2024-06-01\n\n1. Executive Summary\nMr. Fontaine''s declared net wealth of USD 42 million is considered plausible and substantially documented. The primary wealth event — sale of Fontaine Industrie SAS — is corroborated by publicly available records and client-provided legal documentation.\n\n2. Screening Results\nNo PEP, sanctions, or adverse media concerns identified. One name-alike resolved as non-match.\n\n3. Wealth Sources\n- Business sale: USD 38M (documented via notarised sale agreement)\n- Directorship fees & real estate: USD 4M (partially documented)\n\n4. Plausibility Assessment\nWealth sources are consistent with client''s stated professional background and timeline. Risk rating: Medium-Low.\n\n5. Conclusion\nBased on the information reviewed, the source of wealth is considered plausible and the client''s profile is suitable for onboarding subject to receipt of outstanding real estate appraisals.', 'openai/gpt-4o', 0.85, 'unreviewed', null, 'draft');

insert into report_counts (user_id, period_month, count) values
  (null, '2024-06', 1);