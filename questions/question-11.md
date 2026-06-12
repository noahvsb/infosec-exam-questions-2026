# Question 11

A basic password storage mechanism is to encode a combination of the password and a salt using a one-way function.

A commonly used one-way function is MD5. An alternative one-way function is bcrypt, in which a lengthy (and configurable) setup process may increase the required computation time for the output of the one-way function up to 100 ms on a regular PC.

**What is the advantage (consider performance and security) of using bcrypt instead of MD5 for password storage? Are there also possible drawbacks (consider again performance and security) in using bcrypt instead of MD5? Consider the case of a smartphone, the case of a PC, and the case of a server.**

*Note: the precise working of bcrypt is not relevant for answering this question.*

## Answer

bcrypt is specifically designed to be slow. Consider a scenario in where the password storage is compromised, and the attacker has access to all the salts, and the hashes of the salt + password. 
He could now set up an offline dictionary attack in which he tries out every password with the provided salts. If the hash function was fast, and the attacker has sufficient computational resources, this would probably go relatively fast. However, if the hash function is slow, even if the hardware is good, this would take a considerably longer amount of time, which may even make it infeasable. 

Protection against online attacks would definitely not help. In any case, it would be more vulnerable to DDOS attacks, since the server needs longer to compute a hash. 

Using this on a smartphone would not be recommended, since it would only slow down the user experience. On a PC, this would probably cause a little less inconvenience. On a server that has to calculate a lot of hashes per second, as said before, this would only increase the vulnerability to DDOS attacks, and the only advantage is that offline brute force attacks are slower. 

| Device         | bcrypt Pros                          | bcrypt Cons                                   | MD5 Pros                        | MD5 Cons                 |
| -------------- | ------------------------------------ | --------------------------------------------- | ------------------------------- | ------------------------ |
| **Smartphone** | More secure password storage         | May cause slower unlock/login, battery impact | Very fast, minimal resource use | Insecure, easily cracked |
| **PC**         | Strong security with moderate delay  | Slight delay in login                         | Fast but insecure               | Very vulnerable          |
