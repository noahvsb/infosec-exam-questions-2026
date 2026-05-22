# Case 4

A company distributes software updates to millions of users via mirrors and content delivery networks (CDNs). Recent supply-chain attacks have made integrity and authenticity critical.

**Design a secure update system. Which security services are required? Which cryptographic mechanisms would you use to authenticate updates and protect against rollback attacks? How would you protect the signing keys? What remaining risks exist?**


## Terminology Explained

#### CDN (Content Delivery Network) & Mirrors
A CDN is a global network of third-party servers that store copies (“mirrors”) of software so that users can download updates from a geographically close location. This reduces load on the company’s central servers and improves download speed and reliability.

#### Supply-Chain Attack
A supply-chain attack occurs when an attacker compromises a step in the software distribution process, for example a CDN mirror, and replaces legitimate software with malware before it reaches the end user.

#### Rollback Attack
A rollback attack tricks a system into installing an older, officially signed version of software that contains known vulnerabilities, allowing attackers to exploit previously fixed bugs.

# Answer

## Part 1 — Required Security Services

From ch. 1, the six security services are evaluated in order below:

| **Security Service** | **Required?** | **Reasoning** | **What breaks without it** |
| --- | --- | --- | --- |
| **Confidentiality** | **No** | Updates are public artefacts — anyone may download them. Encrypting them adds cost with no security benefit. Exception: pre-release builds or internal metadata may warrant it. | N/A for public binaries. |
| **Authentication** | **Yes — critical** | Users must verify the update genuinely comes from the legitimate vendor, not a malicious mirror or supply-chain attacker. Both entity and data-origin authentication are needed. | Fake updates are indistinguishable from real ones → arbitrary code execution on millions of devices. |
| **Access Control / Authorisation** | **Yes — critical** | Only authorised personnel may trigger signing. The signing key must not be accessible to arbitrary employees or unapproved build systems. | An insider or compromised build pipeline can sign and ship a malicious update with a valid signature. |
| **Data Integrity** | **Yes — critical** | The downloaded binary must be bit-for-bit identical to what the vendor produced. Any modification in transit or on a mirror — even a single bit — must be detectable. | A tampered update installs silently → one modified byte can introduce a backdoor or RCE vulnerability. |
| **Non-Repudiation** | **Yes** | The vendor must not be able to deny publishing a specific version. Provides a verifiable audit trail: what was released, when, and signed by whom. | No accountability for a malicious signed update; post-incident forensics is impossible. |
| **Availability** | **Yes** | The update infrastructure must stay reachable, especially during active incidents when patching is most urgent. CDN mirrors help, but signing servers must also resist DoS. | Security patches cannot reach users → known vulnerabilities stay unpatched longer. |

---

## Part 2 — Cryptographic Mechanisms for Authenticity and Integrity

### Digital Signatures over a Hash

The core mechanism is a **digital signature** over a **cryptographic hash** of the update, as covered in ch. 2.3:

1. The vendor computes $h = H(\text{update file})$ using a strong hash function (SHA-256 or SHA-3).
2. The vendor signs the hash with their **private signing key**: $S = h^d \bmod n$ (RSA) or an ECDSA signature.
3. The signature $S$ and hash $h$ are published alongside the update (e.g. in a signed manifest).
4. The user's update client **verifies**: recomputes $h'$ over the downloaded file, recovers $h$ from $S$ using the vendor's **public key**, and checks $h' = h$.

**Why hash first?** Asymmetric operations are 100–1000× slower than symmetric ones (ch. 2.3). Signing a full update of hundreds of MB directly is infeasible. Hashing reduces the input to a fixed-size digest (e.g. 256 bits) which is then signed — cheap and equally secure.

**Algorithm choices:**

- **RSA-PSS** (PKCS#1-v2.1): provably secure — forging a signature is as hard as solving RSA itself (ch. 2.3). Use ≥ 2048-bit keys.
- **ECDSA with P-256 or Ed25519**: shorter keys (256-bit ≈ 128-bit security), faster signing and verification. Preferred in modern systems.
- **Hash: SHA-256 or SHA-3-256** — collision-resistant; no known practical attack.

### Signed Manifest File

<aside>
📖

A **manifest** is not a term from the course chapters — it is a standard engineering pattern used in real update systems (e.g. apt, Windows Update, npm). It is explained in full here.

</aside>

The digital signature described above authenticates the update, but in practice a software release consists of many files (installer, libraries, config, checksums…). Signing each file individually would require the client to perform thousands of separate signature verifications and would give no single authoritative statement of what the complete update consists of.

The solution is a **manifest**: a structured text file (e.g. JSON) produced by the vendor that lists:

- Every file in the update with its SHA-256 hash
- The version number of this release (used for rollback protection — see below)
- A timestamp

The vendor then signs only the manifest with their private key — one signature operation covers the entire release. The client:

1. Downloads the manifest and verifies the signature → proves the manifest is authentic and unmodified
2. Downloads each update file and recomputes its hash, comparing against the manifest → proves each file is what the vendor declared

The manifest is therefore an **addition** to, not a replacement for, the digital signature mechanism:

- The **digital signature** (ch. 2.3) proves the manifest itself is authentic
- The **hash function** (ch. 2.3) proves each individual file matches what was declared
- The **manifest** is the glue — it atomically binds all files, the version number, and the timestamp into one signed statement

Without the manifest, there would be no natural place to embed the version counter needed for rollback protection, and the client would have no way to know which set of files collectively constitutes a complete, coherent update.

### Protection Against Rollback Attacks

A **rollback attack** is when an attacker replaces a newer (patched) update with an older (vulnerable) version. Both old and new versions have valid signatures — signature verification alone cannot distinguish them.

The manifest therefore embeds both a **version number** and a **timestamp**, each solving a distinct problem that the other cannot:

|  | **Rollback prevention** | **Non-repudiation / audit** | **Delay detection** |
| --- | --- | --- | --- |
| **Version number only** | ✅ client refuses lower versions | ❌ no time information | ❌ |
| **Timestamp only** | ❌ no ordering the client can enforce | ✅ proves when it was signed | ✅ client can notice a delayed update |
| **Both together** | ✅ | ✅ | ✅ |

**Why the version number alone is not enough:** it prevents rollback but provides no time information. For non-repudiation, the vendor could claim a malicious update was released at a different time. There is also no way to detect an attacker who delays delivery — the client stays on an old version without knowing a newer one exists.

**Why the timestamp alone is not enough:** a timestamp proves *when* something was signed, but gives the client no enforceable ordering. An attacker replaying an old manifest (valid signature, valid old timestamp) looks legitimate — the client has no stored baseline to compare against. Timestamps are also forgeable if the signing key is compromised (ch. 3.1: an attacker with the private key can produce any timestamp they like), whereas a monotonic version counter stored locally on the client cannot be rewound by an attacker who only has the signing key.

**Implementation:**

- The manifest includes a **monotonically increasing version number** and a **trusted timestamp** (countersigned by a TTP per ch. 3.1), both covered by the vendor’s signature.
- The client stores the **highest version number ever seen** and refuses any lower version.
- The client also checks the timestamp is not older than a defined threshold — detecting delivery-delay attacks.

---

## Part 3 — Protecting the Signing Keys

The signing private key is the most critical asset in the whole system. If compromised, an attacker can sign arbitrary malicious updates that every client accepts without warning.

### Hardware Security Module (HSM)

<aside>
📖

**HSM** is not mentioned in the course chapters. It is a standard hardware device used in industry to protect cryptographic keys and is explained in full here.

</aside>

An **HSM (Hardware Security Module)** is a tamper-resistant hardware device that:

- Generates and stores the private key internally — the key never exists in plaintext outside the device
- Exposes only a signing API: software sends a hash in, gets a signature back
- Physically destroys the key if tampering is detected

This protects against external attackers who compromise the build server and malicious insiders who attempt to copy the key.

### Why Not One Key in One HSM?

If an HSM is so secure, why not put a single key in it and use that for everything? The problem is a fundamental contradiction between **availability** and **security**:

- To sign every release, the key must be online and reachable by the automated build pipeline — potentially many times per day. The more a key is used and the more systems can reach it, the larger the attack surface. An HSM attached to an internet-facing build server is exposed to network attacks, software vulnerabilities in the build pipeline, and insider threats around the clock.
- A key that is never connected to any network (air-gapped) is practically immune to remote attack — but cannot be used for daily operations.

**A single key cannot satisfy both simultaneously.**

There is a second problem: if the one key is compromised, every client in the world trusts whatever the attacker signs. To recover, a new trusted key must be distributed to all clients — but how? Clients trusted the old key; they have no reason to trust a new one unless something they already trust vouches for it. Without a pre-established trust anchor, key rotation after compromise is practically impossible at scale.

### Key Hierarchy and Separation of Roles

The solution mirrors exactly the **root CA → intermediate CA** hierarchy from ch. 3.2: different keys serve different roles with different security/availability tradeoffs.

| **Key** | **Location** | **Used how often** | **Role** | **Why this design** |
| --- | --- | --- | --- | --- |
| **Root key** | Offline, air-gapped HSM — never touches a network | Extremely rarely — only to sign or revoke intermediate keys | Trust anchor: public key hardcoded in every client at install time | Being offline makes it immune to remote attack. Even if the build pipeline is fully compromised, the root key is safe. If the intermediate key is compromised, the root revokes and replaces it — clients keep trusting the root and accept the new intermediate automatically. |
| **Intermediate signing key** | Online, HSM attached to build pipeline | Every release — daily or more | Signs the release manifest for every update | Being online enables automation. Being in an HSM prevents direct key extraction. Its limited validity period bounds the damage from a silent compromise. The root key can revoke it immediately if compromise is detected. |

<aside>
💡

This is the same structure as **root CA → intermediate CA** in ch. 3.2. Root CAs are offline and rarely used; intermediate CAs do the daily signing work; if an intermediate is compromised, the root revokes it without updating every client. Identical principle.

</aside>

**Is the intermediate key also in an HSM?** Yes — the distinction is not HSM vs. no HSM but online vs. offline. An online HSM is still attached to a build server that could be compromised. An attacker cannot extract the key, but could feed it malicious data to sign through the compromised server. So the intermediate key in an online HSM is far more secure than a key file on disk, but still carries more inherent risk than an air-gapped root.

### Multi-Party Authorisation

No single person should be able to trigger a signing operation alone. Require $m$**-of-**$n$ **authorisation** (e.g. 3 out of 5 senior engineers must approve) before the HSM signs a new release. This prevents a single compromised or malicious employee from publishing a rogue update.

### Key Rotation and Revocation

- **Regular key rotation**: replace intermediate signing keys periodically — limits the exposure window if an older key was silently compromised.
- **Certificate Revocation** (ch. 3.2): if a key is compromised, a Certificate Revocation List (CRL) entry is published immediately. Clients must check revocation status before trusting any signature.

---

## Part 4 — Remaining Risks

Even with all of the above in place, several risks remain that cannot be fully eliminated:

| **Risk** | **Description** | **Mitigation (partial)** |
| --- | --- | --- |
| **Compromised build pipeline** | An attacker who gains access to the build system before signing can inject malicious code into the binary before it is hashed and signed. The signature will then be valid over the malicious binary. This is the classic supply-chain attack (e.g. SolarWinds). | Reproducible builds, isolated build environments, integrity monitoring of the build pipeline, multiple independent builds compared before signing. |
| **Compromised update client** | If the update client itself is replaced or tampered with, it may accept forged updates regardless of the signature scheme. The verification logic must itself be trusted. | OS-level code signing for the update client; secure boot to verify the client at startup. |
| **Key compromise despite HSM** | Side-channel attacks on HSMs (timing, power analysis — ch. 2.3) or insider threats in the authorisation quorum could lead to key extraction. A nation-state attacker may have capabilities beyond standard HSM resistance. | Use HSMs certified to FIPS 140-3 Level 3 or higher; minimise access to the HSM; audit logs of all signing operations. |
| **Algorithm obsolescence** | RSA-2048 and ECDSA with P-256 will become vulnerable to quantum computers running Shor's algorithm (ch. 4). Long-term deployed devices may still be in use when this becomes practical. | Plan migration to post-quantum signatures (e.g. CRYSTALS-Dilithium, SPHINCS+). Update the manifest format to support algorithm agility. |
| **Revocation not checked** | Clients in offline or restricted environments may not check CRLs, leaving them trusting a revoked signing key for an extended period. | Embed revocation information in the signed manifest itself (stapling); enforce a maximum validity window after which the client re-checks. |
| **First-install trust problem** | When a user installs the software for the first time, they must somehow obtain and trust the vendor's public key. If this initial distribution is compromised, all subsequent signature checks are worthless. | Ship the public key hardcoded in the installer; distribute via multiple independent channels; use OS vendor trust stores. |

---

## Part 5 — Summary of the Proposed Design

| **Component** | **Choice and rationale** |
| --- | --- |
| **Signature algorithm** | Ed25519 (ECDSA variant) or RSA-PSS with 2048-bit key — provably secure, efficient verification on client devices |
| **Hash function** | SHA-256 — collision resistant, fast, universally supported |
| **Signed artefact** | Signed manifest containing hash + version number + timestamp for every component |
| **Rollback protection** | Monotonically increasing version counter in the signed manifest; client refuses downgrades |
| **Key storage** | FIPS 140-3 Level 3 HSM; root key offline and air-gapped; intermediate key online in HSM only |
| **Authorisation** | $m$-of-$n$ multi-party approval before any signing operation |
| **Key management** | X.509 certificate chain (ch. 3.2); regular rotation; CRL/OCSP for revocation; public key pre-installed in client |
| **Remaining risk** | Build pipeline compromise; quantum threat; first-install trust — addressed through procedural controls and post-quantum migration planning |

# Source
Concepts from the course notes are mentioned from which chapter they come from. New concepts are mentioned why they are used here and what there are. Claude put it all together.