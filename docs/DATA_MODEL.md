# Data Model

## subjects
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | owner, set at lock-down |
| full_name | text | |
| date_of_birth | date | |
| nationality | text | |
| occupation | text | |
| wealth_narrative | text | free-text from banker |
| estimated_wealth_usd | numeric | |
| created_at | timestamptz | |

## screening_results
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| subject_id | uuid | FK → subjects |
| screening_type | text | `PEP/Sanctions` \| `Adverse Media` |
| provider | text | e.g. Manual, Refinitiv |
| raw_input | text | search terms used |
| result_summary | text | **AI field** |
| result_summary_source | text | |
| result_summary_confidence | numeric | |
| result_summary_review_status | text | default `unreviewed` |
| hit_count | integer | |
| risk_level | text | low / medium / high |
| notes | text | |

## assessments
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| subject_id | uuid | FK → subjects |
| wealth_sources | jsonb | array of source labels |
| documented_amount_usd | numeric | |
| undocumented_amount_usd | numeric | |
| documentation_checklist | jsonb | |
| plausibility_score | numeric | **AI field** 0–100 |
| plausibility_score_source | text | |
| plausibility_score_confidence | numeric | |
| plausibility_score_review_status | text | |
| overall_risk_rating | text | |
| assessor_notes | text | |

## reports
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| subject_id | uuid | FK → subjects |
| assessment_id | uuid | FK → assessments |
| title | text | |
| ai_draft | text | **AI field** |
| ai_draft_source | text | e.g. openai/gpt-4o |
| ai_draft_confidence | numeric | |
| ai_draft_review_status | text | default `unreviewed` |
| final_content | text | banker-edited version |
| status | text | draft / finalised / exported |
| exported_at | timestamptz | |

## report_counts
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| period_month | text | YYYY-MM |
| count | integer | |

## subscriptions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| stripe_customer_id | text | |
| stripe_subscription_id | text | |
| plan_name | text | |
| status | text | active / inactive / past_due |
| current_period_end | timestamptz | |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| action | text | e.g. report.created |
| object_type | text | |
| object_id | uuid | |
| metadata | jsonb | |

**RLS:** All tables have permissive v1 policies (select/all = true). At lock-down sprint, replaced with `auth.uid() = user_id`.