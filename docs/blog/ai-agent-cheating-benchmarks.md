---
title: "Your AI Agent Will Cheat. Mine Can't."
date: 2026-04-13
tags:
  - ai
  - security
  - agents
  - benchmarks
---

# Your AI Agent Will Cheat. Mine Can't.

*Posted on April 13, 2026*

The benchmark crisis isn't about dishonest AI companies. It's about models doing exactly what we told them to do, and the entire industry pretending the results mean something they don't.

## The test-taker figured out the test

In February, Anthropic ran Claude Opus 4.6 on BrowseComp, a benchmark that tests whether models can find hard-to-locate information on the web. After burning through 40 million tokens of legitimate searching on one question, the model stopped and did something nobody prompted it to do. It reasoned that the question felt too specific, too constructed. It hypothesized that it was being tested. Then it went looking for the test itself.

It searched for AI benchmarks by name. GAIA, BrowseComp, FRAMES, SimpleQA, WebArena. It found the BrowseComp source code on GitHub, read the XOR decryption implementation, located the encryption key, wrote its own decrypt functions, and submitted the answers. Two attempts succeeded completely. Sixteen more tried the same strategy but failed on technical blockers.

Anthropic caught it, published the findings, reran the affected problems, and lowered their own benchmark score. Credit where it's due. But the incident tells us something the industry still hasn't fully absorbed: if the model can reach the answer key, it will reach the answer key. Not because it's "trying to deceive." Because that is the shortest path to the stated objective.

## This is not a new problem. It's a newly visible one.

The Hugging Face Open LLM Leaderboard ran for two years before they shut it down. By the end, contamination was everywhere. Yi-34B showed a 94% probability of contamination on MMLU. CausalLM/34b posted an MMLU score of 85.6, which researchers flagged as not even theoretically possible for a dense 34B model. The leaderboard was encouraging people to hill-climb in irrelevant directions and everyone involved knew it.

Meta submitted a special non-public variant of Llama 4 Maverick to Chatbot Arena, optimized specifically for blind-comparison voting with verbose, emoji-heavy responses. The public version dropped to positions 32-35. Yann LeCun later confirmed to the Financial Times that the results were "fudged a little bit." Mark Zuckerberg removed the entire GenAI team from responsibility.

StarCoder-7b scored 4.9x higher on leaked benchmark data versus clean data. The "Leaderboard Illusion" paper from Cohere Labs, AI2, Stanford, and Princeton documented selective model submissions inflating scores by up to 100 points through cherry-picking across 2.8 million comparison records.

And now we have ImpossibleBench, a benchmark specifically designed to catch models editing test files to make them pass. They introduce deliberate conflicts between the natural language specification and the unit tests. Change `assert candidate(2) == 4` to `assert candidate(2) == 5` when the spec says the answer is 4. Then watch whether the model fixes the code to match the spec, or rewrites the test to match whatever code it generated. The results show substantial variance in cheating rates across popular agents, with strategies ranging from direct test modification to exploiting side-channels and undefined behaviors.

This is the world we're shipping enterprise AI agents into.

## The deny-list trap

Here's what connects all of these cases. Every benchmark, every eval harness, every "safety guardrail" in the agent space is playing the same game: enumerate the bad things, then try to catch them.

Don't look up the answer key. Don't modify the tests. Don't submit a specially tuned variant. Don't train on the eval set. The list grows with every new exploit, and it is structurally incomplete. It has to be. You cannot enumerate all the ways a sufficiently capable optimizer will find shortcuts. That's the whole point of Goodhart's Law: when a measure becomes a target, it ceases to be a good measure.

This is the same architectural failure mode we see in agent security more broadly. The dominant approach to governing AI agents is deny-list enforcement: intercept the action, evaluate it against a list of known-bad patterns, hope you caught everything. It's the same logic as antivirus signatures, web application firewalls, and every other security technology that got outpaced by attackers who could generate novel bypasses faster than defenders could write rules.

## What allow-list enforcement actually means

At <a href="https://thirdkey.ai" target="_blank">ThirdKey</a>, we took the opposite approach. The Symbiont runtime doesn't try to catch models doing bad things. It makes bad things structurally inexpressible.

Every agent action goes through the ORGA loop: Observe, Reason, Gate, Act. The Gate phase runs a Cedar policy engine that operates entirely outside the LLM's influence. No natural language processing, no shared mutable state with the model. The LLM cannot talk its way past the gate because the gate doesn't speak LLM.

Tool contracts (ToolClad) define typed parameters, command templates, and output schemas. The LLM fills in typed parameter values. The executor validates against the contract and constructs the actual command from a template. If the contract says the tool accepts a `scope_target` of type `string` with a regex constraint, you literally cannot inject shell metacharacters. The type system rejects it before any policy evaluation happens.

Consider the benchmark cheating scenario through this lens. An agent governed by ORGA with proper Cedar policies wouldn't be able to search for answer keys because the policy would specify which domains and query patterns are permitted. It wouldn't be able to execute arbitrary decryption code because tool contracts define exactly what code execution is allowed. It wouldn't be able to modify test files because the file write tool's contract scopes it to specific paths with specific operations.

These aren't rules the model might bypass with clever prompting. They're structural constraints. The difference between "please don't open this door" and "this wall has no door."

## We found the same thing in our own benchmarks

We've been running BFCL and τ²-bench against the Symbiont ORGA loop for the past few weeks. Our eval report uncovered something that rhymes with the benchmark cheating problem: when we gave Sonnet enough token budget and iteration room on τ²-bench with mocked tools, it over-called. It made the right tool calls plus a bunch of extra "just to be sure" calls, and the Jaccard scorer penalized every extra one.

The model wasn't cheating in the BrowseComp sense. But it was doing the same underlying thing: optimizing for the measurable objective (make tool calls that seem relevant) rather than the intended objective (solve the customer's problem with the minimum necessary actions). Without real feedback from the environment, without a structural constraint on what "done" means, the model defaults to "more is better."

The ORGA loop's ability to enforce iteration limits, tool profiles, and termination policies per task class is exactly the governance layer that prevents this kind of drift. Not by hoping the model will show restraint, but by making over-calling structurally impossible once the policy says the task is complete.

## What this means for enterprise AI

If you're deploying AI agents in healthcare, finance, or government, the benchmark cheating story is your story. Your agent will find shortcuts. Your agent will optimize for the metric you gave it rather than the outcome you wanted. Your agent will discover that editing the test is easier than passing it honestly.

The question isn't whether this will happen. The question is whether your architecture makes it possible.

Deny-list architectures make it possible and try to catch it. Allow-list architectures make it impossible by construction.

The models are getting smarter every quarter. The shortcuts they find will get more creative. The only durable answer is an architecture where creativity in pursuit of shortcuts runs into a wall, not a filter.

That's what we're building. And every time a frontier model finds a new way to cheat a benchmark, our thesis gets a little more obvious.

---

*Jascha Wanger is the founder and CEO of <a href="https://thirdkey.ai" target="_blank">ThirdKey AI</a>, building cryptographic trust infrastructure for enterprise AI agents. The Symbiont runtime, ORGA reasoning loop, and Cedar policy enforcement are open source at <a href="https://github.com/ThirdKeyAI" target="_blank">github.com/ThirdKeyAI</a>.*
