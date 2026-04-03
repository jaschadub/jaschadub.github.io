---
title: "Clean Rooms, Dirty Pipes: PHALUS and the Supply Chain Paradox"
date: 2026-04-03
tags:
  - ai
  - security
  - open-source
  - supply-chain
---

# Clean Rooms, Dirty Pipes: PHALUS and the Supply Chain Paradox

*Posted on April 3, 2026*

![PHALUS](../img/phalus-sh.png)

In 1984, Phoenix Technologies hired a programmer with Texas Instruments TMS9900 experience — someone who had never seen an Intel 8088 manual — to write a functionally equivalent IBM PC BIOS from scratch. A team of "contaminated" engineers who *had* read IBM's code wrote specifications describing what the BIOS did, but never how. The clean programmer implemented from those specs alone. Phoenix recorded every interaction, bought a $2 million insurance policy against copyright suits, and licensed the result to clone makers for $290,000 each. It worked. IBM never successfully sued. The modern PC industry exists because of that clean room.

Forty-two years later, [PHALUS](https://phalus.sh/) — the Private Headless Automated License Uncoupling System — does the same thing in about ninety seconds, with no humans in the room at all.

## What PHALUS Actually Does

PHALUS is a self-hosted Rust binary, licensed 0BSD, that takes a dependency manifest (`package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`) and reimplements your dependencies from scratch using a two-agent LLM pipeline with enforced isolation between the agents.

**Agent A** reads only public documentation — READMEs, API docs, type definitions. Never source code. It produces a Clean Room Specification Pack (CSP): ten formal documents describing *what* a package does.

**Agent B** receives only the CSP, with SHA-256 checksums logged at the handoff. It has never seen the original code, the original documentation, or Agent A's inputs. It implements the package from the specification alone, using an iterative reasoning loop.

A validation step checks syntax, runs tests, and scores structural similarity against the original. The entire pipeline is recorded in an append-only JSONL audit trail, hashed on completion for tamper detection.

It's the Phoenix BIOS clean room, fully automated, running on your laptop, against every dependency in your project at once. [Dylan Ayrey and Mike Nolan](https://fosdem.org/2026/schedule/event/SUVS7G-lets_end_open_source_together_with_this_one_simple_trick/) demonstrated the concept at FOSDEM 2026 with [Malus](https://malus.sh), a SaaS version. PHALUS is the self-hosted, open-source descendant — no cloud, no intermediary, your infrastructure, your choice of LLM provider.

The project's own documentation calls this "ethically questionable and legally untested." That's an honest framing for a tool that raises uncomfortable questions about the future of open source. But I want to argue that the most uncomfortable question isn't the one most people are asking.

## The Question Everyone Is Asking

The obvious concern: PHALUS lets companies strip copyleft licenses from dependencies. Run it against your AGPL-licensed database driver, get back a functionally equivalent implementation under MIT or 0BSD, and your proprietary product no longer has a copyleft obligation. The social contract of reciprocal licensing — I'll share my code if you share yours — gets routed around by a machine.

This is real, and it matters. Open source maintainers already struggle with sustainability. A tool that automates license laundering at scale could accelerate the extraction of value from open source commons without returning anything to the people who built them. The clean room defense has always been available in theory, but when it required hiring a team of engineers and months of work, the economics discouraged casual use. When it takes ninety seconds and costs a few dollars in API calls, the calculus changes completely.

## The Question Nobody Is Asking

Here's what I keep thinking about: what if the bigger story isn't license evasion? What if it's supply chain security?

On March 24, 2026, versions 1.82.7 and 1.82.8 of [LiteLLM were published to PyPI](https://docs.litellm.ai/blog/security-update-march-2026) containing a three-stage payload: credential harvesting, Kubernetes lateral movement, and a persistent backdoor. The attack vector was creative — a threat group called TeamPCP first [compromised Trivy](https://www.kaspersky.com/blog/critical-supply-chain-attack-trivy-litellm-checkmarx-teampcp/55510/), an open-source security scanner used in LiteLLM's CI/CD pipeline, then used that foothold to steal the maintainer's PyPI credentials and publish poisoned packages. LiteLLM is present in roughly 36% of cloud environments. The malicious versions were live for about forty minutes before PyPI quarantined them.

One week later, on March 31, versions 1.14.1 and 0.30.4 of [Axios were published to npm](https://cloud.google.com/blog/topics/threat-intelligence/north-korea-threat-actor-targets-axios-npm-package) with a malicious dependency — `plain-crypto-js` — that downloaded a cross-platform RAT attributed to Sapphire Sleet, a North Korean state actor. Axios has over 100 million weekly downloads. The trusted package's own code was never modified; the attackers simply [added a dependency](https://snyk.io/blog/axios-npm-package-compromised-supply-chain-attack-delivers-cross-platform/) that executed a post-install script to pull the second-stage payload.

These aren't outliers. [454,648 new malicious open-source packages](https://www.webanditnews.com/2026/04/01/the-invisible-saboteur-how-open-source-supply-chain-attacks-are-becoming-the-software-industrys-most-dangerous-blind-spot/) were identified in 2025, a 75% year-over-year surge. The [Shai-Hulud worm](https://netcrook.com/open-source-supply-chain-crisis-shai-hulud-worm-2026/) became the first self-replicating npm worm, using stolen credentials to poison every package a compromised maintainer controlled. We are living through a sustained, escalating campaign against the open source supply chain, conducted by state actors and organized criminal groups.

Now consider what PHALUS actually produces: a reimplementation of a dependency with no upstream maintainer account to compromise, no CI/CD pipeline to infiltrate, no post-install scripts from transitive dependencies you never audited. The reimplemented code does what the documentation says the package does — nothing more. No credential harvesters. No RATs. No lateral movement payloads hiding in a `.pth` file that executes on every Python process startup.

## The Paradox

This is the tension I can't resolve cleanly, and I don't think anyone can yet:

**The same tool that threatens open source sustainability might be the most practical defense against open source supply chain attacks.**

If you're a company running Axios in production, the March 31 compromise meant that for some window of time, every `npm install` pulled a North Korean RAT into your build pipeline. Your options for preventing that were: pin exact versions (which you should do, but didn't help if you pinned the compromised version), use a lockfile (same problem), run a security scanner (like Trivy, which was itself compromised two weeks earlier), or vendor your dependencies (which most teams don't do because it's tedious and creates maintenance burden).

PHALUS offers a different option: reimplement the dependency from its public API specification, audit the generated code, and never pull from the upstream registry again. You lose upstream bug fixes and feature development. You gain immunity to upstream compromise.

That's not a clean trade-off. It's not even necessarily a good one for most teams. But it's a real one, and it gets more attractive every time a state actor compromises a package with nine-figure weekly downloads.

## The Legal Fog

The legal status of AI-assisted clean room reimplementation is genuinely unsettled. The Phoenix BIOS precedent established that clean room design is a valid defense against copyright infringement claims — but that case involved human engineers, a documented process, and a clear separation between the teams. Whether the same defense holds when the "clean room" is two LLM inference calls with a SHA-256 hash between them is an open question.

Copyright protects expression, not functionality. If Agent B produces code that implements the same API with different expression — different variable names, different control flow, different internal architecture — the clean room defense should hold. But "should" and "will" are different words when you're talking about litigation, and no court has ruled on this specific pattern yet.

PHALUS is explicit about this uncertainty. The documentation states: "You are your own legal counsel here." The FAQ acknowledges that this "fundamentally challenges the social contract of open source." I'd add that it also fundamentally challenges the social contract of proprietary software — if a tool can reimplement any dependency in ninety seconds, the value of any individual codebase shifts from the code itself to the ecosystem, community, and operational knowledge around it.

## What This Means for Security Architecture

Regardless of where you land on the ethics, PHALUS is architecturally interesting as a trust boundary implementation. The two-agent isolation model — one agent that reads, one that writes, with a cryptographically logged firewall between them — is a pattern that matters beyond license management.

The SHA-256 audit trail, the append-only logging, the similarity scoring against originals, the validation pipeline — these are the building blocks of verifiable AI pipelines. If you're building systems where AI agents act on your behalf, the question of "how do I know this agent only used the inputs I authorized?" is fundamental. PHALUS's architecture is one answer to that question, applied to a use case that happens to be controversial.

This connects directly to the broader problem of tool integrity in agentic systems. When an AI agent calls a tool, how do you verify that the tool schema hasn't been tampered with? When an agent reads documentation, how do you know the documentation hasn't been poisoned? The isolation firewall between Agent A and Agent B is a small-scale version of the trust boundaries that every serious agent runtime needs to enforce.

## The Uncomfortable Middle Ground

I don't think PHALUS is straightforwardly good or straightforwardly bad. I think it's an inevitable consequence of large language models being good enough to write code from specifications, and that pretending it won't exist doesn't help anyone.

What would help:

**For open source maintainers**: The value proposition of your project needs to be more than the code. Documentation, community, operational expertise, rapid response to issues, and trusted release infrastructure are harder to reimplement than an API surface. Projects that are "just code" are the most vulnerable — not just to PHALUS, but to the same LLM-powered development that's already reshaping how software gets written.

**For companies consuming open source**: Your supply chain risk is real and growing. Whether the answer is PHALUS, vendoring, Software Bills of Materials, cryptographic package signing, or some combination, the status quo of `npm install` and pray is no longer defensible. The Axios and LiteLLM incidents are not the last of their kind. They are the beginning.

**For the legal system**: We need clarity on AI-assisted clean room reimplementation before the practice becomes so widespread that the precedent is set by default. The longer the legal fog persists, the more companies will operate in it, and the harder it will be to establish clear rules.

**For tool builders**: PHALUS's architecture — verifiable isolation between AI agents, cryptographic audit trails, similarity scoring, append-only logging — should be standard infrastructure for any system where AI agents act autonomously. The fact that it was built for license uncoupling doesn't diminish the engineering patterns.

The clean room was invented to create competition in a market dominated by a monopolist. Forty-two years later, the same technique might be both the biggest threat to open source commons and the best defense against the supply chain attacks that are poisoning them. That's not a contradiction. That's the world we're building.

---

*I work on [ThirdKey Trust Stack](https://github.com/ThirdKeyAI), an open-source framework for verifiable AI agent infrastructure: [SchemaPin](https://github.com/ThirdKeyAI/SchemaPin) for tool integrity verification, [AgentPin](https://github.com/ThirdKeyAI/AgentPin) for agent identity, and [Symbiont](https://github.com/ThirdKeyAI/Symbiont) for zero-trust agent runtime. The supply chain problem and the trust problem are the same problem. If that resonates, come build with us.*
