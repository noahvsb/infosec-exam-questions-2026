# Question 10

HMAC is the most commonly used message authentication code based on a hash function:

$$HMAC = H\left[(K^+ \oplus opad)\|H\left[(K^+ \oplus ipad)\|M\right]\right] \quad (Q10.1)$$

A possible simplification of HMAC might be:

$$SimpleHMAC = H\left[(K^+ \oplus ipad)\|M\right] \quad (Q10.2)$$

**Why is this SimpleHMAC (Q24.9) unsuitable as a message authentication code? Explain how, given a message $M$ and its SimpleHMAC, you could construct the SimpleHMAC of some related message $M'$ without knowing the key $K^+$.**

*Note: the hash function used in (Q24.9) may be either MD5, SHA-1, or SHA-2 (not SHA-3).*

## Answer

### Why SimpleHMAC is unsuitable: the length-extension attack

The weakness is **not** in the hash function itself but in the way SimpleHMAC uses it.
MD5, SHA-1 and SHA-2 are all **iterative (Merkle–Damgård) hash functions**:

- The input is split into fixed-size blocks (512 bits for MD5/SHA-1/SHA-256). The
  message is first **padded** with a `1`-bit, the required number of `0`-bits, and a
  `64`-bit encoding of the original message length, so that the total is a multiple of
  the block size (slide 16).
- The blocks are then absorbed one by one into a **chaining variable**:
  $$CV_0 = IV, \qquad CV_{q+1} = f(CV_q,\ \text{block}_q)$$
  and the hash output is simply the **final chaining value** $CV_{last}$ (slides 17, 19).

The crucial consequence: **the hash output *is* the complete internal state of the hash
function after it has processed the (padded) input.** Nothing secret is mixed in *after*
the message. So anyone who sees a hash value can resume the computation from exactly that
state and keep feeding in more blocks.

In SimpleHMAC the secret key appears **only as a prefix**:
$$\text{SimpleHMAC}(M) = H\big[(K^+ \oplus ipad)\,\|\,M\big]$$
Here $K^+ \oplus ipad$ is exactly **one block** ($K^+$ is the key padded with zeros to the
block size $b$, slide 64). Because the key is only at the front and the digest exposes the
final chaining state, the construction is vulnerable to length extension — and that breaks
the basic MAC requirement that, given $M$ and its MAC, it must be infeasible to produce a
valid MAC for any new message $M'$ without the key (slides 58–59).

(By contrast, real HMAC wraps the inner hash in a **second, outer** keyed hash
$H[(K^+\oplus opad)\,\|\,H[\dots]]$. The attacker never sees the inner chaining state — they
only see the *output* of the outer hash — so the extension attack does not apply.)

### Constructing the forgery for a related message $M'$

Let $b$ = block size and let `pad(L)` denote the Merkle–Damgård padding (the `1`-bit, the
`0`-bits and the 64-bit length field) that the hash internally appends to an input of bit
length $L$.

When the legitimate sender computes $\text{SimpleHMAC}(M)$, the hash function actually
processes
$$(K^+ \oplus ipad)\ \|\ M\ \|\ \text{pad}\big(b + |M|\big)$$
and the resulting digest $t = \text{SimpleHMAC}(M)$ **equals the chaining value** after all
those blocks.

Given the pair $(M,\ t)$, an attacker who does **not** know $K^+$ can forge as follows:

1. **Adopt the leaked state.** Initialise a hash computation whose chaining variable is set
   to $t$ (instead of the standard $IV$). This is the exact state the sender's hash was in
   right after absorbing $(K^+\oplus ipad)\,\|\,M\,\|\,\text{pad}(\dots)$.

2. **Append the extension.** Choose any data $S$ the attacker wants to add and continue the
   hashing from state $t$ over $S$ (with the hash's own final padding). Call the result
   $$t' = H_{IV=t}\big[S\big].$$

3. **Output the forged pair.** The forged message is
   $$M' = M\ \|\ \text{pad}\big(b + |M|\big)\ \|\ S$$
   and $t'$ is its valid SimpleHMAC, because by construction
   $$t' = H\big[(K^+\oplus ipad)\ \|\ M\ \|\ \text{pad}(b+|M|)\ \|\ S\big] = \text{SimpleHMAC}(M').$$

The forgery succeeds **without knowing $K^+$** — the attacker only needs:

- the message $M$ and its digest $t$,
- the **length** of the key block, which is known: $K^+ \oplus ipad$ is exactly one block
  $b$, so the offset is $b + |M|$ (if the key length is uncertain, the few plausible values
  can simply be tried).

The "related message" $M'$ is the original $M$ with the hash's glue-padding and the
attacker-chosen suffix $S$ appended. This is exactly the kind of selective message
alteration a MAC must prevent (slides 58–59), so SimpleHMAC fails as a message
authentication code.

*Sources: `IS_UG_2_2_3_SecM_HashMac.pdf` — iterative/Merkle–Damgård structure pp. 16–19;
MAC forgery requirement pp. 58–59; HMAC definition pp. 63–64.*

