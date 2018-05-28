function MSF = maxStimFreq;

global SGSR

MSF = SGSR.samFreqs(end).*SGSR.maxSampleRatio(end);