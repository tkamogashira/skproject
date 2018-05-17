This is a simulink simulation of Klatt model as per Sean McLennan's paper.

===============
To make it work
===============

Use the following command to generate constants required by model for synthesis:

[F0, ttf, A2, A3, A4, A5, A6, AB, AV, AH, AF, AVS, tt, F, BW] = makespeech2('aeou');

Output will show you the simulation time, set that time in Simulink.

call impul.m by following cmd:

[a b] = impul(ttf,F0);
FF1 = [a' b'];

By this FF1 gets the F0 pulse required by the model. impul.m works in place of flex-pulse section of Sean's klatt model.

then call inp.m by following cmd:

[t A] = inp(ttf, F0);
FF2 = [t' A'];

Now you are ready to simulate the model. Make sure that you have set the simluation time. and 'start simulation'.

Once the simulation is completed the synthesized audio will be storedin variable 'utter'.

listen to it by:

wavplay(utter.Data,10000);


=========================
  More about this work
=========================

This was the very first work I did in Speech processing in summer 2013. A very naive work.

This was part of my internship at Changwon National University, Changwon, South Korea.

This currently creates a very mechanical sound for vowels while only noise for consonants which require AWGN to be included. The thing I wanted to achieve and did achieved by this model is a very similar formant pattern/spectrogram as the real one for vowels. spectograms are also uploaded. Tough the synthesized speech's spectogrsm is (obviously) very mechanical.

I hope this will help somebody who is trying to do this for first time as I did. Though I am not an expert yet, still mail me if you need help on this.