%
%    Calculation of Peaks in Summary SAI 
%                       (Candidates of Auditory Figure Boundary)
%    Irino, T.
%    5 Jan. 98
%
%    function [PeakLoc, PeakVal, PitchVal] ...
%             = CalPeakSumSAI(SAIval, fs, NumPeak);
%    INPUT:  SAIval : SAI value
%            fs     : Sampling frequency
%            NumPeak: Number of peaks to detect
%	     ExpPeak1: Expected Peak1
%    OUTPUT: PeakLoc: Peak location in sampling points
%            PeakVal: Peak value
%            PitchVal: Pitch Value in ms
%
function [PeakLoc, PeakVal, PitchVal] ...
	= CalPeakSumSAI(SAIval,fs,NumPeak);

if nargin < 3, NumPeak = 3; end;
if nargin < 4, verbose = 0; end;

SumSAI = sum(SAIval);

if  max(SumSAI) > 0,
	for np = 1:NumPeak,
	  [vv mm ] = max(SumSAI);
	  PeakVal(np) = vv;
	  PeakLoc(np) = mm;
	% zp = -1*fs/1000:1.5*fs/1000;  % remove for search next peak
	  zp = -1*fs/1000:2.5*fs/1000;  % max 400 Hz
	  zzp = mm+zp;
	  SumSAI(zzp(zzp>0)) = zeros(size(zzp(zzp>0)));
	  if np == 1, SumSAI(1:mm-1) = zeros(1,mm-1); end; 
		% remove negative peak
	end;
	PitchVal = (PeakLoc(2)-PeakLoc(1))/fs*1000;
else
	PeakLoc = 0;
	PitchVal = 0;
end;

if 0,
   disp('Peak Positions in Sammry SAI (Zero point candidates):');
   disp([PeakVal; PeakVal/fs*1000]);
   disp(['Estimated Pitch Value = ' num2str(PitchVal) ' ms']);
end;




