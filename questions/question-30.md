# Question 30

Learning With Errors (LWE) is a fundamental hard problem underlying several post-quantum schemes.

**Explain the following things**

- **what is meant by *quantum safety*, and discuss the limitations of this notion;**
- **why LWE is believed to be a quantum safe algorithm;**
- **how LWE enables public key encryption;**
- **the role of noise in LWE;**
- **how LWE is related to lattice problems.**

## Answer

Quantum safety means it should be robust against both current and upcoming (not-)quantum algorithms (e.g. Shor, Grover). These algorithms make most current safety mechanisms obsolete (or at least less powerful). Shor is good to crack factorisation and discrete logarithm problems and Grover improves the time to execute a brute force attack. But the limitation with talking about quantum safe, is that these 'upcoming' algorithms are not yet proven to work in practice (only in theory) because a full quantum computer has not yet been brought into existence. But when this happens (which it probably will someday), different protection mechanisms should be ready to counter this new wave of attacks.

LWE (from the lattice-family) is considered quantum safe because it does not use factorization/ discrete logarithms and there is no proof (yet) that the (linked) Shortest Vector Problem could be solved in an efficient way. It uses dimension n ranging from 512 to 1024 so brute force with Grover is still infeasible.

LWE enables public key encryption as follows: 
- Receiver has Private Key (s)
- Sender has Public Key (A, b) with b = (A x s + e) mod q and chooses random secrets s’, e’ and e’’ and calculates:
    1.	b’ = A<sup>T</sup> x s’ + e’ (mod q)
    2.	v’ = b<sup>T</sup> x s’ + e’’ + floor(q/2) x m (mod q)
        - b<sup>T</sup> masks message with noise.
        - floor(q/2) x m is the encoding of the actual bit m.  

So: Ciphertext (b’, v’)  
Because Receiver has s, it can filter out the noise as follows (Decryption):
1. b' = A<sup>T</sup>·s' + e' => b'<sup>T</sup>·s = s'<sup>T</sup>·A·s + e'<sup>T</sup>·s
2. v' = b<sup>T</sup>·s' + e'' + ⌊q/2⌋·m
   = (A·s + e)<sup>T</sup>·s' + e'' + ⌊q/2⌋·m
   = s'<sup>T</sup>·A<sup>T</sup>·s + e<sup>T</sup>·s' + e'' + ⌊q/2⌋·m
3. Δv = v' - b'<sup>T</sup>·s = bᵀ·s' + e'' + ⌊q/2⌋·m - s'<sup>T</sup>·A·s - e'<sup>T</sup>·s

In essence, the difference allows the bigger factors to cancel each other out, leaving only ⌊q/2⌋·m with some really small errors. If this is lower than q/4, m = 0, otherwise m = 1.  

Attacker does not know s thus can only see noise. The noise here plays a masking role, because it denies the attacker to know the actual bit value. The noise has to be small enough for the receiver to round correctly.

CVP (= Closest Vector Problem) defines the problem where you have to find a vector in the lattice that is closest to the given vector. LWE is related to these lattice problems because b is given and you want to find the closest "lattice" point A x s. CVP is at least as hard as SVP, from which we know there exists no proof to solve this efficiently...

### Sources
- IS_UG_2_2_SecM-adv-PQCrypto (notes).
- Claude-AI for further insights.
 
_Status: Complete_  
_Done by: Hann1bal20_