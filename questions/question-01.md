# Question 1

OCB (Offset Codebook Mode) is an authenticated-encryption scheme (as is GCM). It offers both confidentiality and authentication using a symmetric encryption algorithm (block cipher, typically AES). It is also provably secure.

The (somewhat simplified) operation on a message $M$ using a symmetric encryption key $K$ and an encryption algorithm $E$ (AES) is as follows:

1. break the message $M$ into $m$ 128 bit blocks: $M_1, M_2, \ldots, M_m$
2. compute $L_* = E_K(0^{128})$ (where $0^{128}$ is a string of 128 null bits)
3. compute $L_\$ = x \cdot L_*$
4. compute $L[0] = x \cdot L_\$$ and $L[j] = x \cdot L[j-1]$ (for $j$ ranging from 1 to 127)
5. compute $Z_0 = Init(N)$, where $N$ is a nonce for the algorithm and $Init$ is an easily computed initialisation function (for which details are skipped here)
6. the offsets $Z_i$ ($i$ ranging from 1 to $m$) can be computed as $Z_i = Z_{i-1} \oplus L[ntz(i)]$, where $\oplus$ is the bitwise XOR operation and $ntz(i)$ is the number of trailing zeros in the binary representation of $i$ (e.g. $ntz(12) = 2$)
7. compute the ciphertext blocks $C_i = Z_i \oplus E_K(M_i \oplus Z_i)$
8. compute $Checksum = M_1 \oplus \ldots \oplus M_m$
9. compute the authentication tag $T = E_K(Checksum \oplus Z_m \oplus L_\$)$
10. the final outcome is $CT = C_1, C_2, \ldots, C_m, T$.

All multiplications ($x \cdot$) should be considered as a (polynomial) multiplication with the polynomial $x$ in $GF(2^{128})$ using the irreducible polynomial $x^{128} + x^7 + x^2 + x + 1$ (cf. GCM).

We have hereby assumed that the length (in bits) of message $M$ is a multiple of 128, that there are no associated data (that must be authenticated, but not encrypted).

**Compare the performance of OCB to the performance of GCM: consider parallellisability of encryption, complexity of operations, and potential to pre-compute some partial results.**

## Answer

We will go through both of the algorithms step by step, and identify for each which parts can be parallelized and which can be precomputed.

### For OCB:

* $L_*$ - can be computed when key K is known, so this can be pre computed when the same key is used for multiple messages
* $L_\$$ - can also be pre-computed, x is just the polynomial variable
    * This becomes a left shift + xor with generator polynomial in case of overflow
* L[0] - can thus be pre-computed as well
    * again leftshift + xor  
* L[j] - This entire series/list can be pre-computed
    * again leftshift + xor for each 
* $Z_0$ - computed for each version, quickly computed, possibly pre-computed if we are allowed to pre generate/ init nonces
* $Z_i$ - if $Z_0$ precomputed, then we can pre compute this array. 
    * Although defined recursively ($Z_i = Z_{i-1} \oplus L[ntz(i)]$), the relative offsets $\Delta_i = Z_i \oplus Z_0$ only depend on the key.
    * It only requires a single XOR operation per block, making it fast.
* $C_i$: 
    * this computation is more compute heavy: $E_k(M_i \oplus Z_i)$ requires AES for encryption
    * but this is **parallelizable**
        * we assume we have precomputed the $Z_i$
* **Checksum**
    * does not depend on ciphertext, only on plaintext, so can be done in parallel with ciphertext computations
    * series of xor: simple operations, fast
    * could be parallelized using divide and conquer --> lg(n) ops
* Authentication tag $T$: computed at the end, 
    * requires AES computation, which is heavy, but this does not depend on the ciphertext blocks, so this can be calculated in parallel with those.
    * does only depend on checksum, other arguments can be precomputed

### For GCM:

**GHASH** function:
as described in the book, $\text{GHASH}_H(X)$ can be expressed as:
$(X_1 \cdot H^m)\oplus(X_2 \cdot H^{m-1})\oplus \dots \oplus (X_{m-1}\cdot H^2) \oplus (X_m \cdot H)$ 

If the same hash key is used for multiple messages, the values $H^2, H^3, \dots$ can be precomputed.
Then, the datablocks to be authenticated can be calculated in parallel.

However, the calculation of a value $(X_{m-j} \cdot H^{j+1})$ is a bit compute intensive. This is a full multiplication over $GF(2^{128})$ and requires a lot of operations in software.


**GCTR** function
* $CB_i$:
    * If we can already determine the Initialisation Vector (IV) beforehand, then we can pre-encode this
    * this gives us $j_0$ which becomes the ICB (Initial Counter Block)
    * $CB_1$ becomes CBI, and we can thus **pre-compute** the entire $CB_i$ array.
* $E(K, CB_i)$: these can all be pre-computed if we know the key beforehand
* $Y_i$ = $X_i \oplus E(K,CB_i)$
    * As said before, the $E(K,CB_i)$ can be pre-computed. So this reduces to the XOR operation.
    * Each block can be calculated seperately and thus in **parallel**
* $Y^*_n$ = $X^*_n \oplus \text{MSB}_{len(X^*_n)}(E(K,CB_n))$
    * this can be done in parallel with the other blocks
* $Y$: This is just the concatenation of these previous blocks 


In GCM, we The GCTR function is used first to compute the ciphertext. This uses an encoding of the IV, which we can already pre-compute. Then GHASH is used to compute a HASH of the entire block: ciphertext along with Associate data etc. This hash is then encoded using the GCTR to determine the authentication tag.

### The comparison

**Offline pre-computation**
* OCB:
    * 1 AES call to compute $L_*$.
    * 128 shift/XOR operations to populate the $L$ array.
    * $m$ XOR operations to generate the $Z_i$ offsets.
    * Note: We cannot pre-compute the AES encryptions for the blocks or the tag because the input to AES depends on the plaintext ($M_i$).
* GCM: 
    * 1 AES call to generate the hash key $H$.
    * $m-1$ $GF(2^{128})$ multiplications to pre-compute the powers of $H$ ($H^2, H^3, \dots, H^m$).
    * $m$ AES calls to completely pre-compute the keystream $E(K, CB_i)$.
    * 1 AES call to pre-compute the tag offset $E(K, CB_0)$.
    * 1 AES call to pre-compute the tag offset $E(K, CB_0)$. for the second GCTR section
    * Note: GCM allows us to push 100% of the AES workload to the offline phase.

If we assume all calculations that could be pre-computed have already been performed.  And that we can exploit the parallellizability to it's maximal potential (having an infinite amount of parallel processors)
Then, the online computational complexity of the two algorithms reduces to the following:

**Online computation**
* OCB:
    * 1 AES call for each block: can be done in parallel
    * checksum calculation: xor of all blocks (can be parallelized) --> xor tree, lg(m)
    * 1 AES call for authentication tag, can be done in parallel with the AES calls for the other blocks.
    * **total latency**: 1 AES call + 1 XOR tree
        
* GCM:
    * XOR to produce ciphertext $C_i = P_i \oplus E(K, CB_i)$. in the first GCTR
    * $GF(2^{128})$ multiplication for each block ($C_i \cdot H^{m-i}$): done in parallel (assuming $H^i$ are pre-computed).
    * 1 concatenating XOR at the end (can be parallelized) --> XOR tree, $\lg(m)$.
    * 1 final XOR to encrypt the tag: $T = S \oplus E(K, CB_0)$.
    * **Total latency**: XOR (generate $C$) + $GF(2^{128})$ multiplication + XOR tree (GHASH sum) + XOR (for Tag).

we see they both have a XOR tree concatenating all the blocks. So the remaining factors that could determine an online performance difference are:
* OCB: 1 AES encryption

versus
* GCM: one multiplication between two $GF(2^{128})$ polynomials + 2 xor operations between two 128 bit numbers

Which of those will turn out fastest depends on the hardware optimisations used. The GF(2^128) multiplications can be optimised/accelerated in hardware, as can the AES encryption.


### references

see book fifth edition page 386 for GCM
For GCM, as mentioned in presentation 2_2_3 slide 70:
Ch. 12.7 
* 5th edition: p. 386-389
* 7th edition: p. 402-405

### Sources
book
used gemini for review
