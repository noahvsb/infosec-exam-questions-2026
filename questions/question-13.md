# Question 13

Explain with sufficient detail how the dialogue between a client (C) and a Kerberos ticket granting server (TGS) works.

**What are the elements that guarantee the authenticity of the involved entities (C and TGS)? What are the possible consequences if an intruder succeeds in capturing the ticket granting ticket (TGT)? How is replay prevented? What cryptographic algorithms could be used (algorithm, mode, key length, etc.)?**

*Note: you may assume that only symmetric encryption mechanisms are used in this dialogue.*

## Answer

The dialogue between user C and Ticket Granting Server (TGS) goes as follows:

1. **User (C) sends ticket-granting ticket (TGT) and authenticator (both received from AS) to TGS.**  
version5: ```Options || ID_v || Times || N_2 || TGT || Auth_C```

- ID_v: server identifier
- N_2: nonce
- Times: time settings (start, validity, new validity) requested for SGT
- Auth_C: E_K(C,TGS)[ID_C || Realm_C || TS_1]
=> Client authenticator
=> E_K(C,TGS)[...]: encrypted using K(C,TGS) session key
=> TS_1: time stamp makes replay impossible
- Realm: domain (UGENT.BE, ...)

2. **TGS verifies TGT and generates a ticket for requested server.**    
version5: ```Realm_C || ID_C || SGT || E_K(C,TGS)[K_C,V || Times || N_2 || Realm_V || ID_V]```

- SGT: Service-granting ticket
=> Intended for the server
=> E_KV[...]: Encrypted using K_V (secret key for server)
=> K_CV: Session key for C<-->V communication
Realm_V: server Kerberos realm

Authenticity of the different entities are guaranteed as followed:
- C: TGT + Auth_C(TS): client is active now, no replay
- TGS: Responds to the sent nonce by C, this is encrypted with K_C,TGS which only the real TGS could make.

Assume an intruder (Trudy) has succeeded in capturing the TGT. 

The TGT is encrypted by E_K(TGS) so no user can read or forge this TGT, but can only forward it to the ticket granting server (TGS). Because, whilst sending to the TGS, the authenticity of C is also checked in Auth_C where also an encrypted timestamp is used (TS_1), Trudy cannot execute a replay attack to get the SGT from the TGS. The only thing Trudy could do is a brute force attack on this encrypted TGT. But if the right encryption algorithm is used, this is hardly/not possible (at least for now)...

The cryptographic algorithms that could be used here are:
- AES-GCM could be used to both encrypt and authenticate messages, with a key preferably length of 256 bits.
- An alternative could be AES-CBC with a key length of 256 bits for encryption, but then a separate authentication mechanism has to be provided (e.g. CBC-MAC).

### Sources
- IS_UG_2_2_3_SecM_HashMac (notes).
- IS_UG_3_2_Appl_AuthMeth (notes).
- Claude-AI for further insights.
 
_Status: Complete_  
_Done by: Hann1bal20_