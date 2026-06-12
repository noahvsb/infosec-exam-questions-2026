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

- RSA 4096 key pair: RSA 4096 might be a bit overkill for the university website. RSA 1024 is not even broken yet. The larger key adds some computational work, so i would argue that for this case RSA 2048 would be secure enough. The public exponent is also industry standard. Nothing about this choice is vulnerable, so could be kept. 

- X509 certificate: All of this makes sense. The university can not use its certificate to certify other certificates (job of CA). A one year validity period is safe. If it's too long, key might be compromised or security algorithms might be compromised. Signed using SHA2 256 is also a secure choice. 

- PRs should not use the relatively small exponent 2^16+1 (this is only recommended for public keys)

- PUs certification: All of this could be kept. 12 year validity period might be long, but in this case, it uses secure algorithms that are near-future proof (RSA 4096, SHA2 384). Nothing out of the ordinary here. 

- PUu certification: The certificate is self-signed, which means we're talking about a root CA here. The certificate has a validity period of 28 years, which is LONG. The reason for this is that a root certificate is baked in browser's settings/files. To update this certificate would require some work, and for old browsers, this could be a problem (if they dont update it anymore).  I dont see anything stating the RSA key length used for this certificate, but i would assume its RSA 4096 or something equally secure. 

- signed using PKCS 1.5: In future versions, this would ideally be changed to something more secure, like RSA PSS. 

In general, there is not really anything that i would change here. The only thing i would consider is changing the validity period of the root certificate to a shorter period of time, and changing the signing of the certificates to RSA-PSS.
