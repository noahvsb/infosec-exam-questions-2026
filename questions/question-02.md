# Question 2

Intrusion detection systems must balance detection accuracy with operational usability.

**Explain the concepts of false positives and false negatives in intrusion detection.**

**Why are false positives often the more severe operational problem in practice?**

**Discuss how alert fatigue arises and why it undermines security monitoring.**

## Answer

• False Positive: Overlap of Innocence. This happens when a legitimate user performs an action that looks like an attack. This user then is behav- ing like an intruder (mistyping password 3 times, massive data export,...)

• False Negative: Overlap of Guilt. This happens because an attacker aims to blend in. They try to make their malicious actions look like legitimate user behavior (logging in during business hours, low and clear scanning). If they succeed in this blending in, the Intrusion Detection System (IDS) will miss them.

• FP more severe operational problem: FPs are often the bigger operational problem just because of the frequency of them. In any given network, there are millions of legitimate actions with maybe only one or two real attacks. A small overlap to the ”intruder” side leads to a massive amount of false positives.

• Alert Fatigue: This arises when the IDS is too sensitive. Sometimes the focus of the IDS is set too much on minimizing the false negatives that the number of false positives gets increased massively. If this happens we get a flood of data where True Positives get buried under the noise of all the False Positives. This undermines security because analysts become numb to the alarms (blindy clicking ignore,...), it increases response time (Even at a real attack, it takes a while to actually find it when sifting through thousands of fake alerts). Losing an alert in thousands of other alerts is a big security risk for a lot of attacks. This is why prevention will always be more important than detection.

**source**
IS_UG_3_7_Appl_System slide 42 + 77-80 + 92 + Gemini
