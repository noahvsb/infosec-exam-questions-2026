# Question 17

Consider the following implementation of a hash function $H_T$

$$H_T(M) = H(M_1) \oplus \ldots \oplus H(M_n) \quad (Q17.3)$$

where $H$ is a traditional hash function (MD5, SHA1, SHA2-256, etc.), where $M$ is the message to be hashed, and $M$ is the concatenation of $n$ individual data blocks $M_i$ (with $i \in 1..n$), which are sufficiently small to be a single input data block for the hash function $H$:

$$M = M_1\|\ldots\|M_n \quad (Q17.4)$$

**What are possible advantages of $H_T$? What are possible security issues? Is it still a one-way function, does it still exhibit weak and strong collision resistance (consider the case where $H$ is MD5 and the case where $H$ is SHA2-256)?**

## Answer

Possible advantages:

- Fully parallelisability
- updating: If only one message block changes, the whole file doesn’t need to be rehashed. The old needs to be ‘out XOR’ed’ and the new needs to be XOR’ed.

Possible security issues:
- Vulnerable to adding double blocks: $A \oplus A = 0$
- The order of operations doesn’t matter: $A \oplus B = B \oplus A$

Still a one way function?
  Yes, but the hash algorithm needs to be pre-image resistant (one way function).

Weak collision resistance?
  No, if you scramble the block of the message around you still get the same $H_T$ value

Strong collision resistance?
  No, trivial. If you add 2 exactly the same blocks, you get this: $H(M_{extra}) \oplus H(M_{extra}) = 0$ . Which will not change the $H_T(M)$ value.

MD5 always has bad strong collision resistance. With SHA256 it’s only in this specific algoritm.

Source: 2.2.3 slide 3 - 6 + Gemini
