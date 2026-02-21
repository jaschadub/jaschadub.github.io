---
title: Your Dark Factory Needs a Security Perimeter
date: 2026-02-20
tags:
  - ai
  - security
  - agents
  - enterprise
---

# Your Dark Factory Needs a Security Perimeter

*Posted on February 20, 2026*

Software is about to be built the way cars are: in factories that run with the lights off.

The idea comes from manufacturing. FANUC runs a robotics plant in Japan where machines build other machines for 30 days straight, no human on the floor. Xiaomi produces ten million smartphones a year in a facility that's 96% autonomous. The concept is simple — if you can define the inputs and validate the outputs, you don't need people in the middle.

Now the same logic is arriving in software development. And it's arriving fast.

![Dark Factory](../img/dark-factory.png)

## What a dark factory actually looks like

Dan Shapiro <a href="https://www.danshapiro.com/blog/2026/01/the-five-levels-from-spicy-autocomplete-to-the-software-factory/" target="_blank">published</a> a framework in January that maps the journey from "AI autocomplete" to fully autonomous software production across five levels. Most developers today sit at Level 2 or 3 — pair-programming with AI, reviewing diffs, staying firmly in the loop. Level 5, what Shapiro calls "the dark factory," is the end state: AI agents write the code, test the code, and ship the code. Nobody reviews it. Ever.

That sounds theoretical until you look at what StrongDM built. In July 2025, three engineers — Justin McCarthy, Jay Taylor, and Navan Chauhan — formed a team with two rules. First, code must not be written by humans. Second, code must not be reviewed by humans. They weren't experimenting. They shipped a product called Attractor under those constraints, and the entire specification is public on GitHub. There's no source code in the repository. Just three markdown files containing roughly 5,700 lines of natural language specification. You feed the spec to a coding agent and it builds the software.

Meanwhile, Anthropic reports that 90% of Claude Code's own codebase was written by Claude Code. Some internal teams are operating with workflows that approach 100% AI-generated implementation.

This is not a five-year prediction. It's happening now.

## The trust question nobody is answering well

Here's where it gets interesting — and a bit uncomfortable.

Stanford's CodeX lab <a href="https://law.stanford.edu/2026/02/08/built-by-agents-tested-by-agents-trusted-by-whom/" target="_blank">published an analysis</a> last month with a pointed observation: a team building security infrastructure has decided that human code review is an obstacle, not a safeguard. That's a strong architectural bet. It might be right. But it raises a question that the current generation of dark factories hasn't fully answered: if nobody reviews the code, what exactly is keeping things safe?

StrongDM's answer is clever. They use something called "scenario holdouts" — test scenarios stored separately from the codebase so the coding agents can't see them. The agents write code, then a separate validation process runs those hidden scenarios against the output and measures "satisfaction," a continuous score representing how well the software actually behaves. It's not pass/fail. It's a percentage of behavioral trajectories that meet the spec.

They also built digital twins — behavioral clones of third-party services like Okta, Jira, and Slack — so agents can test against realistic simulations without touching production systems.

It's smart design. But the Attractor specification itself says something revealing about its own sandboxing: it's a "safety default, not a security boundary." The team is explicit that their file-system-level isolation is convention, not enforcement. An agent with shell access could, in theory, walk right past it.

For a startup iterating on internal tools, that trade-off might be perfectly reasonable. For a hospital deploying software that touches patient records, or a bank building systems that move money, "safety default" isn't going to cut it.

## The gap between convention and enforcement

This is the core tension in the dark factory conversation right now. The teams pioneering autonomous software development are brilliant at the *generation* problem — getting agents to produce correct code through iterative refinement and sophisticated validation. But the *governance* problem is largely being solved with conventions rather than controls.

Think about what a dark factory actually requires from a security perspective. You need agents that can only access what they're supposed to access. The coding agent shouldn't be able to read the test scenarios. The testing agent shouldn't be able to modify the code. No agent should be able to access production secrets. And you need to be able to prove all of this to an auditor after the fact.

In traditional software development, humans fill these roles informally. A senior engineer catches a security issue in code review. A team lead notices that someone accessed a system they shouldn't have. The process is slow and imperfect, but there are humans in the loop making judgment calls.

When you remove the humans, you don't remove the need for those controls. You just need to implement them differently — as infrastructure rather than process.

## What enterprise-grade dark factory infrastructure looks like

The pieces you'd need aren't mysterious. They're the same things enterprises require for any mission-critical system, adapted for a world where agents are the workers instead of people.

**Identity for agents, not just humans.** If an agent writes code and ships it to production, you need cryptographic proof of which agent did what, under whose authority, and when. Not application-level logging. Signed, verifiable identity with a delegation chain from the organization that built the agent to the organization that deployed it.

**Tool integrity verification.** Dark factory agents select and invoke tools — compilers, linters, deployment scripts, API clients — without human oversight. If a tool's schema gets swapped out (the kind of supply chain attack the security community calls a "rug pull"), an agent will happily use the compromised version. You need cryptographic verification that the tools your agents use are the tools you approved.

**Policy enforcement, not policy documentation.** Holdout isolation shouldn't depend on whether an agent happens to stay in its designated directory. It should be enforced at the runtime level, with declarative rules that deny access regardless of what the agent tries. The validator can read the holdouts. The builder cannot. Period. Not because of a charter document, but because the infrastructure won't allow it.

**Real sandboxing with real boundaries.** Convention-based file system separation is fine for development. Production dark factories need container-level isolation at minimum — agents running in environments where sensitive resources simply don't exist in their filesystem namespace. For the most sensitive workloads, you want hardware-level isolation.

**Tamper-evident audit trails.** When a regulator asks how a particular piece of software was built, you need to produce a chain of evidence from specification to shipped artifact. Not log files. Cryptographically signed audit events that can't be modified after the fact.

## Why this matters right now

The economics of dark factories are brutal and compelling. StrongDM's CTO offers a benchmark: if you're spending less than a thousand dollars a day on tokens per human engineer, your software factory has room for improvement. That's not cheap in absolute terms — a three-person team at that rate burns over a million dollars a year in tokens alone, before salaries. But the math only makes sense when you look at the output side. StrongDM's three-engineer team, formed in July 2025, shipped a product in months that would traditionally require a team several times larger. The cost per unit of working software is collapsing even as the total token bill grows.

The capability gap is closing too. When Claude 3.5 Sonnet shipped its second revision in October 2024, something shifted. Long-horizon agentic coding started compounding correctness instead of errors. By December 2024 it was unmistakable. By mid-2025 teams were forming around the pattern. By early 2026 it's becoming almost conventional among frontier engineering organizations.

But here's the thing — the enterprises that most want these economics are exactly the ones that can't adopt them without serious governance infrastructure. Banks, hospitals, defense contractors, and government agencies don't get to move fast and break things. They operate under HIPAA, SOX, FedRAMP, and GDPR. They need to demonstrate controls to auditors and regulators. They need to prove that their software development process is trustworthy even when that process is fully autonomous.

The dark factory pattern creates a new category of infrastructure requirement. Not AI safety in the alignment sense. Not DevSecOps in the traditional sense. Something specific to a world where agents build software and humans design the systems that verify it works.

## The design principle that makes it work

The most important insight, and the one I keep coming back to, is that enterprise dark factories need the same agents running in a safe runtime — not different, weaker agents that are inherently limited.

Every time someone proposes solving the dark factory trust problem by restricting what agents can do, they're undermining the value proposition. The whole point is that agents are powerful enough to build real software. The answer isn't to make them less capable. It's to put them in an environment where policy is enforced by infrastructure, identity is cryptographic, tools are verified, and every action is auditable.

*<a href="https://github.com/ThirdKeyAI/Symbiont" target="_blank">Same agent. Safe runtime.</a>* That's the design principle.

The dark factory is coming whether the security infrastructure is ready or not. The teams building these systems today are moving fast and making reasonable trade-offs for their context. But as the pattern spreads to regulated industries — and the economics guarantee that it will — the distance between "safety default" and "security boundary" is going to matter enormously.

The factories are going dark. The question is whether anyone is watching the perimeter.

---

*Jascha Wanger is the founder of ThirdKey AI, building trust infrastructure for enterprise AI agents. More at [symbiont.dev](https://symbiont.dev), [agentpin.org](https://agentpin.org), and [schemapin.org](https://schemapin.org).*
