# Question 5

The CBC-MAC construction builds a MAC function from a block cipher by taking the last encrypted block of the CBC-mode encryption.

**Can a similar (secure) MAC function be derived from OFB-mode encryption? Explain how this derived function would work or why it would not be secure.**

## Answer

**CBC** = Cipher block chaining 
| ![[Pasted image 20260611143833.png|250]] | ![[Pasted image 20260611143812.png|250]] | 
**OFB** = OutputFeedBack
| ![[Pasted image 20260611145308.png|250]]|![[Pasted image 20260611145340.png|250]]|

**No, a secure MAC function cannot be derived from OFB (Output Feedback) mode.**
Reasons:
- **Lack of message dependency**: OFB mode works by creating a block-wise key stream that is completely independent of the plaintext message. This key stream is then combined with the plaintext data blocks using a simple bitwise XOR operation to yield the ciphertext.  This key stream is independently from the data generated so the last block only depends on the final plaintext block and the key stream at that specific step. So previous block could be altered with no real problem. 

**From prev year:**
If you were to do this in the same way as CBC-MAC, you would take MAC T = Cn = Mn + On, with On the latest block of the keystream encryption. 

If the attacker knows the message being sent, he would know Mn, and he could derive On. Since the keystream is completely independent of the actual plaintext, On will always be the same for each encryption of a each message (when using the same IV). The attacker could now create a new message with custom message block Mi with i < n. And then use the same Mn as in the intial message. This would result in the same MAC, because T = Mn + On for this message too. 
Therefore, this is not a secure mechanism to create MAC's for a message.