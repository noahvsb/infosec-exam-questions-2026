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
**Confidentiality**  
- All data encrypted at rest: AES-256-GCM.
- Keys in Hardware Storage Module
    * Keys never leave dedicated hardware. 
    * App requests hardware to do key operations.
    * Rotated periodically (replace old keys with new ones)
- All data in transit: TLS 1.3 (AES-256-GCM, ECDHE)
    * Same reasoning as case-02. 
- Level-encryption: medical information is encrypted in parts in stead of as a whole.
    * Not all information disclosed all together. 

**Integrity**  
- All records digitally signed by the issuing party (hospital, lab, doctor) using Ed25519.
    * Proves who signed the data.
    * Proves that the data is not altered.
    * Uses small keys -> faster, more efficient
- Any modification to a record creates a new signed version but the original is never overwritten

### Sources
- 
- Claude-AI for further insights. 

_Status: Incomplete_  
_Done by: Hann1bal20_