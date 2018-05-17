%
%       Excitation Pattern of Compressive Gammachirp 
%	Version 2.05 <-- GCFBv205
%       Toshio IRINO
%       Created:   10 Jul 2005
%       Modified:  11 Jul 2005  
%       Modified:  13 Jul 2005  
%
%
% function [cGCoutdB, pGCoutdB, GCparam] ...
%                     = GCFB205ExtPtn(SigFrqLvldBIn,GCparam,NfrqRsl)
%      INPUT:  SigFrqLvldB:   Input Signal Freq. Level dB values 
%                            [Frq1, LvlSPLdB1; Frq2, LvlSPLdB2;];
%                             Probe        Suppressor
%              GCparam:  Gammachirp parameters 
%                  GCparam.fs:     Sampling rate          (48000)
%                  GCparam.NumCh:  Number of Channels     (75)
%                  GCparam.FRange: Frequency Range of GCFB [100 6000]
%                           specifying asymptotic freq. of passive GC (Fr1)
%                  NfrqRsl: Frequency resolution
%        
%      OUTPUT: LvlOutdB:  OutputLevel at Probe freq.
%              GCparam: GCparam values
%
%
function [cGCoutdB, pGCoutdB, GCparam, cGCresp ] ...
                     = GCFB205ExtPtn(SigFrqLvldBIn,GCparam,NfrqRsl)

%%%% Handling Input Parameters %%%%%
if nargin < 2,  help GCFBv205ExtPtn;           end;    
if nargin < 3,  NfrqRsl = 1024; end;

[nSig, nSpc] = size(SigFrqLvldBIn);
if nSpc ~= 2, error('Check SigFrqLvldBIn. [Frq,Lvl] pair' ); end;
SigFrqLvldB = SigFrqLvldBIn;

GCparam = GCFBv205_SetParam(GCparam);

%%%%%%%%%%%%%
fs   = GCparam.fs;
NumCh = GCparam.NumCh;
if length(GCparam.b1) == 1 & length(GCparam.c1) == 1
  b1 = GCparam.b1(1);  % Freq. independent 
  c1 = GCparam.c1(1);  % Freq. independent 
else
  error('Not prepared yet: Freq. dependent b1, c1');
end;

[Fr1, ERBrate1]  = EqualFreqScale('ERB',NumCh,GCparam.FRange);
Fr1 = Fr1(:);
ERBspace1 = mean(diff(ERBrate1));

Fp1 = Fr2Fpeak(GCparam.n,b1,c1,Fr1);
[ERBrate ERBw] = Freq2ERB(Fr1);
[ERBrate1kHz ERBw1kHz] = Freq2ERB(1000);
Ef = ERBrate/ERBrate1kHz - 1;
cGCresp.Ef = Ef;

%%%%% Outer-Mid Ear Compensation %%%%
[CrctLinPwr, freq1] = OutMidCrct('ELC',NfrqRsl,fs,0);
for ns = 1:nSig
[dummy nf] = min(abs(freq1 - SigFrqLvldB(ns,1)));
   SigFrqLvldB(ns,2) =    SigFrqLvldB(ns,2) + 10*log10(CrctLinPwr(nf));
end;

%SigFrqLvldB(:,2)

%%% Level Estimation path %%%   
GCparam.LvlEst.LctERB = 1.5;

  NchShift  = round(GCparam.LvlEst.LctERB/ERBspace1);
  NchLvlEst = min(max(1, (1:NumCh)'+NchShift),NumCh);
  Fp1LvlEst = Fp1(NchLvlEst(:));

  Fr1L = Fpeak2Fr(GCparam.n,b1,c1,Fp1LvlEst);

  fratL= GCparam.LvlEst.frat;
%%  fratL= 1; %  not so diffrerent

  b2L= GCparam.LvlEst.b2;
  c2L= GCparam.LvlEst.c2;

SwTwoStageEst = 0;
if SwTwoStageEst == 1
  % when fratL is fixed
  cGCLvlEst = CmprsGCFrsp(Fr1L,fs,GCparam.n,b1,c1,fratL,b2L,c2L,NfrqRsl);

  freq = cGCLvlEst.freq;
  EstLvlTtl = zeros(NumCh,1);
  for ns = 1:nSig
    [dummy nf] = min(abs(freq - SigFrqLvldB(ns,1)));
     EstLvldB0(1:NumCh,ns) = SigFrqLvldB(ns,2)+20*log10(cGCLvlEst.pGCFrsp(:,nf)); 
  end;
  EstLvlTtl =  sum( (10.^(EstLvldB0(:,:)/20))')';
  EstLvldB99 =   20*log10(EstLvlTtl(:));

  fratL = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
          (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*EstLvldB99;
end;

%  fratLRef = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
%          (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*50;
% 1.0110

  cGCLvlEst = CmprsGCFrsp(Fr1L,fs,GCparam.n,b1,c1,fratL,b2L,c2L,NfrqRsl);

  freq = cGCLvlEst.freq;
  for ns = 1:nSig
    [dummy nf] = min(abs(freq - SigFrqLvldB(ns,1)));
     EstLvldB1(1:NumCh,ns) = SigFrqLvldB(ns,2)+20*log10(cGCLvlEst.pGCFrsp(:,nf)); 
     EstLvldB2(1:NumCh,ns) = SigFrqLvldB(ns,2)+20*log10(cGCLvlEst.cGCFrsp(:,nf));
%%     EstLvldB2(1:NumCh,ns) = SigFrqLvldB(ns,2)+20*log10(cGCLvlEst.cGCNrmFrsp(:,nf));
  end;

%size(cGCLvlEst.pGCFrsp)
%20*log10(cGCLvlEst.NormFctFp2')
%20*log10( cGCLvlEst.ValFp2')

%%  alp = 0.5;  beta = 0.5;   %  not good symmetric!
%%  alp = 0.6;  beta = 0.5;   %   little better
%%alp = 0.7;  beta1 = 1; beta2 = 0.7; % for old version 
%%  alp = 0.7;  beta1 = 1; beta2 = 0.5; % OK  needs more asymmetry 13 July 05
%% alp = 0.5;  beta1 = 1; beta2 = 0.5;  % more symmetric NG
%% alp = 0.5;  beta1 = 1.5; beta2 = 0.5;  % what happens? OK!
alp = GCparam.LvlEst.Weight;
beta1 = GCparam.LvlEst.Pwr(1);
beta2 = GCparam.LvlEst.Pwr(2);
a0    = 10.^(( GCparam.LvlEst.RefdB(1) - 0)/20);

alp_beta12_a0 = [alp beta1 beta2 a0]

%%% NG! 13 July
%%  a1 = sum( (10.^(  ((EstLvldB1(:,:) -50) * beta1 + 50) /20)) )' )';
%%  a2 = sum( (10.^(  ((EstLvldB2(:,:) -50) * beta2 + 50) /20 ) )' )';
%%
  a1 = sum( 10.^(EstLvldB1(:,:)'/20) )';
  a2 = sum( 10.^(EstLvldB2(:,:)'/20) )';
%[ [max(a1) a0] 20*log10([max(a1) a0])]
  EstLvlTtl = alp * a0*(a1/a0).^beta1 + (1-alp) * a0*(a2/a0).^beta2;
  EstLvldB  = 20*log10(EstLvlTtl(:));

[ max(fratL) max(20*log10(a1)) max(20*log10(a2)) max(EstLvldB) ]

%%%%% Signal path %%%%%%%

  fratVal = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
           (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*EstLvldB;
  b2= GCparam.b2(1);
  c2= GCparam.c2(1);

  cGCresp = CmprsGCFrsp(Fr1,fs,GCparam.n,b1,c1,fratVal,b2,c2,NfrqRsl);

  for ns = 1:nSig
      [dummy nf] = min(abs(freq - SigFrqLvldB(ns,1)));
      cGCoutdB1(1:NumCh,ns) = SigFrqLvldB(ns,2)+20*log10(cGCresp.cGCFrsp(:,nf)); 
      pGCoutdB1(1:NumCh,ns) = SigFrqLvldB(ns,2)+20*log10(cGCresp.pGCFrsp(:,nf)); 
  end;

  cGCoutdB =  20*log10( sum(  ( 10.^(cGCoutdB1/20) )')');
  pGCoutdB =  20*log10( sum(  ( 10.^(pGCoutdB1/20) )')');


