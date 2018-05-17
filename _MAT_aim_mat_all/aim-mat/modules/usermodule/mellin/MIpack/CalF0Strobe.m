%
%	Calculation of Strobe point from F0 information
%	5 Jun 2002
%	Irino, T.
%
%
%
function [ NAPPhsCmp, StrobeInfo, STBparam ]  ...
	         = CalF0Strobe(NAP,NAPparam,STBparam)

fs  = NAPparam.fs;
Frs = NAPparam.Frs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3, STBparam = []; end;
if isfield(STBparam,'ExtDur') == 0,  STBparam.ExtDur = [];   end;
if length(STBparam.ExtDur) == 0, 
	STBparam.ExtDur  = [0.5 1.5];  % Strobe Timing Range Extension
	% better than [0.5 2] or [0.5 1] 
end;

if isfield(STBparam,'F0per1ms') == 0,  
	error('Specify STBparam.F0per1ms'); % F0 value for every 1ms
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
disp('*** Calculation of Strobe Point ***');

[NumCh LenNAP] = size(NAP);
DelayNAPPhsCmp = 2.0;     % strict & better
NAPPhsCmp = CmpnstERBFilt(NAP,Frs,fs,DelayNAPPhsCmp);

% disp('******* F0 per 1ms to rough Event Timing *********'); 
TPper1ms = 1000./STBparam.F0per1ms; 
tmsCur = 0; 
cnt = 0; 
RoughEventTms = [];
while (tmsCur < length(TPper1ms));
	tmsCur = tmsCur + round(TPper1ms(tmsCur+1));
	cnt = cnt+1;
	RoughEventTms(cnt) = tmsCur;
end;
RoughEventTms = min(RoughEventTms, length(TPper1ms));
F0ev = STBparam.F0per1ms(RoughEventTms);

nGW = 3*fs/1000+1;
GaussWin = Gauss(nGW,0.3*fs/1000);

nRangeNAP = 30*fs/1000;
nRN = -nRangeNAP:nRangeNAP;
NAPweight = [ ( 1 - 1./(1:nRangeNAP)),  1 , fliplr( 1 - 1./(1:nRangeNAP))];
nRangePeak = 1*fs/1000;
nEx = -nRangePeak:nRangePeak;
StrobePoint = zeros(NumCh,length(RoughEventTms));  

for nev = 10:( length(RoughEventTms)-2)
	nt1 = [1:nGW];
	nt2 = round(fs/F0ev(nev))+[1:nGW];
	nCntrMF = nt2(ceil(nGW/2));
	nt3 = round(2*fs/F0ev(nev))+[1:nGW];
	MatchFilt = zeros(1,max(nt3));
	MatchFilt(nt1) = GaussWin;
	MatchFilt(nt2) = GaussWin;
	MatchFilt(nt3) = GaussWin;
	subplot(3,1,1); plot(MatchFilt)
	nRET = RoughEventTms(nev)*fs/1000;

	for nch = NumCh/2:NumCh
	   nappc = NAPweight.*NAPPhsCmp(nch, nRET+ nRN);
	   val = conv(MatchFilt,nappc);
	   subplot(3,1,2); plot(nappc)
	   subplot(3,1,3); plot(val)
	   [dummy nPeakCan] = max(val);
	   CntrLoc = RoughEventTms(nev) + nPeakCan - nRangeNAP - nCntrMF
	   [dummy nEv] = max( NAPPhsCmp(CntrLoc + nEx));
	   StrobePoint(nch,nev-2) = nEv + CntrLoc;
	% pause
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

StrobeInfo.NAPpoint    = StrobePoint;
StrobeInfo.F0ev        = F0ev;       % F0 at event

disp(['Strobe Point :  elapsed_time = ' num2str(toc,3) ' (sec)']);

return

