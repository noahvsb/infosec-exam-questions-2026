# Question 16

**Explain why AES-GCM (Galois Counter Mode) can be more efficiently parallellised than a combination of AES-CTR (counter mode) for confidentiality with an AES-based CBC-MAC for authentication.**

**Show as an illustration how the AES-GCM algorithm could be efficiently parallellised over 4 processors.**

*Note: consider the simplified case for GCM with a 96 bit IV and with no additional authenticated data. The message to be encrypted is at least a few kilobytes, which means that a reasonably large number of blocks will have to be encrypted.*

## Answer

 - AES-GCM: Uses CTR mode which can be calculate in parallel. Counter_i is pre calculated for each block, therefor E_k(Counter_i) can be pre calculated. GHASH seems sequential but can be parallelized. The powers H_i can be precomputed

- AES-CTR and CBC-MAC: CRT mode is the same as in AES-GCM. CBC-MAC. Cannot be efficiently parallelized because the processing of each block depends on the output of the previous one. This is pure sequential

-------------------------

Initialization: the starting counter, HashKey: $H = E_K(0^{128})$, the powers $H^2$, $H^3$ and $H^4$ and all $Y_i = 0$ $(i = 1, 2, 3, 4)$.

Each processor encrypts its block and immediately updates its own intermediate result using the constant $H^4$ , without having to wait for the other processors.

- Processor 1 verwerkt opeenvolgend blokken 1, 5, 9, 13, ...
  - Bereken ciphertext: $C_i = M_i \oplus E_K(J_0 + i)$
  - Update lokale hash direct on-the-fly: $Y_1 = (Y_1 \oplus C_i) \cdot H^4$
- Processor 2 verwerkt opeenvolgend blokken 2, 6, 10, 14, ...
  - Bereken ciphertext: $C_i = M_i \oplus E_K(J_0 + i)$
  - Update lokale hash direct on-the-fly: $Y_2 = (Y_2 \oplus C_i) \cdot H^4$
- Processor 3 verwerkt opeenvolgend blokken 3, 7, 11, 15, ...
  - Bereken ciphertext: $C_i = M_i \oplus E_K(J_0 + i)$
  - Update lokale hash direct on-the-fly: $Y_3 = (Y_3 \oplus C_i) \cdot H^4$
- Processor 4 verwerkt opeenvolgend blokken 4, 8, 12, 16, ...
  - Bereken ciphertext: $C_i = M_i \oplus E_K(J_0 + i)$
  - Update lokale hash direct on-the-fly: $Y_4 = (Y_4 \oplus C_i) \cdot H^4$

Once all blocks have been processed, the four independent intermediate hashes ($Y_1, Y_2, Y_3, Y_4$) must be combined into a single final ciphertext hash. 

$Y_{final} = (Y_1 \cdot H^3) \oplus (Y_2 \cdot H^2) \oplus (Y_3 \cdot H) \oplus Y_4$

And finally,

$\text{Tag} = ((Y_{final} \oplus \text{length block}) \cdot H) \oplus E_K(J_0)$



**Source**: 2.2.1 slide 84 – 87 (CTR), 2.2.3 slide 67 - 75 (GCM) and Gemini
