# Question 38

A Merkle tree (aka hash tree) is used in the bitcoin Blockchain technology, but could also be seen as a normal hash function $H_{MT}$. In short, it consists of a tree of hashes in which the leaves are hashes of data blocks. This is illustrated for a (binary) Merkle tree of depth 2 in Fig. 4.

A more rigorous description for a binary Merkle tree of depth $n$ is:

- The data $T$ are divided in $2^n$ blocks $T_i$ of equal size (padding may be needed, but we shan't consider it here to keep things simple) (with $i \in 0..(2^n - 1)$), so that $T$ is the concatenation of all blocks $T_i$: $T = T_0\|T_1\|\ldots\|T_{2^n-1}$
- Each block $T_i$ is then hashed using a hash function $H$: $h_{0,i} = H(T_i)$ (with $i \in 0..(2^n - 1)$)
- The intermediate hash values are then combined and hashed to obtain the parent hash nodes: $h_{j+1,i} = H(h_{j,2 \cdot i}\|h_{j,2 \cdot i+1})$ (with $j \in 0..(n - 1)$ and $i \in 0..(2^{n-j-1} - 1)$)
- The final hash value is then $H_{MT}(T) = h_{n,0}$

The hash function $H$ is a traditional cryptographic hash function (MD5, SHA1, SHA2-256, etc.).

- **Compare the performance of the computation of $H_{MT}$ to that of a regular hash function $H$ (consider parallellisability).**
- **If the depth $n$ of the Merkle tree isn't given, this scheme doesn't exhibit weak collision resistance (aka second preimage resistance). Find some data $T'$ such that $T' \neq T$ and $H_{MT}(T') = H_{MT}(T)$.**

  *Extra: Can you adapt the basic scheme of the computation of the Merkle tree to avoid this issue (beyond using a fixed depth $n$)?*

- **For a given depth $n$, does $H_{MT}$ exhibit (strong) collision resistance if MD5 is chosen as a hash function $H$? Explain your answer.**

## Answer

TODO
