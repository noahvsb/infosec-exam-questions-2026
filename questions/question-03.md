# Question 3

Most cryptocurrencies use a proof-of-work for the validation of blocks in the blockchain. This proof-of-work consists in computing some hash algorithm. In the case of Bitcoin the hash algorithm is SHA2-256. A major drawback of this kind of hash function is that traditional computer CPUs are at a significant disadvantage both in speed and in power consumption compared to Application-Specific ICs (ASICs), which can be optimised to perform this single task (i.c. computing SHA2-256 hashes).

**Can you suggest alternative hash algorithms that would reduce the advantage of ASICs with respect to CPUs? What properties would be desirable for such hash algorithms?**

*Note: Don't hesitate to think slightly out-of-the-box of traditional cryptographic hash functions, which are mainly intended for digital signatures and should therefore be very fast to compute.*

*Note: For those less familiar with hardware: ASICs are dedicated hardware for a single task. They're not reprogrammable (contrary to FPGAs, CPUs, or GPUs) and only have limited integrated random access memory (much less than the typical L3-cache of a CPU).*

## Answer

To reduce the advantage of ASICs over CPUs in Proof-of-Work (PoW), the goal is to shift the bottleneck from pure calculation (computational power) to memory and architecture flexibility. 

For a hash algorithm to be **"CPU-friendly"** and **"ASIC-resistant,"** it should possess the following properties:

*   **Memory-Hardness:** The algorithm should require a large amount of Random Access Memory (RAM) to compute. CPUs have large L3 caches and high-speed access to gigabytes of RAM. ASICs, on the other hand, have very little memory. Using a hash function that stores and retrieves large amounts of data makes ASICs much slower and more expensive to manufacture.
*   **High Memory Bandwidth Requirements:** The algorithm should require a lot of unpredictable memory operations. ASICs are heavily limited by their speed of accessing external memory, whereas this pipeline is significantly faster on a CPU architecture.
*   **Sequential Operations:** The algorithm should be designed to be hard to parallelize. This prevents an ASIC from simply running thousands of lightweight mini-cores in parallel. Incorporating complex, CPU-optimized instructions—such as floating-point arithmetic or **AVX instructions**—further enhances this resistance.

### Alternative Algorithms

*   **Argon2:** Winner of the Password Hashing Competition. It is specifically designed to be ASIC-resistant by maximizing the **"Time-Memory Trade-off"**. If an attacker attempts to use less memory, their computational cost increases exponentially, leaving virtually no room for ASIC optimization.

**source**: Blockchain slides 26-27 + Gemini
