# Question 10

HMAC is the most commonly used message authentication code based on a hash function:

$$HMAC = H\left[(K^+ \oplus opad)\|H\left[(K^+ \oplus ipad)\|M\right]\right] \quad (Q10.1)$$

A possible simplification of HMAC might be:

$$SimpleHMAC = H\left[(K^+ \oplus ipad)\|M\right] \quad (Q10.2)$$

**Why is this SimpleHMAC (Q24.9) unsuitable as a message authentication code? Explain how, given a message $M$ and its SimpleHMAC, you could construct the SimpleHMAC of some related message $M'$ without knowing the key $K^+$.**

*Note: the hash function used in (Q24.9) may be either MD5, SHA-1, or SHA-2 (not SHA-3).*

## Answer

TODO
