# Question 17

Consider the following implementation of a hash function $H_T$

$$H_T(M) = H(M_1) \oplus \ldots \oplus H(M_n) \quad (Q17.3)$$

where $H$ is a traditional hash function (MD5, SHA1, SHA2-256, etc.), where $M$ is the message to be hashed, and $M$ is the concatenation of $n$ individual data blocks $M_i$ (with $i \in 1..n$), which are sufficiently small to be a single input data block for the hash function $H$:

$$M = M_1\|\ldots\|M_n \quad (Q17.4)$$

**What are possible advantages of $H_T$? What are possible security issues? Is it still a one-way function, does it still exhibit weak and strong collision resistance (consider the case where $H$ is MD5 and the case where $H$ is SHA2-256)?**

## Answer

TODO
