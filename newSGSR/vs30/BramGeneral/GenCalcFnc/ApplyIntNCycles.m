function AnWin = ApplyIntNCycles(AnWin, BinFreq)
%APPLYINTNCYCLES    convert analysis window to an integer number of cyles
%   AnWin = APPLYINTNCYCLES(AnWin, BinFreq) converts the analysis window
%   AnWin to an analysis window representing an integral number of cycles
%   of a given binning frequency BinFreq. 

%B. Van de Sande 23-03-2004

Period = 1e3/BinFreq;
AnWin = (round((AnWin-AnWin(1))/Period)*Period)+AnWin(1);
idx = find(diff(AnWin) == 0); AnWin([idx, idx+1]) = [];