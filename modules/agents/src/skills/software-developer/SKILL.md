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

## SOLID

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

## Code Style

### Comments

- All comments must explain either domain intent or a non-obvious rationale.
- Avoid adding comments throughout code.
- Do leave pre-existing comments unchanged.
- Do move pre-existing comments when necessary.

## User Experience

- Fix problems, don't report them. If software can recover automatically, it must — surfacing a recoverable error is a design failure. Only surface errors that are genuinely unrecoverable.
