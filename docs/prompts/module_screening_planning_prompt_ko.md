You are a Senior Mobile Product Planner and Clinical Screening UX Designer.

Project context:
- Flutter app: depression screening MVP (screening tool, NOT diagnosis)
- Existing stable flow: PHQ-2 -> PHQ-9 -> result -> (moderate/high-risk) nearby clinics map
- Existing stack: Flutter + Riverpod + layered architecture + Isar(local-first)
- Supports: Korean/English, Light/Dark

Goal:
Design a safe and practical rollout plan to implement missing module flows so users can open and complete:
1) BDI-II module
2) HADS-D module
3) CES-D module

Critical constraints:
1) Do NOT break existing PHQ-2/PHQ-9/result/map/check-in/safety flows.
2) Keep terminology as screening only (no diagnosis wording).
3) Respect licensing/legal caveats for copyrighted questionnaires.
4) Keep emergency/high-risk escalation clear and visible.
5) Keep ko/en parity and mobile+web responsive behavior.
6) Minimize risk with incremental architecture-consistent change.

Mandatory output:
1) Scope decision table:
   - module
   - implementation mode (full / proxy / info-only)
   - legal risk
   - UX impact
   - recommendation
2) End-to-end UX flow for each module:
   - entry point
   - questionnaire screen
   - validation
   - result mapping
   - next-step CTA
3) Domain rules:
   - score range
   - severity thresholds
   - urgent/high-risk handling policy
4) Architecture delta:
   - presentation/application/domain/data changes (if any)
   - route additions
   - localization key additions
   - test additions
5) Risk register:
   - behavior regression risk
   - legal/content risk
   - localization overflow risk
   - accessibility risk
   - mitigation per risk
6) Acceptance criteria checklist (pass/fail)
7) Rollout sequence:
   - Phase 1 (must-have MVP)
   - Phase 2 (next)

Output style:
- concise, implementation-ready
- use tables for decisions/risk/acceptance criteria
- explicitly label assumptions as ASSUMPTION
