%   CalMICoef
%   SAI ->  Mellin Image Coefficient Direct
%   IRINO T.
%   18 Jan 01
%   27 Jun 01 (modified to MFCC type, Not on LogFrq)
%   11 Jan 02 (NAPparam, MIparam)
%
%   Modified for the size shape image
%   Marc A. Al-Hames
%   April 2003
%
%   function [ MICoef ] = CalMellinCoef(SAIPhsCmp,NAPparam,MIparam)
%   INPUT:  SAIPhsCmp : SAI val with Phase Compensation
%	    NAPparam:
%	           fs       : Sampling Frequency
%	           Frs      : Channel frequencies
%	    MIparam:
%	           RangeAudFig:   Range of Auditory Figure 
%                         [ZERO, Boundary] in sampling-point
%	           TFval    : TFval   == Hval          (--> abscissa of MI)
%	           c_2pi    : Kernel spatial frequeny  (--> ordinate of MI)
%	           Mu       : Kernel spatial weighting
%   OUTPUT: MICoef   : MI value

function [ ssi ] = Calssicoef(SAIPhsCmp,NAPparam,MIparam)

fs    = NAPparam.fs;
Frs   = NAPparam.Frs;
RangeAudFig =  MIparam.RangeAudFig;
TFval = MIparam.TFval;
c_2pi = MIparam.c_2pi;
Mu    = MIparam.Mu;

[NumCh LenSAI] = size(SAIPhsCmp);
LenAF =  diff(RangeAudFig)+1;
LenTaper = round(0.5*NAPparam.fs/1000); % 0.5 ms taper
WinAF = TaperWindow(LenAF+LenTaper,'han',LenTaper);
WinAF = ones(NumCh,1)*WinAF(LenTaper+(1:LenAF)); 



AFval = WinAF .* SAIPhsCmp(:,RangeAudFig(1):RangeAudFig(2));
[NumCh,LenAF] = size(AFval);
%MICoef=AFval; %added line
%%%%%%%%%%
%% LogFrs = log10(Frs(:)/min(Frs))/log10(6000/100); % normalized in [100 6000]
%% NormFrq = LogFrs;
%% Change to MFCC type, DCT on ERB domain  on 27 Jun 2001
NormFreq = ( (0:NumCh-1) + 0.5 )/NumCh;
c_pi = 2*c_2pi;

amp = exp((Mu-0.5)*0.5)*sqrt(2/NumCh); 	% mag. norm. when NormFreq == 0.5
					% when using ERB --> Frs~=760 Hz
Kernel = amp*exp( ( i*pi*c_pi(:) - (Mu-0.5)) * NormFreq(:)');
Kernel(1,1:NumCh) = Kernel(1,1:NumCh)/sqrt(2);
%
% for confirmation (15 Jan 2002)
% Kernel1 = Kernel;
% Kernel2 = DCTWarpFreq(0,length(NormFreq),length(c_pi),0);
% plot(real(Kernel1(7,:)))
% hold on
% plot(1:NumCh,real(Kernel(4,:)),'r--', 1:NumCh,abs(Kernel(4,:)))
% sum(Kernel1(3,:)-Kernel2(2,:))
% hold off
% pause
%
% 	Kernel 	Mag at 100Hz	Mag at 6000Hz
% Mu = 2:	2.1170    	0.4724  % lowpass
% Mu = 1:	1.2840    	0.7788  % lowpass
% Mu = 0.5:	1.0		1.0	% flat
% Mu = 0:	0.7788    	1.2840  % high pass
%
% clf
% plot(LogFrs,Kernel); 
% amp*exp((-Mu+0.5)*[0 1])

%%%%%%%%%%

TFmargin = 0.1;
AFave = zeros(NumCh,length(TFval));
MICoef = zeros(length(c_2pi),length(TFval));

ValNorm = 1;

% It's worth notin what's going on here, becuase it's not completely
% obvious. AFval contains the 
for cntTF = 1:length(TFval);
   cntCh = 0;
   for nch = 1:NumCh
	nSAImin = max(1,fix((TFval(cntTF)-TFmargin)/Frs(nch)*fs));
	nSAImax = min(ceil((TFval(cntTF)+TFmargin)/Frs(nch)*fs), LenAF);
	% aaa(nch,1:5) = [cntTF, nch, Frs(nch), nSAImin nSAImax];
	if nSAImin <= nSAImax,
	  AFave(nch,cntTF) = mean(AFval(nch,nSAImin:nSAImax))/ValNorm;
	  cntCh = cntCh +1;
        end;
   end;
   % NumValidCh(cntTF) = cntCh;
%   ChNorm = NumCh/cntCh;  % 10 Oct 01 --> Too much normalization 
   % ChNorm = 1;	 	  % it seems the best at 15 Jan 02   
   % MICoef(1:length(c_2pi),cntTF) = ( Kernel*AFave(:,cntTF) )*ChNorm;
end;

ssi = AFave;

% Normalization by Number of channels within one AF,
% which depends on h values.

% ValRatio = sum(NumValidCh)/(length(TFval)*NumCh);
% MICoef = MICoef*ValRatio;

return

% Do not apply this. (12 Mar. 2001)
% if length(SAIval) > 1,
%	ValNorm = max(mean(SAIval));  % Mag. of strobing point
%	if ValNorm < 0.01, ValNorm = 1; end;
% end;
