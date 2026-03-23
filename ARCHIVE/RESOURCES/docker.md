---
tags:
  - IMPORTANT
---

linux@archlinux  ~  gpg --full-generate-key  
gpg (GnuPG) 2.4.9; Copyright (C) 2025 g10 Code GmbH  
This is free software: you are free to change and redistribute it.  
There is NO WARRANTY, to the extent permitted by law.  
  
Please select what kind of key you want:  
  (1) RSA and RSA  
  (2) DSA and Elgamal  
  (3) DSA (sign only)  
  (4) RSA (sign only)  
  (9) ECC (sign and encrypt) *default*  
 (10) ECC (sign only)  
 (14) Existing key from card  
Your selection? 9  
Please select which elliptic curve you want:  
  (1) Curve 25519 *default*  
  (4) NIST P-384  
  (6) Brainpool P-256  
Your selection? 1  
Please specify how long the key should be valid.  
        0 = key does not expire  
     <n>  = key expires in n days  
     <n>w = key expires in n weeks  
     <n>m = key expires in n months  
     <n>y = key expires in n years  
Key is valid for? (0) 0  
Key does not expire at all  
Is this correct? (y/N)    
Key is valid for? (0) 0  
Key does not expire at all  
Is this correct? (y/N)    
Key is valid for? (0)    
Key does not expire at all  
Is this correct? (y/N) Y  
  
GnuPG needs to construct a user ID to identify your key.  
  
Real name: Abhishek  
Email address: 1289185k@gmail.com  
Comment:    
You selected this USER-ID:  
   "Abhishek <1289185k@gmail.com>"  
  
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?    
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O  
We need to generate a lot of random bytes. It is a good idea to perform  
some other action (type on the keyboard, move the mouse, utilize the  
disks) during the prime generation; this gives the random number  
generator a better chance to gain enough entropy.  
We need to generate a lot of random bytes. It is a good idea to perform  
some other action (type on the keyboard, move the mouse, utilize the  
disks) during the prime generation; this gives the random number  
generator a better chance to gain enough entropy.  
gpg: directory '/home/linux/.gnupg/openpgp-revocs.d' created  
gpg: revocation certificate stored as '/home/linux/.gnupg/openpgp-revocs.d/6DB042609CF0884B6C  
A14E62708E3F663776BAC5.rev'  
public and secret key created and signed.  
  
pub   ed25519 2026-03-13 [SC]  
     6DB042609CF0884B6CA14E62708E3F663776BAC5  
uid                      Abhishek <1289185k@gmail.com>  
sub   cv25519 2026-03-13 [E]