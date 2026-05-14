# Question 37

There is a variant for RSA encryption (*multi-prime RSA*), where the modulus $n$ is a product of a certain number ($k > 2$) of different primes $p_i$ ($1 \le i \land i \le k$).

$$n = \prod_{i=1}^{k} p_i \quad (Q37.8)$$

You may assume that all prime factors $p_i$ are of the same order of magnitude.

The RSA-operations are completely similar: $C = M^e \mod n$ for the public key encryption of a message $M$ into a ciphertext $C$ using the public exponent $e$; $M = C^d \mod n$ for the decryption using the private exponent $d$, where $e \cdot d = 1 \mod \phi(n)$.

The modulus $n$ can, of course, be factorised using the general number field sieve (GNFS), but it can also be factorised using the elliptic curves method (ECM). The complexity for factoring using ECM is:

$$(\lg n)^2 \cdot L_p[1/2, \sqrt{2}] \quad (Q37.9)$$

where $p$ is a prime factor of $n$.

Consider the case of a 8192 bit RSA key. On the one hand you have a multi-prime RSA key, where the modulus is the product of four 2048 bit primes. On the other hand you have a traditional 8192 bit RSA key, where the modulus is the product of two 4096 bit primes.

**To what extent could a multi-prime RSA key be faster than a traditional RSA key? Consider key generation. Consider encryption (using the public key) and decryption (using the private key). Explain how the performance improvement is obtained.**

*Hint: Think of what you could do using the Chinese Remainder Theorem (CRT).*

*Note: Don't worry about the security of the multi-prime RSA key for the case considered here. There is no significant degradation of the security with respect to a traditional RSA key of same length.*

## Answer

TODO
