# Case 25

You have a so-called HardKey, which is a security token (without card reader, but with a small display, see also Fig. 2) without physical contact³ to the host, allowing you to log in to your bank web site. You see the following instructions on your Web browser:

1. Enter your username then click on "next step" (both on the web site)
2. Get your HardKey and press the OK button to switch it on
3. When your see "1.Login" press the OK button
4. Enter your PIN on your HardKey and press the OK button
5. Enter the (8 decimal digit) code displayed on your HardKey (on the web site)

**How might such a system work (which cryptographic algorithms, which key sizes, which input, etc.)?**

**How vulnerable is this procedure to malware on the user's host?**

*Note: I expect you to make a choice and to defend this choice. Don't present a range of possible solutions.*

A few additional notes:

- The website itself is protected using TLS 1.3 (certificate for 2048 bit RSA public key; The connection is encrypted using AES_128_GCM, SHA-2-256 is the hash function for HMAC, ECDHE is used for the key exchange mechanism, and RSA is used in the server authentication of the handshake).
- If you repeat the procedure with the same input on the token, you'll obtain a different 8 digit code, which will also be accepted by the website
- After a few minutes, the original 8 digit code will no longer be accepted
- If you attempt to input five erroneous 8 digit codes, your contract will be blocked
- If you enter a wrong PIN three times in a row on the token, your token will be blocked. To unblock your token, you'll need to contact the bank, which can reset it

³ *This means it cannot receive data from your computer or send data to your computer. You can manually input data usind the keypad of the token and the output of the token can be read on its (small) display.*

## Answer

TODO
