# Question 9

The TLS 1.3 handshake achieves mutual agreement on keys while authenticating the server.

**Explain how server authentication is achieved in the TLS 1.3 handshake.**

**What is the purpose of the Certificate, CertificateVerify, and Finished messages?**

**Why is the Finished message cryptographically essential even after certificate verification?**

## Answer

#### **How Server Authentication is Achieved:**
In the TLS 1.3 handshake, server authentication is achieved via the **Certificate**, **CertificateVerify** and **Finished** messages.

*   **Certificate:** The server sends a chain of certificates (X.509v3 by default) but it is negotiated in encrypted extension. This chain binds the server's identity (domain name) to its public key, vouched for by a Certificate Authority the client trusts. The client validates the chain against its trust anchors, "if no trust can be established by the client, the handshake will be aborted." On its own, though, the certificate only contains a public key; anyone can copy and replay a certificate, so it is not yet proof of identity.
*   **CertificateVerify:** The server computes a digital signature over the entire handshake transcript up to this point, using the private key corresponding to the public key in the Certificate message. This is what "proves the server is the legitimate user of this certificate" (slide 28). Because:
	  - only the genuine key-owner can produce a signature that verifies against the certificate's public key, and
	  - the signature covers the transcript (including the fresh ClientHello/ServerHello randoms and the ephemeral DH shares),

  it simultaneously proves possession of the private key and binds that proof to this specific, live handshake — defeating replay and man-in-the-middle attacks. TLS 1.3 uses RSA-PSS rather than the older v1.5 padding (slide 37).

Lastly, we just need to finalize the authentication via the **Finished** message.

This message contains the **Message Authentication Code (HMAC)** computed over the entire handshake history using a key derived from the server handshake traffic secret. This message ensures that no ”Man-in-the-middle” tampered with the unencrypted messages in the beginning. By verifying this HMAC, the client receives definitive proof that the server has derived the exact same secret keys as the client.

This message marks the end of the Server Authentication in the TLS 1.3 Handshake.

#### **Finished message cryptographically essential:**
This message is cryptographically essential because it provides handshake authentication and key confirmation, which the CertificateVerify alone does not do.

*   **Certification:** Provides chain of X.509v3 certificates.
*   **CertificateVerify:** Provides digital signature over handshake using its private key $\rightarrow$ Prove server is legitimate owner of public key.
*   **Finished:** Provides Handshake integrity via HMAC over entire handshake history. Ensures no MitM. And most importantly **key confirmation** of the handshake traffic secret that depends on the ECDH exchange and the HKDF process. 

It’s also a secure boundary where the handshake protocol must be finished and authenticated before using the traffic secrets to encrypt the actual data. Otherwise, parties could send data using improper and insecure keys.

The **Finished** message proves that the entire session setup is correct and consistent.

**Source**: Slides 3.6 TLS 27-37 + Gemini
