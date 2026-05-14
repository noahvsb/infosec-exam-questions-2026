# Question 20

When browsing the (secure) home page of the healthcare platform CoZo in May 2026, these were the essential security properties I found in the chain of ceritifcates:

- The website (www.cozo.be) uses an RSA-4096 key pair ($PR_W, PU_W$). The public exponent of this key is $2^{16} + 1$.
- The key ($PU_W$) is certified in a X.509v3 certificate ($CA_T \ll W \gg$) by R12 (Let's Encrypt). This certificate states this key pair is intended for signing and key encipherment, and not for certification (critical V3 extensions). The validity of the certificate is from 2026-03-19 to 2026-06-17. This certificate has been signed using SHA2-256 as a hash function and the RSA-2048 private key ($PR_T$) of R12 (Let's Encrypt) (the public exponent of this key is also $2^{16} + 1$).
- The corresponding public key ($PU_T$) of R12 (Let's Encrypt) has in its turn been certified in a X.509v3 certificate ($CA_D \ll T \gg$) by ISRG Root X1. This certificate states this key pair is intended for signing, for signing CRLs, and for signing (final) certificates (as a CA) (critical V3 extensions). The validity of the certificate is from 2024-03-13 to 2027-03-12. This certificate has been signed using SHA2-256 as a hash function and the RSA-4096 private key ($PR_D$) of ISRG Root X1 (the public exponent of this key is also $2^{16} + 1$).
- Finally, the corresponding public key ($PU_D$) of ISRG Root X1 is certified in a self-signed X.509v3 certificate ($CA_D \ll D \gg$). This certificate states this key pair is intended for signing, for signing CRLs, and for signing (final or intermediate) certificates (as a CA) (critical V3 extensions). The validity of the certificate is from 2015-06-04 to 2035-06-04. This certificate has been signed using SHA2-256 as a hash function.
- All signatures use PKCS #1 v1.5 formatting.

**Explain why the different security choices (algorithms, key lengths, validity periods) do or don't make sense.**

**Explain why you would keep or change these security choices.**

## Answer

TODO
