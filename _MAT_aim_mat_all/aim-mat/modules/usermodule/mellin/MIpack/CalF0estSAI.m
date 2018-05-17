%
%    Calculation of F0 from Summary SAI 
%    Irino, T.
%    31 Jan 00
%    modified from CalPeakSumSAI(SAIval, fs, NumPeak);
%
%    function [F0estSAI, MeanSAI, ModMeanSAI] ...
%             = CalF0estSAI(SAIval, fs, Frs, StrobeLoc, MaxF0, PreF0);
%    INPUT:  SAIval : SAI value
%            fs     : Sampling frequency
%            StrobeLoc: Number of Strobe Location (TimeInterval == 0)
%	     MaxF0:  Maximum value of F0
%	     PreF0:  Pre-Estimated value of F0
%    OUTPUT: F0estSAI: Estimated F0 from SAI
%            MeanSAI:   Summary of SAI
%            ModMeanSAI: Modified version of MeanSAI for period detection
%
function [F0estSAI, MeanSAI, ModMeanSAI, F0estSAIprof, ProfSAI ] ...
             = CalF0estSAI(SAIval, fs, Frs, StrobeLoc, MaxF0, PreF0);

if nargin < 4, StrobeLoc = 5*fs/1000+1; end; % at 5 ms
if nargin < 5, MaxF0 = 400; end;
if nargin < 6, PreF0 = 150; end;

MinF0 = 80;
MeanSAI = mean(SAIval);
[NCh LenSAI] = size(SAIval);

[dummy nc1] = min(abs(Frs-500));
% wgtChSAI = [ (1:nc1)'/nc1; ones(NCh-nc1,1)]; useless
wgtChSAI = ones(NCh,1);

nTilt = StrobeLoc + fix(fs/max(PreF0,MinF0)); % F0 > 80 Hz
nnt = [0:(LenSAI-nTilt)];
wgtTISAI = [zeros(1,StrobeLoc-1), ones(1,nTilt-StrobeLoc),  ...
		(1 - nnt/max(nnt)) ];
ModMeanSAI = mean((wgtChSAI*wgtTISAI).*SAIval);

%[dummy nc0] = min(abs(Frs-70)); % Frs > 100
nc0 = 1;
wgtProSAI = [zeros(1,nc0), (1 - ((nc0+1):nc1)/nc1) zeros(1,NCh-nc1)]';

ProfSAI = wgtProSAI.*mean(SAIval')';
[dummy mp] = max(ProfSAI);
F0estSAIprof = Frs(mp);

ThreshUV = 0.95;

   F0estSAI = 0;
   if  max(MeanSAI) == 0, F0estSAI = 0; return; end;

   [PeakVal1 PeakLoc1 ] = max(MeanSAI);
   if PeakLoc1 ~= StrobeLoc;	
  	disp([ 'StrobeLoc is strangely detected at ' int2str(PeakLoc1)]);
	F0estSAI = 0;
 	return;
   end;

   ModMeanSAI2 = ModMeanSAI;
   nz = StrobeLoc+(0: fix(fs/MaxF0)-1);
   ModMeanSAI2(nz) = zeros(size(nz)); % suppress 1st peak
   [PeakVal2 PeakLoc2] = max(ModMeanSAI2);
   F0estSAI = fs/(PeakLoc2-StrobeLoc);
	
   [TroughVal dummy] = min(ModMeanSAI(StrobeLoc:PeakLoc2));
   if TroughVal/PeakVal2 >= ThreshUV;
	F0estSAI = 0;
   end; 



