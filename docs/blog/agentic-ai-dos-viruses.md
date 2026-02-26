---
title: What Agentic AI Can Learn from DOS Viruses
date: 2026-02-26
tags:
  - ai
  - security
  - agents
  - malware
---

# What Agentic AI Can Learn from DOS Viruses

*Posted on February 26, 2026*

There's a GitHub repository called [palware](https://github.com/64kramsystem/palware), short for "paleolithic malware," that contains modern disassemblies of DOS-era viruses. Boot sector infectors, tiny COM parasites, memory-resident hookers of INT 21h. The kind of code that terrorized sysadmins in the late 80s and early 90s, written in hand-optimized x86 assembly, often fitting in under a kilobyte. In the early 2000s I used honeypots like [mwcollect](https://web.archive.org/web/20060516215455/http://www.mwcollect.org/) to gather malware and reverse engineer it in my early days of research in that area.

I've been spending a lot of time thinking about security architectures for autonomous AI agents. What happens when you have software entities that can call tools, make decisions, persist across sessions, and act on behalf of humans? I keep finding that the conceptual vocabulary I need already exists. It was invented by virus authors and antivirus researchers thirty years ago.

This isn't a coincidence. The structural parallels between DOS-era malware and modern agentic AI systems are deep enough to be instructive.

## The Interrupt Table Was the First Tool Registry

DOS programs didn't call hardware directly. They called through the interrupt vector table — a standardized dispatch mechanism. INT 21h for DOS file services, INT 13h for disk I/O, INT 10h for video. Programs declared their *intent* (open a file, read a sector) and the table routed that intent to the appropriate handler.

If that sounds familiar, it should. MCP, function-calling APIs, tool-use protocols — they're all structurally identical. They're dispatch tables that route an agent's intentions to capabilities.

And the single most important lesson from the DOS era is this: **the dispatch layer is the highest-value target.** Viruses like Stoned and its variants didn't attack programs. They attacked the table itself, redirecting INT 13h so that every disk read passed through their code first. The program thought it was talking to the disk. It was talking to the virus, which talked to the disk on its behalf, filtering the results.

For agentic AI, the equivalent attack is tool-call interposition. An agent calls a tool, but something in the chain has been compromised — the schema has been modified, the endpoint has been redirected, the response has been tampered with. Without cryptographic integrity on the tool interface itself, the agent has no way to know. This is exactly the problem that tool-integrity verification schemes need to solve: ensuring that the dispatch table hasn't been hooked.

## Residency Is Just Agent Persistence

Most of the viruses in the palware collection are memory-resident. They use the DOS TSR (Terminate and Stay Resident) mechanism to stay loaded after their host program exits, intercepting system calls indefinitely. The clever ones were creative about *where* they lived: `Virus.DOS.Tiny.163` squats in a memory region that's unused after boot. `Virus.DOS.LoveChild.488` hides in the upper half of the interrupt vector table itself — the entries that nobody uses.

Modern AI agents face the same fundamental design problem: how do you maintain state, context, and capability across invocations? The TSR model is the prototype for the long-running agent daemon. And the questions that mattered then still matter now — where does the agent "live," what's its footprint, and who controls its lifecycle? An agent runtime that doesn't enforce strict boundaries on agent persistence is making the same architectural mistake that DOS made by letting any program go resident without oversight.

## Stealth Through Interposition

The viruses on the palware candidates list tell an even more interesting story. Viruses like `Frodo/4K` and `Int13` achieved stealth by interposing on the interface between the OS and the disk, intercepting read calls and presenting clean data to the user while hiding their modifications on disk. Antivirus software would scan a file and see the original, uninfected version — because the virus was filtering the reads in real time.

This is the exact threat model for prompt injection and tool-call manipulation in agentic systems. When an agent reads a document, queries a database, or calls an API, how does it know the response hasn't been filtered, modified, or fabricated by something sitting in the middle? Behavioral detection alone wasn't enough to catch stealth viruses — you had to go around the interposed handler and read the disk directly. Similarly, behavioral monitoring alone won't secure agent tool calls. You need integrity guarantees at the protocol level.

## Polymorphism and the Identity Problem

`1260`, listed in the palware candidates, was the first polymorphic virus — every copy encrypted itself with a different key and generated a unique decryption routine. Later, metamorphic viruses like `ACG` went further, rewriting their own code entirely so that no two copies shared any byte sequence at all.

This was the adversary's answer to signature-based detection, and it worked. The antivirus industry had to move from pattern matching to heuristic analysis and emulation — a much harder problem.

The lesson for agentic AI cuts both ways. On the defensive side: you cannot rely on behavioral fingerprinting to verify an agent's identity. Agents are inherently non-deterministic. Two invocations of the same agent with the same input might produce different outputs, different tool-call sequences, different reasoning traces. This means agent identity has to be established cryptographically — bound to keys, not to behavior. The virus authors proved three decades ago that behavioral signatures are an insufficient foundation for identity.

On the offensive side: if an attacker can spin up agents that *impersonate* legitimate ones, and there's no cryptographic identity layer, you get the agent equivalent of a polymorphic virus — malicious agents that look different every time and can't be distinguished from legitimate ones by observation alone.

## Economy of Means vs. Capability Bloat

`Tiny.163` is 163 bytes. One hundred and sixty-three bytes. It hooks an interrupt, goes memory-resident, and infects COM files. `LoveChild.488` does all that plus uses an undocumented DOS 3.30 feature to hijack INT 21h — in 488 bytes. `BadBoy.1000` encrypts its body, splits it into blocks, stores them in a randomly mixed layout, and bypasses INT 13h monitors — in one kilobyte.

Modern agentic systems trend in the opposite direction: massive context windows, unconstrained tool access, sprawling orchestration frameworks, agents that can call arbitrary APIs with full credentials. There's a discipline in the old malware worth internalizing: **the attack surface of an agent is proportional to its capability surface.** Every tool an agent can access, every permission it holds, every byte of state it maintains is a potential vector. The principle of least privilege isn't just good hygiene — it's the foundational security property that a well-designed agent runtime should enforce.

The virus authors were constrained by necessity and turned it into an advantage. We have the luxury of choosing constraint, and mostly don't.

## Encrypted, Compartmentalized State

`BadBoy.1000` splits its body into encrypted blocks stored in a randomly mixed layout within the host file. This is an early form of compartmentalized, encrypted-at-rest state. The idea is that your operational code and data shouldn't be legible or contiguous in storage.

Most modern agent architectures ignore this entirely. Plans, tool credentials, reasoning traces, memory — it's often stored in plaintext, in predictable locations, accessible to anything that can read the right file or database table. The virus authors understood that if your state is legible, it's vulnerable. Agent architectures should treat their operational state with at least as much paranoia as a 1990s COM infector treated its payload.

## The Arms Race We're About to Rediscover

The virus/antivirus arms race of the 80s and 90s was a compressed, accelerated version of the security dynamics that are about to play out with autonomous AI agents. The attackers were creative, resource-constrained, and operating against systems with weak identity and integrity guarantees.

That describes the current state of agent infrastructure almost exactly.

We have agents calling tools with no integrity verification on the tool schemas. We have agents persisting state with no runtime enforcement of boundaries. We have agents authenticating to services with full credentials and no capability scoping. We have agent identity established by... nothing, mostly. Maybe an API key.

The DOS virus authors would recognize all of these vulnerabilities instantly. They spent a decade exploiting their equivalents.

Studying disassemblies like the ones in palware isn't nostalgia. It's reading the archaeological record of problems we're about to rediscover the hard way — unless we learn from them first.

---

*I'm currently building the [ThirdKey Trust Stack](https://github.com/ThirdKeyAI), an open-source cryptographic framework addressing exactly these problems: [SchemaPin](https://github.com/ThirdKeyAI/SchemaPin) for tool integrity verification, [AgentPin](https://github.com/ThirdKeyAI/AgentPin) for AI agent identity, and [Symbiont](https://github.com/ThirdKeyAI/Symbiont) for zero-trust agent runtime. If any of this resonates, come build with us.*
