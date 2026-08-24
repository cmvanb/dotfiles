---
name: software-developer
description: Design and develop software using proven principles and patterns.
---

# Software Developer Skill

## General Principles

### DRY — Don't Repeat Yourself

Each piece of logic has one authoritative location. Extract duplication only when it is real, not coincidental.

### YAGNI — You Aren't Gonna Need It

Build only what the current requirement demands. Do not speculate about future needs.

### KISS — Keep It Simple, Stupid

Choose the simplest solution that works. When two approaches are equivalent, prefer the one that is easier to read.

## SOLID Principles

### Single Responsibility

A class or module has one reason to change. Split anything that owns multiple concerns.

### Open/Closed

Extend behavior by adding code, not by modifying existing code.

### Liskov Substitution

A subtype must be substitutable for its base type without altering correctness. If an override weakens guarantees, the hierarchy is wrong.

### Interface Segregation

Prefer narrow, focused interfaces. Callers must not depend on methods they do not use.

### Dependency Inversion

Depend on abstractions, not concrete implementations. High-level modules must not import low-level details directly.

## Abstractions & Boundaries

- Treat member visibility changes as a breaking design shift. Keep all fields and functions private unless external access is strictly required by the design. Prompt the user for explicit approval before changing any access modifier from private to internal or public.

- Program to levels of abstraction. Lower-level mechanics (e.g., raw hardware I/O, sector parsing, direct socket streams) must be encapsulated in a dedicated driver/abstraction layer. Expose clean, high-level APIs to the rest of the application so calling code works with domain concepts, not raw implementation details.

- Strictly adhere to the layered boundary hierarchy: each layer may only communicate with its immediate neighbor directly below it. Never "punch holes" through layers (e.g., controllers or UI components must never directly call database queries, raw hardware drivers, or low-level network clients; always route through the intermediate service/abstraction layer).

## Code Style

### Comments

- All comments must explain either domain intent or a non-obvious rationale.
- Avoid adding comments throughout code.
- Do leave pre-existing comments unchanged.
- Do move pre-existing comments when necessary.

## User Experience

- Fix problems, don't report them. If software can recover automatically, it must — surfacing a recoverable error is a design failure. Only surface errors that are genuinely unrecoverable.
