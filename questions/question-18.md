# Question 18

When looking at the root certificates of my browser (Firefox, May 2026) I found the following properties for the GlobalSign Root CA X.509v3 certificate:

- The certificate is valid from 1998-09-01 to 2028-01-28.
- The public key is a 2048 bit RSA key (the public exponent is $2^{16} + 1$).
- The certificate is self-signed using SHA-1 as a hash function and using PKCS #1 v1.5 formatting.
- The critical extensions mention this is a certificate for a certificate authority and the key pair is intended for certificate signing and for CRL signing.

**Explain why the different security choices (algorithms, key lengths, validity periods, extensions) do or don't make sense.**

**Explain why you would keep or change these security choices.**

## Answer

- 30 years is a long time. But in this case quite acceptable because it’s a root CA. Biggest risk is that used algorithms might become deprecated over a period of 30 years.
- In 1998 was RSA2048 very strong. Today, it’s more like the absolute minimum, still ok. The 2¹⁶ + 1 public exponent is the perfect balance of efficiency and security.
- SHA1 self signature. Although SHA1 has broken strong collision resistance, in this case the root is trusted because of the browsers ‘Trust Store’. The certificate is still safe.
- PKCS#1 v1.5: not provably secure. No known practical attacks on v1.5 signatures
- Uses of critical extensions like for certificate signing and for CRL signing. Best practice

Changes for the future:
- Stronger keys: Upgrade the key to RSA 3072-bit or 4096-bit, or switch to the more efficient ECC (Elliptic Curve Cryptography).
- Modern hash algorithm: Use SHA-256 or SHA-384 instead of SHA-1 
- More secure signature scheme: Replace PKCS #1 v1.5 with RSA-PSS, since PSS, unlike v1.5, is mathematically provably secure.
- Shorter validity period: Consider a slightly shorter validity period (e.g., 15–20 years)


Source: 2.2.2 slide 14 – 24 (RSA), 47 (PKCS#1-1.5), slide 48 (RSA-PSS). 2.2.3 slide 15 (SHA1). 3.2 slide 28 - ... (X.509) slide 61, slide 55 (CRL) + Gemini
