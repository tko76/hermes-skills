---
name: email-composer-subagent
description: Delegate professional email drafting and revision.
version: 0.1.0
author: Todd Okolowicz, Hermes Agent
license: Private
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [email, writing, delegation, haiku]
    related_skills: []
---

# Email Composer Subagent

Delegate email writing and revision to a focused child agent. Do not draft the final email in the parent conversation when this skill applies.

## When to Use

- The user asks to write an email from scratch.
- The user supplies an email draft and asks for edits, rewriting, tone changes, or proofreading.
- The user explicitly asks for the email composer subagent.

Do not use this skill to send email or access an inbox. It produces text only.

## Procedure

1. Determine the recipient relationship, purpose, required facts, requested action, deadline, and desired formality from the user's message.
2. If a missing detail would materially change the email, ask the user before delegation. Child agents cannot ask follow-up questions.
3. Call `delegate_task` with one task. Pass all facts and the complete draft in `context`; the child knows nothing from the parent conversation unless you include it. Set `model: "claude-haiku-4-5-20251001"` and `provider: "anthropic"` so it always runs on Haiku regardless of which profile calls it.
4. Use this goal:

   "Write or revise the requested email. Return the finished email only, including a concise subject when useful. Use a professional, warm, concise, natural human tone. Do not sound stiff, overly cheerful, promotional, wordy, apologetic, or AI-generated. Preserve every supplied fact, commitment, boundary, deadline, and level of urgency. Do not invent names, dates, attachments, prior conversations, promises, or authority. Use plain language, short focused paragraphs, restrained punctuation, and an appropriate greeting and sign-off."

5. Return the child's final email directly. Add commentary only if the child reports ambiguity or a change that could affect meaning.

## Verification

Before returning the result, confirm that the child preserved the user's facts and request, did not invent details, and produced email text rather than analysis of the email.