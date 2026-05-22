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

## Setup: The Two Systems Compared

Throughout this answer, **"multi-prime"** refers to the variant with **four 2048-bit primes** $p_1, p_2, p_3, p_4$ and **"traditional"** refers to the standard variant with **two 4096-bit primes** $p, q$. In both cases the modulus $n$ is 8192 bits.

---

## 1. Key Generation

Key generation requires finding $k$ large primes of the right bit-length. The dominant cost is **primality testing**: a candidate number is drawn at random and tested with the Miller-Rabin primality test. The expected number of draws before finding a prime is determined by the density of primes near $n$.

**Prime number theorem:** the number of primes up to $x$ is $\pi(x) \sim \frac{x}{\ln x}$, so the probability that a random integer near $2^b$ is prime is approximately:

$P(\text{prime near } 2^b) \approx \frac{1}{\ln 2^b} = \frac{1}{b \ln 2}$

This means on average $b \ln 2$ candidates must be tested before finding a prime of $b$ bits.

**Expected candidates per prime:**

| Prime size | Expected candidates per prime | Total Expected Cases |
| --- | --- | --- |
| 2048-bit prime | $2048 \cdot \ln 2 \approx 1419$ | $1419\cdot 4=5676$ |
| 4096-bit prime | $4096 \cdot \ln 2 \approx 2838$ | $2838\cdot 2=5676$ |

At first glance the multi-prime system seems to benefit from higher prime density — but this is exactly offset by needing twice as many primes. The **total number of candidates tested** is the same for both systems:

- Traditional: $2 \times 2838 = 5676$ total candidates
- Multi-prime: $4 \times 1419 = 5676$ total candidates

So the prime density argument alone gives **no speedup**. The speedup comes entirely from the **cost per test**.

**Cost per Miller-Rabin test:** a single round on a $b$-bit number costs one modular exponentiation(=the complex operation), which via repeated squaring costs $O(b^3)$ bit operations (each of the $O(b)$ squarings/multiplications costs $O(b^2)$).

- Testing one 4096-bit candidate: $O(4096^3)$
- Testing one 2048-bit candidate: $O(2048^3)$ — a factor of $2^3 = 8$ cheaper

**Total key generation cost comparison:**

- Traditional: $5676 \times O(4096^3)$
- Multi-prime: $5676 \times O(2048^3)$

$\frac{\text{Traditional cost}}{\text{Multi-prime cost}} = \frac{5676 \times 4096^3}{5676 \times 2048^3} = \left(\frac{4096}{2048}\right)^3 = 2^3 = 8$

Multi-prime key generation is therefore **~8× faster** than traditional key generation.

<aside>
💡

The prime density advantage (finding each smaller prime more easily) is exactly offset by needing more of them. The entire 8× speedup comes purely from the cheaper cost per Miller-Rabin test on a shorter candidate.

</aside>

---

## 2. Encryption (Public Key Operation)

Encryption computes $C = M^e \bmod n$. The public key is $\{e, n\}$ — crucially, **only** $n$ **is known to the encryptor**. The factorisation $n = p_1 p_2 p_3 p_4$ is the private key holder's secret.

**The encryptor cannot use CRT**, because they do not know the individual prime factors $p_i$. They must compute the full modular exponentiation $M^e \bmod n$ with the 8192-bit modulus $n$.

Since both systems have an identical 8192-bit modulus, the encryption cost is **identical** for multi-prime and traditional RSA. There is no speed difference here.

---

## 3. Decryption (Private Key Operation)

Decryption computes $M = C^d \bmod n$, and the **private key holder knows all prime factors** $p_i$. This is where CRT applies.

**How CRT works for RSA decryption** (generalised from the 2-prime case in ch. 2.3):

Instead of computing $C^d \bmod n$ directly with an 8192-bit modulus, compute $k$ smaller exponentiations — one per prime factor:

$M_i = C^{d_i} \bmod p_i \quad \text{where } d_i = d \bmod (p_i - 1)$

- **Why** $d_i = d \bmod (p_i - 1)$**?** By Fermat's Little Theorem, $C^{p_i - 1} \equiv 1 \pmod{p_i}$ for any $C$ not divisible by $p_i$. So the exponent $d$ can be reduced modulo $(p_i - 1)$ without changing the result mod $p_i$.

Then reconstruct $M$ from $M_1, \ldots, M_k$ using the CRT formula. The CRT reconstruction itself is cheap (linear in $k$).

**Decryption cost comparison (with CRT):**

| System | CRT sub-operations | Cost each | Total |
| --- | --- | --- | --- |
| Traditional (2 × 4096-bit) | 2 exponentiations mod $p_i$ | $O(4096^3)$ | $2 \cdot O(4096^3)$ |
| Multi-prime (4 × 2048-bit) | 4 exponentiations mod $p_i$ | $O(2048^3)$ | $4 \cdot O(2048^3)$ |

$\frac{\text{Traditional decryption}}{\text{Multi-prime decryption}} = \frac{2 \times 4096^3}{4 \times 2048^3} = \frac{2}{4} \times \left(\frac{4096}{2048}\right)^3 = \frac{1}{2} \times 8 = 4$

Multi-prime decryption with CRT is therefore **~4× faster** than traditional RSA decryption (which also uses CRT on its two primes).

<aside>
💡

The factor of 4 comes from two competing effects: multi-prime needs twice as many CRT sub-computations (4 vs 2), which halves the speedup, but each sub-computation is 8× cheaper (half the bit-length cubed). Net: $8 / 2 = 4$× speedup.

</aside>

**What if CRT is not used at all?** Without CRT, the decryptor computes $C^d \bmod n$ with the full 8192-bit modulus — both systems cost $O(8192^3)$ and there is no difference. CRT is what unlocks the speedup, and the speedup is larger for multi-prime because the sub-computations are cheaper.

---

## 4. Storage / Key Size

The public modulus $n$ is 8192 bits in both cases — identical storage and transmission cost for the public key.

The **private key** differs slightly: multi-prime RSA stores four 2048-bit primes ($4 \times 2048 = 8192$ bits), versus two 4096-bit primes ($2 \times 4096 = 8192$ bits) for traditional RSA. The total private key size is alike — no meaningful difference.

---

## 5. Summary Table

| **Operation** | **Traditional (2 × 4096-bit)** | **Multi-prime (4 × 2048-bit)** | **Speedup factor** |
| --- | --- | --- | --- |
| **Key generation** | $5676$ tests, each $O(4096^3)$ | $5676$ tests, each $O(2048^3)$ | **~8×** faster |
| **Encryption** | $O(8192^3)$ — full mod $n$ | $O(8192^3)$ — full mod $n$ (no CRT possible) | **No difference** |
| **Decryption (with CRT)** | $2 \times O(4096^3)$ | $4 \times O(2048^3)$ | **~4×** faster |
| **Key/modulus storage** | 8192-bit $n$, two 4096-bit primes | 8192-bit $n$, four 2048-bit primes | **No meaningful difference** |

# Source
All algorithms and formulas are literaly from the slides. Claude formulated this into this answer.