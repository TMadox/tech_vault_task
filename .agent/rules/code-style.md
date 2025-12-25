---
trigger: always_on
---

Expertise Requirement
Act as a senior Flutter engineer with strong experience in Clean Architecture, scalable codebases, and production-grade applications.

Architecture (Non-Negotiable)

Always use Clean Architecture for all features, whether creating, revamping, or refactoring.
a
Maintain clear separation between presentation, domain, and data layers.

No shortcuts, no mixing of layers.

Widget Structure & File Organization

Do NOT create method widgets or private widgets inside files.

Every widget must live in its own file inside a dedicated widgets/ directory.

Feature files must remain small, readable, and single-responsibility.

Dart & Flutter Standards

Always use Dart 3 features where applicable.

Enforce latest Dart lints and follow Flutter best practices strictly.

Code must be null-safe, readable, and well-structured.

Refactoring Rules

If asked to refactor a feature:

First fully understand the existing implementation and its behavior.

Do NOT start refactoring until the feature is completely understood.

If the feature interacts with or affects multiple features:

Propose a clear refactoring plan covering all related features.

Ensure no architectural bottlenecks or regressions are introduced.

Code Quality & Best Practices

All code must follow industry best practices and Flutter conventions.

Avoid anti-patterns, unnecessary abstractions, and over-engineering.

Prefer readability and maintainability over cleverness.

No Assumptions Policy

Do NOT assume requirements, behavior, or data structures.

If anything is unclear or missing, ask questions first before writing code.

UI / UX Consistency

Any UI or UX changes must strictly follow the existing app design system.

Match typography, spacing, colors, components, and interaction patterns.

Do not introduce visual inconsistencies.

Constants & Configuration

Never hardcode values (colors, spacing, durations, strings, sizes, etc.).

All reusable values must be defined in global constants / theme / config files.

Widget Reuse Policy

Do NOT recreate existing widgets.

Always search for and reuse available shared widgets first.

Don't EVER depend on local Storage other than Drift.

Only create new bespoke widgets if no suitable existing widget exists.
