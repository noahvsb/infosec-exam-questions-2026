# Question 4

**Describe how authenticated Diffie-Hellman (DH) key exchange could work with elliptic curve cryptography (for a given elliptic curve $EC$ with given generator $G$ of known and given order $n$). What would be the mathematical operations to derive a single-use session key?**

*Hint: start from the original Authenticated DH key exchange (based on modular exponentiation).*

## Answer
The same way we would do Authenticated DH key exchange based on modular exponentiation, but now translated to EC's:

Fixed parameters for Alice, resp. Bob:
- Alice: $P_a = aG$ (public; sent to Bob), a (private)
- Bob: $P_b = bG$ (public; sent to Alice), b (private)

Derived long term key $K_{AB} = bP_a = aP_b$

Session parameters:
- Alice: x (private) and $xG + K_{AB}$ (public; sent to Bob)
- Bob: y (private) and $yG + K_{AB}$ (public; sent to Alice)

Derived single-use session key $K_S = xyG = y((xG + K_{AB}) - K_{AB}) = x((yG + K_{AB}) - K_{AB})$ 

**Source**: IS_UG_2_2_4_SecM_KeyExch slides 11-12 + ChatGPT
