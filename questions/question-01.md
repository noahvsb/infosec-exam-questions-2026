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

TODO
