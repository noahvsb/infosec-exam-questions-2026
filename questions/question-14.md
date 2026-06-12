# Question 14

One of the fundamental challenges in digital currencies is the double-spending problem.

**Explain the double-spending problem in electronic currencies.**

**Why is this problem easy to solve with a trusted third party (TTP) but difficult in a fully decentralised system?**

**Explain how the blockchain structure and consensus mechanism address this problem without relying on a TTP.**

## Answer

### The double-spending problem

In Bitcoin an electronic coin is defined as a **chain of transactions**. Transferring a coin means the current owner creates a new transaction = a **digital signature by the last owner** over (i) the *previous* transaction and (ii) the *public key of the next owner* (slides p.8–10). Anyone can verify the chain of ownership because each transaction includes the public key needed to check the previous signature, which makes transactions **unforgeable** and gives a degree of anonymity since there is no PKI linking keys to real identities (slide 11).

Digital signatures solve forgery, but **not** double spending. Because a coin is just data, the last owner can sign **two (or more) different valid transactions** with the same coin, transferring it to two different new owners — a **fork in the chain** (slide 13). Both transactions are individually valid (correct signature, valid chain of ownership), so signature verification alone cannot tell which one is the "real" spend. With physical cash this is hard (handing over a coin physically removes it from your possession), but with digital data copying costs nothing — so double spending is "harder than with cash" (slide 5).

### Why a TTP makes this easy, but decentralisation makes it hard

The problem is fundamentally about establishing a **single agreed order/uniqueness** of transactions:

- **With a TTP (e.g. a bank):** the trusted party keeps a single authoritative **ledger** of all transactions and simply verifies the **uniqueness** of each transaction before accepting it. The first spend of a coin is recorded; any second spend of the same coin is rejected. There is one canonical history, so detecting a duplicate is trivial (slide 13). The whole point of Bitcoin, however, is to have a currency **without a TTP / central bank** (slides 4, 13).

- **In a fully decentralised system:** there is no single party to maintain the canonical ledger. Avoiding double spending then requires (slide 14):
  - a **reliable, TTP-free version of the ledger** that is not vulnerable to malicious actors, and
  - the capacity to **distinguish the valid branch from the invalid branch in a fork**.

  The hard part is essentially **agreeing on time/order without a trusted clock**: which of two conflicting transactions came first? Many independent nodes must converge on one shared history, while tolerating malicious participants trying to push their own version (slide 17: "How to deal with time without a TTP?").

### How blockchain + consensus solve this without a TTP

**1. A public, distributed ledger (the blockchain).**
The ledger is held as a **public ledger** maintained by a **network of validating nodes** rather than a TTP (slide 15). Transactions are broadcast to all nodes. The data structure is a chain of **timestamped blocks**, where each block contains a set of transactions plus the **hash of the previous block** (slide 16). This hash-linking means each block reinforces the timestamps of all earlier blocks: an earlier position in the chain is itself proof of earlier existence, and tampering with an old block would change its hash and break every subsequent link (slides 16–17).

**2. Block-inclusion process (slide 18).**
1. New transactions are broadcast to all validating nodes.
2. Each node collects new transactions into a block.
3. The block goes through a **validation process**.
4. A validated block is broadcast to all nodes.
5. The block is accepted **iff all its transactions are valid and not already spent** — this is the explicit double-spend check.
6. The accepted block is appended to the blockchain, and the process repeats.

**3. Consensus mechanism resolves forks ("longest chain wins").**
A double spend appears as two conflicting blocks/branches. The rule is that the **longest available chain is the correct one** — the one honest nodes will extend (slide 19). If two versions of the next block are broadcast simultaneously, a node works with the first one it received but keeps the other branch in case it later becomes longer; the tie is broken at the next extension. So only **one** of the two conflicting transactions ends up in the chain that the network keeps building on; the other is orphaned. This gives a TTP-free way to pick the valid branch in a fork.

**4. Proof-of-Work makes the consensus attack-resistant (slides 24–25).**
Bitcoin's validation is **mining / Proof-of-Work**: to validate a block a node must find a **nonce** such that the block's hash is below some target bound. This is computationally expensive (smaller bound ⇒ more work), and the bound is auto-adjusted to target a steady block rate. The security consequence:
- **"Voting" power is proportional to computing power.** As long as the **majority of validating computing power is honest, the honest chain grows fastest**, so it stays the longest chain and wins consensus.
- An attacker wanting to rewrite history (e.g. to undo a spend) would have to **redo the work for the changed block and all subsequent blocks** while **out-competing the entire honest network** — practically infeasible without a ~51% share of hashpower.

Together: the hash-linked chain makes the past tamper-evident, the broadcast + "not already spent" validation rejects duplicate spends, the longest-chain rule selects one branch of any fork, and Proof-of-Work ties the choice of branch to the majority of honest compute — so double spending is prevented **without any trusted third party**.


