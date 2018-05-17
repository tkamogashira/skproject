%
%	Calculation of Strobe point using NAP compensation
%	17 Oct 2002
%	Irino, T.
%
%
%
function [NAPPhsCmp,StrobeInfo,STBparam]=CalStrobePoint(NAP,NAPparam,STBparam);

fs  = NAPparam.fs;
Frs = NAPparam.Frs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3, STBparam = []; end;
if isfield(STBparam,'ExtDur') == 0,  STBparam.ExtDur = [];   end;
if length(STBparam.ExtDur) == 0, 
     STBparam.ExtDur  = [-0.5 1.5];  % Strobe Timing Range Extension
     % better than [-0.5 2] or [-0.5 1] 
     % changed polarity 0.5 --> -0.5 on 17 Oct 2002
end;

if isfield(STBparam,'ThreshDecay') == 0,  STBparam.ThreshDecay = [];   end;
if length(STBparam.ThreshDecay) == 0, 
	%%% STBparam.ThreshDecay = 50; % helf life ms . better than 30
	STBparam.ThreshDecay = 40;
end;

if isfield(STBparam,'TimeSpont') == 0,  STBparam.TimeSpont  = [];   end;
if length(STBparam.TimeSpont ) == 0, 
	STBparam.TimeSpont   = 20; % for every 20 ms Spotaneous firing occur if no peak info.
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
disp('*** Calculation of Strobe Point ***');

[NumCh LenNAP] = size(NAP);
DelayNAPPhsCmp = 2.0;     % strict & better

%%%%REMOVED BY RICH AS TEST
NAPPhsCmp = CmpnstERBFilt(NAP,Frs,fs,DelayNAPPhsCmp);

%%%%REPLACED WITH
%NAPPhsCmp = NAP;

NchAve = 1:NumCh; % 
NchAve = find(Frs<1500);
PwrVal = 3;

% MeanNAPPhsCmp = mean(NAPPhsCmp(NchAve,:)); 
% MeanNAPPhsCmp = mean(NAPPhsCmp(NchAve,:).^2); % with STBparam.ThreshDecay==50
MeanNAPPhsCmp = mean(NAPPhsCmp(NchAve,:).^PwrVal);% 3 seems better
			 			  % STBparam.ThreshDecay == 40

% LinPwrNAPpc = 10.^(NAPPhsCmp(NchAve,:).^2/10);
% MeanNAPPhsCmp = mean(LinPwrNAPpc); % Lin Power


% disp('******* Producing NAPmask *********');
DecayConst = 1 - log(2)/(STBparam.ThreshDecay*fs/1000);
Threshold = zeros(1,LenNAP);
SwVal     = zeros(1,LenNAP);

%% Every sample point
PeakLoc = [];
cnt1 = 0;
PrePeakDiff = 200;
NpeakPre = 5;
MeanNAPPhsCmp1 =  MeanNAPPhsCmp;
for nsmp = 2:LenNAP
	[Threshold(nsmp) SwVal(nsmp) ] = ...
	 max([ MeanNAPPhsCmp1(nsmp), Threshold(nsmp-1)*DecayConst]);
	if rem(nsmp/fs*1000, 200) == 0, 
	    disp(['Strobe Point Time : #' int2str((nsmp-1)/fs*1000) ...
		  ' (ms) / ' int2str((LenNAP-1)/fs*1000) ' (ms)']);
	end;
	if SwVal(nsmp) == 2,  % when it is not in Pulse
	  if sum(SwVal(nsmp-1)) == 1, 
		cnt1 = cnt1 + 1;
		PeakLoc(cnt1) = nsmp-1; 
		CanPeakDiff = diff(PeakLoc(max(cnt1+(-NpeakPre:0),1)));
		%%%% Linear regression here for next expected peak %%%
		%% [areg breg] = LinRegress(1:NpeakPre,CanPeakDiff);
		% PrePeakDiff = areg*(NpeakPre+1)+breg;
		% PrePeakDiff1 = areg*(NpeakPre)+breg; % all right
		% PrePeakDiff2 = mean(CanPeakDiff);   % 3rd
		PrePeakDiff = median(CanPeakDiff); % better
		PrePeakDiff = max(PrePeakDiff,fs/300);  % min boundary

		% n*F0 channel selection : NG % see below
	  end;
	  if nsmp - PeakLoc(cnt1) > STBparam.TimeSpont*fs/1000;
		Threshold(nsmp) = 0;  % reset Threshold 
	  end;
	  if nsmp - (PeakLoc(cnt1)+fix(PrePeakDiff - 0.2*fs/1000) ) == 0,
		Threshold(nsmp) = Threshold(nsmp)*0.8;
		% decrease Threshold at expected time
	  end;
	  if nsmp - (PeakLoc(cnt1)+fix(PrePeakDiff + 0.2*fs/1000 ) ) == 0,
		Threshold(nsmp) = Threshold(nsmp)/0.82; 
		% increase Threshold after expected time
	  end;

	end;
end;

% disp('******* NAPMask *********');
NAPmask  = zeros(1,LenNAP);
nExtDur = fix(STBparam.ExtDur(1)*fs/1000):fix(STBparam.ExtDur(2)*fs/1000);
nEx = PeakLoc'*ones(size(nExtDur)) + ones(size(PeakLoc'))*nExtDur;
nEx = min(max(nEx,1),LenNAP);
NAPmask(nEx(:)) = ones(size(nEx(:)));
NAPstrb = NAPPhsCmp.*(ones(NumCh,1)*NAPmask);

nONmask  = find(diff([0 NAPmask]) > 0);
nOFFmask = find(diff([NAPmask 0]) < 0);
StrobePoint = zeros(NumCh,length(nONmask));  

NchAve1 = find(Frs<1000);
MeanPwrNPC = mean(NAPPhsCmp(NchAve1,:).^2);
EventLoc(1) = 0;
cnt = 0;

% disp('******* Strobe Point & Event Location *********');
for nsw = 1:length(nONmask)
   nrng = nONmask(nsw):nOFFmask(nsw);
   for nch = 1:NumCh
	[val Npeak] = max(NAPPhsCmp(nch,nrng));
	nstp =  nONmask(nsw)+Npeak-1;
	StrobePoint(nch,nsw) = nstp;
   end;
   [val nmax] = max(MeanNAPPhsCmp(nrng));
   newEventLoc = nONmask(nsw)+nmax-1;

   if newEventLoc ~= EventLoc(max(cnt,1)), cnt = cnt+1; end;
   EventLoc(cnt)  = newEventLoc;
   PeakVal(cnt)   = MeanPwrNPC(EventLoc(cnt));
   TroughVal(cnt) = min(MeanPwrNPC(EventLoc(max(cnt-1,1)):EventLoc(cnt)));
end;

% disp('******* UV decision *********');
EventUV =  PeakVal-TroughVal;
EventUV =  EventUV/mean(EventUV);
MeanUV  = 0.7;
SlopeUV = 10;
EventUV = 1./(1 + exp(-SlopeUV*(EventUV-MeanUV)));

NAPuv = zeros(1,LenNAP);
for cnt = 2:length(EventLoc),
	nv  =   EventLoc(cnt-1):EventLoc(cnt);
	val = ( EventUV(cnt-1) * EventUV(cnt) > 0.5);
	NAPuv(nv) = val*ones(size(nv));
end;

% disp('******* Event Location to F0 info *******');
tms   = (0:LenNAP-1)/fs*1000;
TmsNe = (EventLoc-1)/fs*1000;
F0ev  = [0, 1./diff(EventLoc)*fs];
F0med = GetF0median(F0ev);
%%% F0spl = max(50,spline(TmsNe,F0med,tms)); Not so good
F0spl = max(50,interp1(TmsNe,F0med,tms,'linear')); % better
F0raw = F0spl.*NAPuv;
F0var = (NAPuv == 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

StrobeInfo.NAPpoint    = StrobePoint;
StrobeInfo.EventLoc    = EventLoc;

%StrobeInfo.EventLoc=StrobeInfo.NAPpoint(1,:);
%StrobeInfo.EventLoc(1)=0;
%difference=EventLoc-StrobeInfo.EventLoc;
%disp(difference);


StrobeInfo.EventUV     = EventUV;
StrobeInfo.NAPuv       = NAPuv;	     % UV for all sample
StrobeInfo.TmsNe       = TmsNe;      % Event location in ms
StrobeInfo.F0ev        = F0ev;       % F0 at event
StrobeInfo.F0med       = F0med;      % F0 median at event
StrobeInfo.F0spl       = F0spl;      % F0 for all sample
StrobeInfo.F0raw       = F0raw;      % F0 for all sample
StrobeInfo.F0var       = F0var;      % F0 for all sample

StrobeInfo.Threshold   = Threshold;
StrobeInfo.NchAve      = NchAve;
StrobeInfo.PwrVal      = PwrVal;

disp(['Strobe Point :  elapsed_time = ' num2str(toc,3) ' (sec)']);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nn = 1 + (1:2000);
nn = 1:length(NAP);
nn = 11000:13000;
% nn = 6000:8000;

ave = mean(NAP(NchAve,:));
plot(nn,MeanNAPPhsCmp(nn)+3,nn,ave(nn), nn,Threshold(nn)+3, ...
	nn,3*NAPmask(nn), ...
	nONmask, 1.5*ones(size(nONmask)),'o', ...
	nOFFmask, 1.5*ones(size(nOFFmask)),'x')
ax = axis;
axis([min(nn) max(nn) ax(3) ax(4)])



%%%%%%%%%%%%

if 0
  ave = mean(NAP(NchAve,:));
  sgm = sqrt(mean( (MeanNAPPhsCmp-ave).^2));
  StrbWght = 1./( 1 + exp(-3*(MeanNAPPhsCmp-ave)/sgm));
  %StrbWght = 1./( 1 + exp(-5*(MeanNAPPhsCmp-ave)/sgm));
  NAPstrb = NAPPhsCmp.*(ones(NumCh,1)*StrbWght);

end;

