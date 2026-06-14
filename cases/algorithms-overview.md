# algorithms overview

This overview lists the most important algorithms you can use in the cases with the pros and cons.

# symmetric encryption

## AES

###### source: ppt 2.2.1 - slide 55; ppt 2.2 (PQC) - slide 11

key length: 128, 192 or 256 bits

### pros

- NIST standard for the coming decades
- significantly faster than 3DES

### cons

- symmetric
- strength halved with quantum computing (Grover's algorithm)

## AES with GCM-mode

###### source: ppt 2.2.3 - slide 70-71

galois counter mode (- mode)

### pros

- ensures confidentiality (CTR-mode encryption) + authentication (use of GMAC (galois MAC))
- provably secure

### cons

- use limit on secret key + IV (initialisation vector) usage


# asymmetric encryption

###### source: ppt 2.2.2 - slide 7

much slower than symmetric, longer key lengths needed

## RSA

###### source: ppt 2.2.2 - slide 14,28,46,48; ppt 2.2.3 - slide 88; ppt 2.2 (PQS) - slide 12

key length: 512, 768, 1024, 2048

512 and 768 have been broken

1024 not yet, but not future-proof

### pros

- most commonly used

### cons

- you can't reuse the same modulus, that would break forward-secrecy
- not quantum-proof (Shor's algorithm)

### schemes

**RSA-OAEP**  
provably secure encryption scheme assuming an ideal hash function

**RSA-PSS**  
provable secure signature scheme assuming an ideal hash function

## ElGamal

###### source: ppt 2.2.2 - slide 57,64,66; ppt 2.2 (PQS) - slide 12

key length: analogous to RSA

similar security to RSA

### pros

- you can reuse the modulus n, avoiding generation of prime and generator for each key pair, which is CPU intensive

### cons

- not quantum-proof (Shor's algorithm)

## ECC (Elyptic Curve Cryptography)

###### source: ppt 2.2.2 - slide 67

very analogues to ElGamal; with elliptic curves

# key exchange

(for key exchange use a key distribution center when possible)

## diffie-helman

###### source: ppt 2.2.4; ppt 2.2 (PQS) - slide 12

not quantum-proof (Shor's algorithm)

just look at 2.2.4 for the different variations and pros and cons

# hash functions

###### source: ppt 2.2.3 - slide 24,33,36; ppt 2.2 (PQS) - slide 11

SHA strength halved with quantum computing (Grover's algorithm)

## SHA-2

SHA-XXX

### pros

- most commonly used

### cons

- slower than SHA-1
- built on the same mechanism as SHA-1

## SHA-3

SHA3-XXX

### pros

- totally different design than the weakened MD5 and SHA-1
- easily adaptable hash value length
- performance an order of magnitude better than SHA-2 in hardware
- more potential for parallellisation than SHA-2 in software

### cons

- slightly worse performance than SHA-2 in software

## MAC

###### source: 2.2.3 - slide 52,63

message authentication code, a cryptographic checksum

HMAC with hash function

GMAC

## DSS/DSA

###### source: 2.2.3 - slide 79

digital signature standard/algorithm

relies on ElGamal, just an alternative scheme

## bcrypt

###### source: https://en.wikipedia.org/wiki/Bcrypt

### pros

- designed for password hashing
- automatic salting + slow by design to whitstand brute force attacks

### cons

- the slowness means it's more vurnerable to D(D)OS attacks

# ipsec

###### source: ppt 3.4

network level security

## AH (authentication header)

authentication

close to being deprecated

## ESP (encapsulating security payload)

confidential + (optional) authentication

# TLS

###### source: ppt 3.6

transport level security

## TLS 1.3

### improvements over 1.2

slide 37

# VPN

###### source: ppt 3.6

## problems with IPSec VPN

slide 47

## SSL or SSH VPN

new mac, new IP, new TCP header, while the originals become payload secured with SSH/SSL

### possible issues

slide 51
