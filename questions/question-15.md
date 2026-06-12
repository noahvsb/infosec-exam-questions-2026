# Question 15

There is a modified version of TLS (DTLS aka Datagram TLS) allowing to offer some kind of TLS over UDP.

**Which elements of the TLS Handshake and of the TLS Record Protocol should be modified to allow operation on top of UDP (instead of TCP)?**

*Reminder: for those who might have forgotten what UDP is, this is a very basic transport layer protocol, running on top of IP; it is connectionless, unreliable, but fast. Packets may arrive out of order or not at all.*

*Note: don't attempt to include all TCP features in TLS!*

## Answer

First of all, there would have to be taken measures to account for packet loss. Usually, this would be the responsibility of the TCP protocol, but in this case, there has to be an alternative. This could be done using a timer during the handshake (see schema below)
         
         Client                                   Server
         ------                                   ------
         ClientHello           ------>

                                 X<-- HelloRetryRequest
                                                  (lost)

         [Timer Expires]

         ClientHello           ------>
         (retransmit)


(https://datatracker.ietf.org/doc/html/rfc9147#section-5) 
 
DTLS 1.3 reuses the TLS 1.3 handshake messages and flows, with the following changes:

To handle message loss, reordering, and fragmentation, modifications to the handshake header are necessary.
Retransmission timers are introduced to handle message loss.
A new ACK content type has been added for reliable message delivery of handshake messages.
