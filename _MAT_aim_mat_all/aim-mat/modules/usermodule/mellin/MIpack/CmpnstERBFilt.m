%
%	Compensation Env+Phase of ERB Filter 
%	IRINO Toshio
%	14 Oct 93
%	16 Dec 93 : ChERB->ChFreq 
%
%	function CmpnstVal = CmpnstERBFilt(ValIn,ChFreq,SR,TCmpnst),
%	INPUT	ValIn	: Value for Each Ch 	(NumCh * LenSnd)
%		ChFreq  : Frequency at each Ch (NumCh)
%		SR	: Sampling Rate
%		TCmpnst : Compensation Time (ms) at 1kHz (default 2 ms);
%			( Amount = Tcmpnst(1kHz)*1000/ChFreq.)
%
function CmpnstVal = CmpnstERBFilt(ValIn,ChFreq,SR,TCmpnst),

if nargin < 4, TCmpnst =2.00; end;

disp('*** Compensation of Lag of GammaTone Filter ***');
if max(ChFreq) < 40,
	error('It might be ERB.  Convert ERB -> Freq !');
end;
ChERB = Freq2ERB(ChFreq);

[NumCh LenVal] = size(ValIn);

NCmpnst = TCmpnst*SR/1000;

CmpnstVal = zeros(size(ValIn)); % To take working memory for speed up.
for nch =1:NumCh,
if rem(nch,20) == 0 | nch == NumCh
disp(['Compensate ERB : Ch #' int2str(nch) '/' int2str(NumCh) ]);
end;
np = fix(NCmpnst*1000/ChFreq(nch))+1;

if np > LenVal,
error('Sampling point for Compensation is greater than the signal length.');
end;

CmpnstVal(nch,1:LenVal) = [ValIn(nch,np:LenVal) zeros(1,np-1)];
end;

% Do not dispplay here. Time consuming. 5 Aug. 94
% PlotTimeERB('Compensated NAP',CmpnstVal,ChERB,SR)
%

