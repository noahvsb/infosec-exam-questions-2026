# Question 8

When browsing the (secure) home page of the university in May 2022, these were the essential security properties I found in the chain of ceritifcates:

- The website (www.ugent.be) uses an RSA-4096 key pair ($PR_W, PU_W$). The public exponent of this key is $2^{16} + 1$.
- The key ($PU_W$) is certified in a X.509v3 certificate ($CA_S \ll W \gg$) by GEANT TLS RSA 1. This certificate states this key pair is intended for signing and key encipherment, and not for certification (critical V3 extensions). The validity of the certificate is from 2026-04-28 to 2026-11-1.3 This certificate has been signed using SHA2-256 as a hash function and the RSA-3072 private key ($PR_S$) of GEANT TLS RSA 1 (the public exponent of this key is also $2^{16} + 1$).
- The corresponding public key ($PU_S$) of GEANT TLS RSA 1 has in its turn been certified in a X.509v3 certificate ($CA_U \ll S \gg$) by HARICA TLS RSA Root CA 2021. This certificate states this key pair is intended for signing, for signing CRLs, and for signing (final) certificates (as a CA) (critical V3 extensions). The validity of the certificate is from 2025-01-03 to 2039-12-31. This certificate has been signed using SHA2-256 as a hash function and the RSA-4096 private key ($PR_U$) of HARICA TLS RSA Root CA 2021 (the public exponent of this key is also $2^{16} + 1$).
- Finally, the corresponding public key ($PU_U$) of HARICA TLS RSA Root CA 2021 is certified in a self-signed X.509v3 certificate ($CA_U \ll U \gg$). This certificate states this key pair is intended for signing, for signing CRLs, and for signing (final or intermediate) certificates (as a CA) (critical V3 extensions). The validity of the certificate is from 2021-02-19 to 2045-02-13. This certificate has been signed using SHA2-256 as a hash function.
- All signatures use PKCS #1 v1.5 formatting.

**Explain why the different security choices (algorithms, key lengths, validity periods) do or don't make sense.**

**Explain why you would keep or change these security choices.**

## Answer

TODO
