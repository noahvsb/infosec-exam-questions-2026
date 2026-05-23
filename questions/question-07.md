# Question 7

Blockchain consensus relies on the assumption that the longest available chain is the correct one.

**Explain the longest-chain rule used in blockchains such as Bitcoin.**

**How do forks arise, and how are they resolved?**

**Discuss under which assumptions this rule is secure, and what happens if these assumptions no longer hold.**

## Answer

#### **Longest Chain Rule:**
In bitcoin there is no TTP to decide which transactions are valid, so nodes follow the chain that has the most cumulative ”Proof of Work”(PoW).

If a node receives two different versions of the blockchain, it must always work on the one that is longer (the one with the most blocks). This is the **”Longest-Chain Rule”**.

This ensures that all nodes(every computer) eventually agrees on the exact same history of transactions.

#### **Forks:**
A fork arises when two different miners solve the PoW puzzle at the same time. This results in two different version of the next block being broadcast simultaneously. This way, some nodes will see ”Block A”, while others will see ”Block B”, causing the blockchain to be split into two branches.

They are resolved through the longest-chain rule at the next extension. The node works on the first received block and keeps the other branch in case it becomes longer. Then when a new block is added to one of the branches, it becomes longer and that chain gets chosen. 

#### **Security assumptions:**
For the validation process of a new block in bitcoin we use Proof-of-Work:

*   **Honest majority of CPU power:** The majority of the power is used to grow an honest chain. This ensures that this chain always grows faster than an attacker chain. This way, an attacker can never catch up to rewrite history.
*   If this assumption were to fail, we risk **Double Spending**. The attacker has the majority of power and can thus make a secret chain that will eventually become longer than the public one. When broadcasted, this chain will get accepted as the correct chain, rewriting history and deleting the original transaction.
*   In Ethereum we have **Proof-of-Stake** instead of Proof-of-Work

**Source**: Slides Blockchain 12-13 + 18-24 + Gemini
