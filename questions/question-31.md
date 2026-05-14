# Question 31

A *ring signature* is a special type of digital signature. The signature can be performed by any member of a group of users. Anyone (given the ring signature and the public keys of all group members) can verify the authenticity of the signature, but not determine *which* member of the group has created the signature.

We consider a group with 4 members (this can be easily generalised to any number of members) using RSA key pairs $(KU_i, KR_i)$ ($1 \le i \le 4$) and assume the signer is user number 3.

The procedure uses a keyed function $C_{k,v}(y_1, y_2, y_3, y_4)$ (depending on a key value $k$ and a glue value $v$). The tuple $y_1, y_2, y_3, y_4$ will be chosen such that the ring equation holds:

$$C_{k,v}(y_1, y_2, y_3, y_4) = v \quad (Q31.6)$$

The practical implementation of the keyed function $C_{k,v}(y_1, y_2, y_3, y_4)$ is:

$$E_k(y_4 \oplus E_k(y_3 \oplus E_k(y_2 \oplus E_k(y_1 \oplus v)))) \quad (Q31.7)$$

where $E_k$ is the symmetric encryption (consider AES-256) using key value $k$ (the corresponding decryption could be written as $D_k$), and where $\oplus$ is the bitwise XOR operation.

The signature is generated (by user 3) as follows:

1. the key value $k$ is computed from the message using a (given and known) cryptographic hash function $H$ (e.g. SHA2-256): $k = H(M)$ (truncation to the required key length is allowed)
2. a random glue value $v$ is chosen
3. random values $x_i$ ($1 \le i \le 4 \land i \neq 3$) are chosen
4. the corresponding values $y_i = E_{KU_i}(x_i)$ are used (with $E_{KU_i}$ the RSA encryption with the public key $KU_i$) ($1 \le i \le 4 \land i \neq 3$; no PKCS #1 formatting is used)
5. the ring equation (Q4.1) is solved for $y_3$
6. the value of $x_3 = E_{KR_3}(y_3)$ is determined
7. the ring signature for message $M$ is the 9-tuple $(KU_1, KU_2, KU_3, KU_4, v, x_1, x_2, x_3, x_4)$

The verification of the ring signature is as follows:

1. compute the values $y_i = E_{KU_i}(x_i)$
2. calculate the key value $k = H(M)$
3. verify that the ring equation (Q4.1) holds

**How can the ring equation (Q4.1) be solved for $y_3$? Explain why someone outside the group (without knowledge of any of the private keys $KR_i$) can't generate a ring signature for the group. Explain why it isn't possible to identify which member of the group has generated the ring signature.**

## Answer

TODO
