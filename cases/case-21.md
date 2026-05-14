# Case 21

You have a security token (with card reader) *connected* by a USB cable to the host. This token (the bank card reader) also has a small display and a small keypad (numerical digits and a few functional keys, e.g. "OK" and "Cancel"), see also Fig. 1. You have installed a security plug-in (software) that enables the communication between your computer/browser and your token. The bank card has already been inserted in the bank card reader.

You see the following instructions on your Web browser when you log in to your bank web site:

1. **Card number**
   Welcome, your card with number 6703 1234 1234 1234 1 has been correctly read by the bank card reader.

2. **PIN code**
   Please follow the instructions on your bank card reader.
   *The bank card reader then asks for your PIN code*
   Type your PIN code and press "OK" to log in
   (Or cancel the login by pressing "Cancel")

After having typed your (correct) PIN code on the bank card reader, you are logged in to your bank web site.

**How might such a system work (which cryptographic algorithms, which key sizes, which input, etc.)?**

**How vulnerable is this procedure to malware on the user's host?**

*Note: I expect you to make a choice and to defend this choice. Don't present a range of possible solutions.*

A few additional notes:

- The website itself is protected using TLS 1.3 (certificate for 2048 bit RSA public key; The connection is encrypted using AES_256_GCM, SHA-2-384 is the hash function for HMAC, ECDHE is used for the key exchange mechanism, and RSA is used in the server authentication of the handshake).
- If you enter a wrong PIN three times in a row on the card reader, your card will be blocked. To unblock your card, you'll need to use your card in an ATM or to perform a PIN reset in your bank agency

## Answer

TODO
