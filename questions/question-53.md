# Question 53

In the original RSA encryption scheme the public exponent $e$ and the private exponent $d$ are chosen such that $e$ is coprime to $\phi(n)$ and that $e \cdot d = 1 \mod \phi(n)$, where $n = p \cdot q$.

This encryption scheme has meanwhile been somewhat modified and $e$ and $d$ are now chosen such that $e \cdot d = 1 \mod \lambda(n)$ (without restriction on e), where $\lambda(n)$ must remain secret and

$$\lambda(n) = \mathrm{lcm}(p-1, q-1) = \phi(n)/\gcd(p-1, q-1) \quad (Q53.11)$$

**Explain (with sufficient mathematical detail) how the generation and the verification of a digital signature still works with this modified version of RSA. What are the advantages of this modification? How does this modification affect the computation of a digital signature using the Chines remainder theorem? Why is it recommended that $\gcd(p-1, q-1)$ should be a small value?**

## Answer

TODO
