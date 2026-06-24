# Intelligence Layer

## Messy Inputs
- Banker's free-text wealth narrative (unstructured)
- Manual screening notes with mixed terminology
- Inconsistent wealth-source categorisation across bankers

## Auto-Structure Schema (per report generation call)
```json
{
  "subject": {
    "full_name": "Alexandre Fontaine",
    "nationality": "French",
    "occupation": "Founder & CEO",
    "estimated_wealth_usd": 42000000,
    "wealth_narrative": "..."
  },
  "screening": [
    { "type": "PEP/Sanctions", "risk_level": "low", "hit_count": 1, "summary": "..." },
    { "type": "Adverse Media", "risk_level": "low", "hit_count": 0, "summary": "..." }
  ],
  "assessment": {
    "wealth_sources": ["Business sale", "Directorships"],
    "documented_amount_usd": 38000000,
    "plausibility_score": 78,
    "overall_risk_rating": "medium-low"
  }
}
```

## Events to Track
- Subject created
- Screening result saved
- Assessment completed
- AI draft generated (with latency + confidence)
- Report finalised and exported
- Subscription activated

## Scoring Rules (v1 — rule-based)
- Documented % ≥ 90% → +30 pts
- No PEP/sanctions hits → +25 pts
- No adverse media → +20 pts
- Wealth narrative consistent with occupation → +15 pts (AI-assessed)
- Undocumented gap > 20% → −20 pts
- Any high risk_level screening hit → −30 pts
- Score 0–100; stored as `plausibility_score`

## What Gets Ranked
- Reports by risk rating (surfaced on dashboard)
- Screening hits by severity

## v1 vs Later
- **v1:** Rule-based plausibility score + GPT-4o SOW draft
- **Later:** ML model trained on banker-approved reports; automated screening API confidence scoring