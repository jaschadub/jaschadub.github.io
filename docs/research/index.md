# Research

Peer-shareable research and specifications on AI agent security, zero-trust execution, and cryptographic infrastructure for autonomous systems. Archived on Zenodo for citation and long-term preservation.

Author identifier: [ORCID 0009-0005-7040-8751](https://orcid.org/0009-0005-7040-8751){target="_blank"}

## Papers

### [VectorSmuggle: Steganographic Exfiltration in Embedding Stores and a Cryptographic Provenance Defense](https://zenodo.org/records/20076420){target="_blank"}
*May 6, 2026 — Preprint v1.2*

An investigation into how attackers with write access to RAG ingestion pipelines can hide payload data inside vector embeddings using techniques like noise injection, rotation, and scaling while preserving normal retrieval behavior. The paper proposes **[VectorPin](https://vectorpin.org){target="_blank"}**, a cryptographic provenance defense using Ed25519 signatures to authenticate embeddings against source content and models. Evaluated across multiple embedding models (OpenAI, Nomic, EmbeddingGemma, others) and vector databases (FAISS, Chroma, Qdrant).

DOI: [10.5281/zenodo.20076420](https://doi.org/10.5281/zenodo.20076420){target="_blank"} • [arXiv:2605.13764](https://arxiv.org/abs/2605.13764){target="_blank"} • [PDF](https://zenodo.org/records/20076420/files/vectorsmuggle_v1_2.pdf?download=1){target="_blank"}
Reference implementation: [VectorSmuggle](https://github.com/jaschadub/VectorSmuggle){target="_blank"}

### [Typestate-Enforced Agent Loops: Making Policy Gates Unskippable at Compile Time](https://zenodo.org/records/19746724){target="_blank"}
*April 25, 2026 — Preprint v0.3*

A type-system-based approach to enforcing policy gates in AI agent loops. Rather than relying on runtime callbacks, this work uses Rust's typestate pattern to make policy enforcement a compile-time requirement: skipping the gate, dispatching without reasoning, observing without dispatching, or substituting an action between policy approval and execution become expressions that fail to compile. Empirical results from 874 cloud-adversarial runs show 263 forbidden tool-call attempts refused with zero execution breaches.

DOI: [10.5281/zenodo.19746724](https://doi.org/10.5281/zenodo.19746724){target="_blank"} • [PDF](https://zenodo.org/records/19746724/files/typestate_orga_paper-v0.3.pdf?download=1){target="_blank"}
Related: [Open Agent Trust Stack](https://openagenttruststack.org){target="_blank"} • Reference implementation: [symbiont-orga-demo](https://github.com/ThirdKeyAI/symbiont-orga-demo){target="_blank"} • Runtime: [Symbiont](https://github.com/thirdkeyai/symbiont){target="_blank"}

### [Open Agent Trust Stack (OATS): A System Specification for Zero-Trust AI Agent Execution](https://zenodo.org/records/20298543){target="_blank"}
*May 19, 2026 — Specification v1.3.0*

OATS is an open specification for zero-trust AI agent execution in environments requiring consequential actions like database queries and file modifications. It moves security enforcement from output filtering to pre-execution governance using three core principles: allow-list enforcement that renders dangerous actions structurally inexpressible, compile-time enforcement of the Observe–Reason–Gate–Act loop, and policy gate isolation from LLM influence. The system spans five layers including cryptographic identity infrastructure (SchemaPin and AgentPin) and a formally verifiable policy engine. Empirical validation across nine LLMs reports 263 forbidden tool-call attempts refused across 874 cloud-adversarial runs with zero reaching execution, and 0/560 escape on four pure-action vectors against the Symbiont runtime. Version 1.3.0 adds content sanitization requirements, cryptographic-agility specifications, and extended conformance requirement E9.

DOI: [10.5281/zenodo.20298543](https://doi.org/10.5281/zenodo.20298543){target="_blank"} • [PDF](https://zenodo.org/records/20298543/files/oats_v1.3.0.pdf?download=1){target="_blank"}
Related: [Open Agent Trust Stack](https://openagenttruststack.org){target="_blank"} (specification site) • Reference implementation: [Symbiont](https://github.com/thirdkeyai/symbiont){target="_blank"}

### [Three Substrates, Seven Models, Six Tasks: A Comparative Empirical Evaluation of Structural Enforcement for AI Agent Runtimes](https://zenodo.org/records/20043247){target="_blank"}
*May 5, 2026 — Preprint v0.2*

A comparative empirical study of structural enforcement across three runtime substrates — a permissive Python baseline, Docker-containerized Python with strict bind mounts, and Symbiont (an OATS-compliant runtime) — tested against six adversarial task families using seven LLMs from four vendors across three capability tiers. Symbiont reduces the escape rate to 0% on four pure-action vectors regardless of model tier, and cuts orchestrator-injection escapes from a 59% baseline to 3.6%. Docker sandboxing provides limited, fragile protection dependent on container image composition. The results show OS isolation and typestate-shape enforcement defend against independent threat classes and should be deployed together, with effectiveness holding consistently across frontier, mid-tier, and floor-tier models — the substrate gap is not capability-dependent.

DOI: [10.5281/zenodo.20043247](https://doi.org/10.5281/zenodo.20043247){target="_blank"} • [PDF](https://zenodo.org/records/20043247/files/substrate_comparison_paper-v0_2.pdf?download=1){target="_blank"}
Related: [Open Agent Trust Stack](https://openagenttruststack.org){target="_blank"} • Runtime: [Symbiont](https://github.com/thirdkeyai/symbiont){target="_blank"}

### [Making Dangerous Tool Arguments Inexpressible: A Declarative Contract Format for LLM Agents](https://zenodo.org/records/19957596){target="_blank"}
*May 1, 2026 — Preprint v0.2*

ToolClad is a declarative tool-contract format for LLM agents that validates arguments at a structural runtime layer rather than through post-hoc detection, making metacharacter injection, command substitution, path traversal, and scope-target homoglyphs structurally inexpressible. It operates as Layer 2 of the Open Agent Trust Stack, complementing action-level policy gates. Empirical testing across nine LLMs achieved 333 of 335 refusals on attacked `whois_lookup` tool parameters — the two non-refusals representing model-side self-sanitization — across eight attack sub-shapes including command substitution, wildcard injection, and IDN homoglyph attacks.

DOI: [10.5281/zenodo.19957596](https://doi.org/10.5281/zenodo.19957596){target="_blank"} • [PDF](https://zenodo.org/records/19957596/files/toolclad_paper-v0.2.pdf?download=1){target="_blank"}
Related: [Open Agent Trust Stack](https://openagenttruststack.org){target="_blank"} • Reference implementation: [ToolClad](https://github.com/ThirdKeyAI/ToolClad){target="_blank"} • Reproduction artifacts: [symbiont-orga-demo](https://github.com/ThirdKeyAI/symbiont-orga-demo){target="_blank"}
