# Question 28

We have seen in the course how the use of a *salt* in the encoded storage of a password could improve the security of the storage. The salt is typically unique for each user, but not secret (it is often stored in plain text).

An alternative technique is using both a *salt* and a *pepper* in the encoded storage. The pepper is identical for all users within the system but secret (only known to the application processing the passwords and not stored in plain text). This means that the password $P_i$ for some user $i$ (with salt $S_i$) will be stored as the encoded password $EP_i$:

$$EP_i = H(P_i\|S_i\|Pepper) \quad (Q28.5)$$

where $Pepper$ is the pepper used in this system, $H$ is the (one-way) encoding function, and $\|$ stands for the concatenation of data.

**Compare this use of a pepper + salt combination to the use of only a salt or only a pepper for secure password storage. What are the advantages/drawbacks of this pepper + salt combination?**

**Consider direct login attempts, dictionary attacks, and rainbow tables.**

## Answer

TODO
