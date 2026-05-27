# Case 3

Design the architecture for a regional/national healthcare data exchange system. This system must enable the exchange of patient records among hospitals, laboratories, and doctors. It should allow *authorized* healthcare professionals to access patient data. It should also allow patients to have a (possibly limited) view of their own personal medical data.

**What are the most essential security services? What security mechanisms would you use to implement those services (be sufficiently specific)? How would you secure the access to the service? What could be remaining vulnerabilities? Don't forget to consider system security and protection against malware. What are the legal aspects you need to take into account.**

*Note: I expect you to make a choice and to defend this choice. Don't present a range of possible solutions.*

## Answer

### Most essential security services
1. **Confidentiality**: healthcare data is very sensitive and should be only known to the patient and his healthcare provider (doctor etc.).
2. **Data integrity**: data abouth health should not be added/altered/deleted by an unauthorised person. 
3. **Data availability**: medical data could be needed in critical situations so this data data should always be always available and easy accessible.
4. **Authentication and Access Control**: Only people with legitimate reasons to view certain medical data should be allowed to (with authorisation). 
5. **Non-repudiation**: Data access should be logged. This logs should also be available to the patients (to see who has accessed their data). This is used in current platforms like COZO. 

### Security mechanisms to implement
**Availability**:
- Redundant servers
- Regular backups (encrypted, offsite)
- DDoS protection (request limits, ...)
**Confidentiality**  
- All data encrypted at rest: AES-256-GCM.
- Keys in Hardware Security Module
    * Keys never leave dedicated hardware. 
    * App requests hardware to do key operations.
    * Rotated periodically (replace old keys with new ones)
- All data in transit: TLS 1.3 (AES-256-GCM, ECDHE)
    * Same reasoning as case-02. 
- Level-encryption: medical information is encrypted in parts in stead of as a whole.
    * Not all information disclosed all together.
    * Allows to implement a role-based system where certain users have access to certain parts of the data. 

**Integrity**  
- All records digitally signed by the issuing party (hospital, lab, doctor) using Ed25519.
    * Proves who signed the data.
    * Proves that the data is not altered.
    * Uses small keys -> faster, more efficient
Ed25519 is based on elliptic curve cryptography (Curve25519), offering equivalent security to RSA-3072 with much smaller keys → faster signing and verification, less storage overhead.
- Any modification to a record creates a new signed version but the original is never overwritten

**Authentication and Access Control**
- To start using the application, a user have to authenticate itself using eID. 
- Health care providers can access the platform with eID together with their RIZIV number (registry of licensed professionals). Standard nightly sync, but for more critical revocations, an hourly sync can be used.
- When the user wants to use the application (after registration), he has to login with biometric authentication or a pincode. 
- Session stops after short time period (re-login). 
- To implement extra security, a user needs to reverify with MFA/eID after a certain amount of time. 
- Normal user should have a read-only version but should be able to rectify certain data (see legal aspects). This view should be limited and adapted (user-friendly in stead of just raw lab results).
- Role-based (only allowed to look at certain data) with referalls if needed.

**Non-repudiation**
- Tamper-evident audit logs: cryptographically chained, append only. The patient should be able to access these logs to see which entities have accessed their data.

### Legal aspects
- If certain medical data wants to be used in certain (scientific) research, the owner first have to give an informed consent to do so. 
- User has to give an informed consent to all care providers that want to see the data.
- User should be able to revoke all stored data. 
- User should be able to allow/deny certain users to view the data.
- User should be able to deny sharing certain data (even after earlier consent).
- GDPR: Right to view/correct data, right to file a complaint, ...
- Breach notification 

**System Security**
- Endpoint Protection Platform on all medical devices.
- Behaviour based identification of malware.
- Keep malware definition files up-to-date.
- Timely patch known vulnerabilities.
- Antivirus.
- Firewall: whitelist only necessary ports, separate network zones portal / professional tier / database tier,  no direct internet access to database.
- Web application firewall in front of the patient/care provider's portal that inspects and filters authorized but malicious traffic.
- Rule-based detection (IDS): anomaly detection, penetration identification, ...

### Remaining Vulnerabilities
- Insider threats (legitimate doctor abusing access). 
- Endpoint compromise (malware on workstation bypasses TLS/MFA) -> EPP!
- Social engineering / phishing targeting staff -> educate people!
- DDoS, national system is high-value target.
- HSM misconfiguration. 

### Sources
- <https://www.cozo.be/privacyverklaring>
- <https://www.uzgent.be/sites/default/files/documents/CoZo_leidraadIC.pdf>
- 2024_Information_Security_Exam_Questions_GVdV (3.23)
- Questions_Martijn_Hendrik - cases (case 20)
- IS_UG_3_7_Appl_System (notes)
- Claude-AI for further insights. 

_Status: complete_  
_Done by: Hann1bal20_