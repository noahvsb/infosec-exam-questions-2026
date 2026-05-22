# Question 9

The TLS 1.3 handshake achieves mutual agreement on keys while authenticating the server.

**Explain how server authentication is achieved in the TLS 1.3 handshake.**

**What is the purpose of the Certificate, CertificateVerify, and Finished messages?**

**Why is the Finished message cryptographically essential even after certificate verification?**

## Answer

#### **How Server Authentication is Achieved:**
In the TLS 1.3 handshake, server authentication is achieved via the **Certificate**, **CertificateVerify** and **Finished** messages.

*   **Certificate:** The Certificate message that the server sends, contains a chain of X.509v3 certificates. This message gives the client the server’s public key and proves to the client that a CA has verified the server’s identity. The client then checks this chain to ensure that the certificate is valid.
*   **CertificateVerify:** However, just sending the certificate is not enough to prove the identity. The server must also show that it actually has the private key corresponding to the public key sent in the Certificate. The server does this by generating a digital signature over the entire handshake up to this point using the private key (Done using RSA-PSS usually). Now the server has proved to be a legitimate user of the certificate.

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
