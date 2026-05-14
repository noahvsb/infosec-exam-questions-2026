# Case 30

You have a security token (with card reader) without physical contact⁴ to the host, allowing you to confirm a payment (amount: 9.30 EUR) on the Web. After you've entered your credit card data (name, card number, validity limit, verification code), you see the following instructions on your Web browser:

1. Insert your credit card into the card reader
2. Press BUY (*the card reader then asks you for the security code*)
3. Enter the security code 14473738 and confirm with OK (*the card reader then asks you whether you want to buy on the Internet*)
4. Press OK again
5. Enter the amount (9) and confirm with OK
6. Enter your PIN and press OK (*the card reader then shows an 8 digit "signing code"*)
7. Enter the signing code below (*in your Web browser*) and press "Submit"

**How might such a system work (which cryptographic algorithms, which key sizes, which input, etc.)?**

**How vulnerable is this procedure to malware on the user's host?**

*Note: I expect you to make a choice and to defend this choice. Don't present a range of possible solutions.*

A few additional notes:

- The website itself is protected using TLS 1.3 (certificate for 2048 bit RSA public key; The connection is encrypted using AES_256_GCM, SHA-2-384 is the hash function for HMAC, ECDHE is used for the key exchange mechanism, and RSA is used in the server authentication of the handshake).
- If you repeat the procedure with the same input on the card reader, you'll obtain a different "signing code", which will also be accepted by the website
- After a few minutes, the combination "security code"/"signing code" will no longer be accepted
- If you attempt to input five erroneous "signing codes", your contract will be blocked
- If you enter a wrong PIN three times in a row on the card reader, your card will be blocked. To unblock your card, you'll need to use your card in an ATM or to perform a PIN reset in your bank agency

⁴ *This means it cannot receive data from your computer or send data to your computer. You can manually input data usind the keypad of the token and the output of the token can be read on its (small) display.*

## Answer

TODO
