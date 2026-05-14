# Case 15

**What security services will be needed to enable electronic cash for small online payments? What security mechanisms and protocol would you use to implement these security services?**

The goal is to develop a user-friendly, but correctly secured, mechanism for paying small amounts online. For these small payments, systems such as credit card, debit card, whether or not using a token such as the Digipass, are not ideal in terms of usability or cost structure.

The emphasis is therefore on ease of use and simplicity of use, but the security must still be sufficient for users to be able to trust the system. Such a system could be somewhat similar to an electronic version of cash.

Consider the following aspects for your implementation:

- Avoid an overly cumbersome payment procedure on the client side (otherwise we might as well use two-factor authentication).
- Avoiding replay is essential. With regular cash, this problem is simple: you hand over the money on payment and printing is (approximately) impossible. With an electronic payment, of course, things are somewhat different.
- If necessary, you may use a trusted third party.

## Answer

TODO
