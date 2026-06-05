---
title: "A Standard Is a Paradigm You Can't Take Back"
date: 2026-06-08
tags:
  - ai
  - security
  - agents
  - standards
---

# A standard is a paradigm you can't take back

*Posted on June 8, 2026*

An incomplete standard is a fixable thing. You ship v1.0, you track errata, you plan v2.0. Fine. The dangerous case is the standard that ships looking finished and effective when it is neither, because at that point it stops being a document and becomes a procurement checkbox. The checkbox travels faster than the nuance, and it travels into exactly the places that can least afford to be wrong: regulated buyers who read "conformant" as "safe."

A recently published runtime security specification for AI agents is a clean example. It carries the imprimatur of a well-known body, it has a registry of sixty-plus "builders" and a handful of mainly black-boxed products already badged conformant, and it reads like a mature category definition. It is also a near-perfect demonstration of how a standard can codify the wrong paradigm and then freeze the whole field around it.

## What it actually mandates

Strip the spec to its load-bearing requirements and you get this: intercept every agent action before execution, accumulate session context, evaluate the action against policy and against the agent's stated intent, return one of five decisions, and write a tamper-evident receipt bound to an agent identity. Six MUST requirements. Three SHOULD requirements on top, including drift tracking and least-privilege scoping.

The receipts and the identity binding are genuinely good. Tamper-evident records, cryptographically bound to a verifiable agent identity, are the right foundation for audit and non-repudiation. No complaint there. We build the same thing.

But audit is forensics. It tells you what happened after it happened. A standard whose enforceable core is "watch every action and keep good logs" is an observability standard wearing a security standard's clothes. And the rest of the mandatory core makes a bet that does not hold up.

## The bet is reactive, and it's baked into the non-negotiable requirement

The first and most emphatic requirement is interception: every action passes through a control plane before it executes, and this is described as non-negotiable. Read that closely. It assumes the dangerous action is fully expressible, gets constructed by the agent, and then gets caught in flight. That is deny-list thinking promoted to a MUST. You are racing the agent. You win when your evaluator is smarter than the attacker who shaped the agent's behavior, and you lose otherwise.

The alternative paradigm does not race anyone. You make the dangerous action structurally inexpressible. The agent holds a set of capabilities, and the set of actions it can even form is the set of safe actions. There is nothing to intercept because there is nothing to catch. A standard that mandates interception as the floor has quietly decided the industry should build the racing kind, not the constructive kind.

## Intent alignment puts the model back inside the trust boundary

One mandatory requirement is that policy evaluate each action for alignment with the agent's stated intent. The stated intent is an LLM-mediated artifact. It is set at the start of a session and it is exactly the thing prompt injection and goal hijacking corrupt. So the spec asks you to check actions against a compass that the same threats it names can spin. You cannot evaluate alignment against a poisoned reference and call the result a guarantee.

Evaluating the action itself against a fixed policy is fine. That is capability checking. Folding "alignment with stated intent" in as a co-equal MUST is where the model leaks back into the part of the system that was supposed to be independent of it. Policy has to live outside model influence or it is not policy, it is a suggestion the model gets a vote on.

## The priority ordering gives the game away

Least-privilege scoping, arguably the single most effective structural control in the whole document, is a SHOULD. Runtime interception is a MUST. Semantic drift detection, a probabilistic classifier that degrades under adversarial pressure, is in there as well, also optional.

So the thing closest to prevention is optional, and the thing that is reactive by construction is mandatory. That ordering is not an accident of drafting. It is the paradigm showing through.

## The coverage claim outruns the requirements

The spec names eleven threat classes and states that a conformant system must address all of them. Then it gives you six mandatory requirements that are mostly interception plus receipts. How does intercept-and-log structurally defend against side-channel leakage, or memory poisoning, or environmental manipulation? It does not, not in a way the requirements compel. The coverage is asserted, not demonstrated. A buyer reading "designed to defend against all known classes of attack" will not notice the gap between the marketing surface and the enforceable core. That gap is the entire danger.

It gets worse in the architecture section, which blesses SDK instrumentation that may not intercept non-instrumented paths, and vendor integration whose coverage depends on the vendor. Both contradict the non-negotiable "no action may bypass" requirement on the same page. You can ship a known bypass and still claim the requirement that forbids bypasses.

## Why this is worse than no standard

Conformance here is a self-assembled evidence package and a roughly two-week review. In regulated procurement that badge becomes a line item, and once it is a line item, every vendor optimizes to earn it. You get an industry of conformant-but-reactive products and a buyer population that believes the box is checked. False confidence in a safety-critical context is worse than acknowledged ignorance, because ignorance at least keeps people cautious.

And a standard does one more thing a whitepaper does not: it freezes a vocabulary. Once a respected body blesses a category, every better paradigm has to fight the incumbent definition before it can even be heard. Premature standardization of the reactive model does not just describe a local optimum. It ossifies one.

## What a standard should encode

If you are going to standardize agent security, standardize prevention, not interception. Make dangerous actions inexpressible rather than catchable. Keep the gate a structurally independent phase the model cannot influence. Push enforcement to construction time and make it verifiable, instead of leaning on a runtime evaluator guessing at intent. Keep the audit layer, it is good, but be honest that it is the record, not the lock.

That is the line we have taken with OATS. The point of this post is not the alternative spec. The point is the failure mode. The most dangerous specification is not the one that admits it is unfinished. It is the one that looks finished, gets adopted, and turns out to have standardized the thing we should have been trying to replace.
