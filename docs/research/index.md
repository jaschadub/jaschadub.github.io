# Research

Peer-shareable research and specifications on AI agent security, zero-trust execution, and cryptographic infrastructure for autonomous systems. Archived on Zenodo for citation and long-term preservation.

## Papers

### [Typestate-Enforced Agent Loops: Making Policy Gates Unskippable at Compile Time](https://zenodo.org/records/19746724){target="_blank"}
*April 25, 2026 — Preprint v0.3*

A type-system-based approach to enforcing policy gates in AI agent loops. Rather than relying on runtime callbacks, this work uses Rust's typestate pattern to make policy enforcement a compile-time requirement: skipping the gate, dispatching without reasoning, observing without dispatching, or substituting an action between policy approval and execution become expressions that fail to compile. Empirical results from 874 cloud-adversarial runs show 263 forbidden tool-call attempts refused with zero execution breaches.

DOI: [10.5281/zenodo.19746724](https://doi.org/10.5281/zenodo.19746724){target="_blank"} • [PDF](https://zenodo.org/records/19746724/files/typestate_orga_paper-v0.3.pdf?download=1){target="_blank"}
Related: [Open Agent Trust Stack](https://openagenttruststack.org){target="_blank"} • Reference implementation: [symbiont-orga-demo](https://github.com/ThirdKeyAI/symbiont-orga-demo){target="_blank"} • Runtime: [Symbiont](https://github.com/thirdkeyai/symbiont){target="_blank"}

### [Open Agent Trust Stack (OATS): A System Specification for Zero-Trust AI Agent Execution](https://zenodo.org/records/19636534){target="_blank"}
*April 17, 2026 — Specification v1.1.0*

OATS is an open specification for zero-trust AI agent execution in environments requiring consequential actions like database queries and file modifications. It moves security enforcement from output filtering to pre-execution governance using three core principles: declarative tool contract enforcement, compile-time enforcement of the Observe–Reason–Gate–Act loop, and policy gate isolation from LLM influence. The system spans five layers including cryptographic identity infrastructure and a formally verifiable policy engine.

DOI: [10.5281/zenodo.19636534](https://doi.org/10.5281/zenodo.19636534){target="_blank"} • [PDF](https://zenodo.org/records/19636534/files/OATS-v1.1.0.pdf?download=1){target="_blank"}
Related: [Open Agent Trust Stack](https://openagenttruststack.org){target="_blank"} (specification site) • Reference implementation: [Symbiont](https://github.com/thirdkeyai/symbiont){target="_blank"}
