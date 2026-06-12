# Question 12

**If you need a cryptographic hash function and you have to choose between SHA-2 and SHA-3, which algorithm would you choose and why?**

**What are the respective advantages and drawbacks of each algorithm?**

**What would determine your choice?**

## Answer

SHA3 is orders of magnitude faster then SHA2 in hardware, and a little slower in software. So my choice would definitely be influwenced by the actual device the hash function will be used on. If speed is important and the right hardware is available, SHA3 might be the better option.

SHA2 has been the standard for some time, and is therefore more used and supported in the real world. That might also be important for the application. 

SHA2 uses the same kind of algorithm as its compromised predecessor SHA1. This might cause SHA2 to be 'broken' in the comming future. If future-proof-ness is a big concern, SHA3 might be better in that case, since it relies on a completely different kind of algorithm. 

For standard applications, my SHA2 would be my choice, simply because it is still secure and so widely adopted all over the world. 

| If you need...                      | Use... |
| ----------------------------------- | ------ |
| **Maximum performance in software** | SHA-2  |
| **Future-proofing / modern design** | SHA-3  |


| Feature                         | **SHA-2**                                              | **SHA-3**                                     |
| ------------------------------- | ------------------------------------------------------ | --------------------------------------------- |
| **Design basis**                | Merkle–Damgård construction                            | Sponge construction (Keccak)                  |
| **Standardized**                | 2001 (FIPS 180-4)                                      | 2015 (FIPS 202)                               |
| **Security history**            | Long-established, well-analyzed                        | Newer, but highly vetted via NIST competition |
| **Collision resistance**        | SHA-256/512: No practical attacks                      | Even higher margin than SHA-2                 |
| **Performance (software)**      | Very fast on most CPUs                                 | Slower in software for short inputs           |
| **Performance (hardware)**      | Fast, widely supported                                 | Hardware-friendly and scalable                |
| **Length-extension attacks**    | ✅ Possible (due to Merkle–Damgård) in specifique cases | ❌ Not possible (sponge construction)          |
| **Flexibility (output length)** | Fixed output sizes (e.g., 256, 512)                    | Arbitrary-length output via SHAKE modes       |
| **Compatibility**               | Universally supported and deployed                     | Less support in legacy systems                |
