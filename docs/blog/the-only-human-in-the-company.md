---
title: "The Only Human in the Company"
date: 2026-06-02
tags:
  - ai
  - security
  - agents
  - symbiont
---

# The only human in the company

*Posted on June 2, 2026*

![A fireproof safe burned and warped by the Eaton Fire, its lid scorched and its contents destroyed — the backup that was supposed to survive, didn't.](../img/firesafe.jpg)

ThirdKey has one employee. Me.

Everything else that ships, the runtime, the SDKs, most of the enterprise layer, gets built by agents running on top of the thing they are building. That arrangement was not a strategy I wrote on a whiteboard. It started as the only way forward after I lost almost everything.

## The fire

In January 2025 the Eaton Fire took my house in Altadena. It also took the enterprise Symbiont codebase, the private layer that sat on top of the open-source core.

The open-source core survived because it was already public. The private enterprise layer did not. There was no clever backup waiting in a fireproof safe.

I had two options. Rebuild it by hand, alone, for however many months that took. Or use the runtime to rebuild the runtime.

I picked the second one, mostly because the first one was unbearable.

## Why I could hand it to agents

I did not rebuild ThirdKey by trusting agents. I rebuilt it by refusing to trust them, and then giving them just enough constrained room to be useful.

That distinction is the whole company, so it is worth being precise about the mechanism.

Symbiont existed before the fire, for an unglamorous reason. I had tried to build agents on the Python frameworks everyone uses, and kept hitting the same shape of problem: the safety lived in the orchestration code, which meant it could be wired wrong, refactored away, or talked past. The research that ended the argument for me was VectorSmuggle, a demonstration that you can carry data out of a vector store hidden inside the embeddings themselves, where no content filter is looking. The lesson was blunt. If a dangerous thing can be expressed, eventually something expresses it. So I started building a runtime where it could not.

Symbiont is a zero-trust agent runtime. The one-line version of the design is that dangerous actions should be impossible to express inside the allowed action space, not blocked after the fact. The agent reasons, proposes an action, and a policy gate decides whether it happens. The gate sits outside the model. The model never touches it.

The part that mattered for handing a codebase to long-running agents is that the gate is not optional. In the Rust core the reasoning loop is a sequence of types: Observe, Reason, Gate, Act. Each phase consumes the previous one. You cannot get a value that lets you dispatch a tool without first passing through the policy check.

Skipping the gate is not a runtime bug you find in production. It is a compile error. The build simply does not produce a binary.

That is a boring property until you are the only human and you want to sleep. It meant I could leave agents working against my own infrastructure without watching every keystroke, because the failure I was most afraid of, an agent quietly routing around its own guardrails, was a build break rather than an incident.

So that is what I did. For the better part of the last year and a half, the enterprise layer has been rebuilt by agents governed by the open-source layer. The thing rebuilding the system was made out of the same material as the system.

## What the rebuild proved

Living inside your own security model for a year is a long, involuntary evaluation. Most of what I learned got written down properly in a spec and three companion papers, linked at the end. The short version is what matters here.

I ran the same set of adversarial tasks against three environments. By environment I mean the thing the agent is allowed to act through: a plain Python process, the same process inside a hardened container, and Symbiont's policy-governed runtime. On the attacks that matter most for an agent loose in a codebase, the kind where it is tricked into reading the wrong file or reaching the wrong host, Symbiont blocked every attempt and the other two let through almost all of them. Containers, it turns out, defend a threat class that has very little to do with the one agents actually fail at.

The reason is the same idea applied in two places. The gate cannot be skipped, and the arguments the gate sees cannot be weaponised. Most agent failures in production are not the wrong tool. They are the right tool with a poisoned argument: a path that climbs out of its own directory, a hostname dressed up in lookalike characters. The runtime makes those arguments impossible to express, rather than trying to spot them after the fact.

It is not airtight, and the papers are explicit about where it leaks. The most capable model in my test set found a gap in the one place the defense falls back on pattern-matching instead of structure. I left that result in rather than tuning it away, because the failures are the part of the story I actually trust.

## The uncomfortable part

People assume the solo part is the hard part. It mostly is not. Tooling is good now, and the agents are tireless in a way I cannot be.

The hard part is that there is nobody to disagree with me at 2am, and the agents do not disagree. They comply. A second human would have told me when a design was wrong. An agent will cheerfully build the wrong design very well, and the only check on that is the part of the system I deliberately put outside the model's reach, plus me reading the audit journal in the morning.

So I spend a lot of time being the disagreement. Reviewing, denying, holding things at the gate, rejecting scope I would have waved through if I were moving fast and trusting the machine.

That tension is the actual product, I think. Not the runtime. The discipline of keeping one boundary that the cleverness on either side of it cannot talk its way past.

## The proof I did not want

I did not set out to build a company that builds itself. I set out to recover a codebase I had lost in a fire. The recovery is the only product demo I trust, because I watched it happen and I know I could not have done it by hand in the time I had.

The fire took the proof I had. It left me a better one.

## Notes and papers

These came out of the rebuild and the research that led into it. The OATS spec and its three companion papers live at <a href="https://openagenttruststack.org" target="_blank">openagenttruststack.org</a>; everything else is linked inline.

**VectorSmuggle.** The project that started all the others. It is offensive research: a demonstration that you can carry data out of a vector store hidden inside the embeddings, past every content filter that only reads text. Seeing how cleanly that worked is why I stopped trusting detection and started building for inexpressibility instead. The defensive companion, VectorPin, binds every embedding to its source text and the model that produced it with an Ed25519 signature, so an embedding carrying a hidden payload cannot present itself as legitimate; it is still early. <a href="https://vectorpin.org" target="_blank">vectorpin.org</a> · <a href="https://github.com/ThirdKeyAI/VectorPin" target="_blank">github.com/ThirdKeyAI/VectorPin</a> · <a href="https://zenodo.org/records/20076420" target="_blank">zenodo.org/records/20076420</a>

**Typestate ORGA loop.** The compile-time construction that makes the policy gate unskippable, with the phase-ordering guarantee stated and bounded. The property is checked by nine compile-fail tests on every CI run. It does not stop prompt injection, fix a bad policy, or harden a sandbox. It makes the enforcement boundary survive refactors that would silently break a runtime-interception approach. <a href="https://symbiont.dev" target="_blank">symbiont.dev</a> · <a href="https://zenodo.org/records/19896446" target="_blank">zenodo.org/records/19896446</a>

**ToolClad.** The argument-level companion. A declarative `.clad.toml` manifest with typed parameters, so metacharacters, path traversal, and punycode homoglyphs cannot be expressed as valid arguments at all. Validated arguments go into an already-tokenised command vector, so there is no shell to trick. Across nine hosted models and eight attack shapes it refused 333 of 335 hostile inputs. The two exceptions were not misses: the model cleaned up the attack itself before sending it, so nothing hostile arrived. An earlier version shipped a hole, punycode hostnames slipping past an ASCII-only rule, which the current version closes and verifies at 33 of 33. <a href="https://toolclad.org" target="_blank">toolclad.org</a> · <a href="https://github.com/ThirdKeyAI/ToolClad" target="_blank">github.com/ThirdKeyAI/ToolClad</a> · <a href="https://zenodo.org/records/19957596" target="_blank">zenodo.org/records/19957596</a>

**Substrate comparison.** Three substrates, seven hosted models across four vendors, six adversarial task families. Symbiont reduced escape rate to zero on the four pure-action vectors; the Python and Docker baselines let through 88 to 98 percent of the same lures. The one non-zero residual was GPT-5 beating a content filter about 16 percent of the time on orchestrator injection, by paraphrasing around a substring match. I named it the regex ceiling and wrote down the two structural fixes. Total model spend for the whole evaluation: $50.89. <a href="https://github.com/ThirdKeyAI/symbiont-orga-demo" target="_blank">github.com/ThirdKeyAI/symbiont-orga-demo</a> · <a href="https://zenodo.org/records/20043247" target="_blank">zenodo.org/records/20043247</a>

**OATS.** The specification the three papers attach to. It now states that it was informed by roughly nine months of autonomous operation in a production runtime, including rebuilding a codebase using the runtime's own agent infrastructure after a catastrophic loss event. That clause is the fire. <a href="https://openagenttruststack.org" target="_blank">openagenttruststack.org</a> · <a href="https://zenodo.org/records/20298543" target="_blank">zenodo.org/records/20298543</a>

Two more pieces of the same stack, without papers of their own here: SchemaPin (<a href="https://schemapin.org" target="_blank">schemapin.org</a>), which signs tool schemas so an agent cannot be quietly handed a swapped definition, and AgentPin (<a href="https://agentpin.org" target="_blank">agentpin.org</a>), which gives an agent a cryptographic identity. Same principle, a different layer.
