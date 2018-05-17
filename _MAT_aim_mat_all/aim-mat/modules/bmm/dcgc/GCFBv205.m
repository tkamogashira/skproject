%
%       Dynamic Compressive Gammachirp Filterbank 
%	Version 2.05
%       Toshio IRINO
%       Created:   6 Sep 2003
%       Modified:  7 Jun 2004
%       Modified:  12 Jul 2004  (PpgcEstShiftERB)
%       Modified:  14 Jul 2004  (LinPpgc)
%       Modified:  4  Aug 2004  (introducing GCresp)
%       Modified:  16 Aug 2004  (ExpDecayVal)
%       Modified:  31 Aug 2004  (introducing GCFBv2_SetParam)
%       Modified:  8  Sep 2004 (TTS. tidy up the names. 2.00 -> 2.01)
%       Modified:  10 Sep 2004 (Normalization at Level estimation path)
%       Modified:  7 Oct 2004   (c2val is level dependent 2.02)
%       Modified:  22 Oct 2004  (level estimation  2.03) 
%       Modified:  8 Nov 2004   (error detection of SndIn)
%       Modified:  30 Nov 2004  (c2val control)
%       Modified:  23 May 2005  (v205. Pc == average of two input, RMS2dBSPL,
%			 Fast filtering when 'fix' : under construction)
%       Modified:  24 May 2005  (v205 Mod in LinLvl1 =..., LvldB= ...)
%       Modified:   3 Jun 2005  (v205)
%       Modified:   1 Jun 2005  (v205, GCparam.GainCmpnstdB)
%       Modified:  14 Jul 2005  (v205, GCparam.LvlEst.RefdB, Pwr, Weight)
%       Modified:  15 Sep  2005  (v205, rename GCparam.LvlRefdB --> GainRefdB)
%
%
% function [cGCout, pGCout, Ppgc, GCparam, GCresp] = GCFB2(Snd,GCparam)
%      INPUT:  Snd:    Input Sound
%              GCparam:  Gammachirp parameters 
%                  GCparam.fs:     Sampling rate          (48000)
%                  GCparam.NumCh:  Number of Channels     (75)
%                  GCparam.FRange: Frequency Range of GCFB [100 6000]
%                           specifying asymptotic freq. of passive GC (Fr1)
%        
%      OUTPUT: cGCout:  Compressive GammaChirp Filter Output
%              pGCout:  Passive GammaChirp Filter Output
%              Ppgc:    power at the output of passive GC
%              GCparam: GCparam values
%              GCresp : GC response result
%
% Note
%   1)  This version is completely different from GCFB v.1.04 (obsolete).
%       We introduced the "compressive gammachirp" to accomodate both the 
%       psychoacoustical simultaneous masking and the compressive 
%       characteristics (Irino and Patterson, 2001). The parameters were 
%       determined from large dataset (See Patterson, Unoki, and Irino, 2003.)
%
%
% References: 
%  Irino, T. and Unoki, M.:  IEEE ICASSP'98 paper, AE4.4 (12-15, May, 1998)
%  Irino, T. and Patterson, R.D. :  JASA, Vol.101, pp.412-419, 1997.
%  Irino, T. and Patterson, R.D. :  JASA, Vol.109, pp.2008-2022, 2001.
%  Patterson, R.D., Unoki, M. and Irino, T. :  JASA, Vol.114,pp.1529-1542,2003.
%
%
function [cGCout, pGCout, GCparam, GCresp] = GCFBv2(SndIn,GCparam)

%%%% Handling Input Parameters %%%%%
if nargin < 2,         help GCFBv205;           end;    

[nc, LenSnd] = size(SndIn);
if nc ~= 1, error('Check SndIn. It should be 1 ch (Monaural).' ); end;

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

GCresp.Fr1 = Fr1;
Fp1 = Fr2Fpeak(GCparam.n,b1,c1,Fr1);
GCresp.Fp1 = Fp1;

[ERBrate ERBw] = Freq2ERB(Fr1);
[ERBrate1kHz ERBw1kHz] = Freq2ERB(1000);
Ef = ERBrate/ERBrate1kHz - 1;
GCresp.Ef = Ef;
%%%%
%  fratVal = frat(1,1)      + frat(1,2)*Ef + 
%            frat(2,1)*Ppgc + frat(2,2)*Ef*Ppgc;
%%%

%%%%% Outer-Mid Ear Compensation %%%%
if length(GCparam.OutMidCrct) > 2
%  disp(['*** Outer/Middle Ear correction: ' GCparam.OutMidCrct ' ***']);
  CmpnOutMid = OutMidCrctFilt(GCparam.OutMidCrct,fs,0);
  % 1kHz: -4 dB, 2kHz: -1 dB, 4kHz: +4 dB
  Snd = filter(CmpnOutMid,1,SndIn);
else 
%  disp('*** No Outer/Middle Ear correction ***');
  Snd = SndIn;
end;

% for compensation filer,  use OutMidCrctFilt('ELC',fs,0,1);

%%%%% Gammachirp  %%%
%disp('*** Gammmachirp Calculation ***');
waithand=waitbar(0, 'Generating Basilar Membrane Motion - dcGC');
if 0,  disp(GCparam), end;
tic;



%%%% Start calculation %%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Passive Gammachirp filtering  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 Tstart = clock;
 cGCout    = zeros(NumCh, LenSnd);
 pGCout    = zeros(NumCh, LenSnd);
 Ppgc      = zeros(NumCh, LenSnd);  

 for nch=1:NumCh

     % passive gammachirp
     pgc = GammaChirp(Fr1(nch),fs,GCparam.n,b1,c1,0,'','peak'); % pGC
     pGCout(nch,1:LenSnd)=fftfilt(pgc,Snd);       % fast fft based filtering

 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Compressive Gammachirp filtering  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Initial settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GCresp.Fr2 = zeros(NumCh,LenSnd);
GCresp.fratVal = zeros(NumCh,LenSnd);

%%%% Level independent b2 & c2 for Signal path %%%
b2val = GCparam.b2(1,1)*ones(NumCh,1) + GCparam.b2(1,2)*Ef(:);
c2val = GCparam.c2(1,1)*ones(NumCh,1) + GCparam.c2(1,2)*Ef(:); 
GCresp.b2val = b2val;
GCresp.c2val = c2val;

nDisp = 20*fs/1000; % display every 20 ms
cGCout = zeros(NumCh,LenSnd);
GCresp.Fr2     = zeros(NumCh,LenSnd);
GCresp.fratVal = zeros(NumCh,LenSnd);
LvldB  = zeros(NumCh,LenSnd);
LvlLinPrev = zeros(NumCh,2);
ExpDecayVal = exp(-1/(GCparam.LvlEst.DecayHL*fs/1000)*log(2)); % decay exp.

NchShift  = round(GCparam.LvlEst.LctERB/ERBspace1);
NchLvlEst = min(max(1, (1:NumCh)'+NchShift),NumCh);  % shift in NumCh [1:NumCh]
Fp1LvlEst = Fp1(NchLvlEst(:));
zrs = zeros(NumCh,1);
LvlLinMinLim = 10^(-GCparam.LvlEst.RMStoSPLdB/20); % minimum should be 0 dBSPL
LvlLinRef    = 10.^(( GCparam.LvlEst.RefdB - GCparam.LvlEst.RMStoSPLdB)/20); 


%%%%% Sample-by-sample processing %%%%%%%%%%%%%%%%%%%%%%%%

Tstart = clock;

%%%%% These lines moved from outside the inner loop
% TCW August 2006
if strcmp(GCparam.Ctrl(1:3),'tim') == 1
    Fr2LvlEst = GCparam.LvlEst.frat * Fp1LvlEst;
    [ACFcoefLvlEst] = ...
        MakeAsymCmpFiltersV2(fs,Fr2LvlEst,GCparam.LvlEst.b2, GCparam.LvlEst.c2);
end
%%%%


for nsmpl=1:LenSnd

   if strcmp(GCparam.Ctrl,'fix') == 1  
      LvldB(:,nsmpl) = GCparam.GainRefdB*ones(NumCh,1); % fixed value

   elseif strcmp(GCparam.Ctrl(1:3),'tim') == 1,  % when time-varying 

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%% Level estimation path %%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Moved the following lines outside the main loop as they're not updated
  % each time. Improves speed by about 25%
  % TCW August 2006
  %       Fr2LvlEst = GCparam.LvlEst.frat * Fp1LvlEst;
  %       [ACFcoefLvlEst] = ...
  %        MakeAsymCmpFiltersV2(fs,Fr2LvlEst,GCparam.LvlEst.b2, GCparam.LvlEst.c2);


      if nsmpl == 1,       %%  initialization 
        [dummy,ACFstatusLvlEst] = ACFilterBank(ACFcoefLvlEst,[]);  
      end;
      [cGCLvlEst,ACFstatusLvlEst] =...
	 ACFilterBank(ACFcoefLvlEst,ACFstatusLvlEst,pGCout(NchLvlEst,nsmpl));

      %%%%% Modified:  24 May 05 
      LvlLin(1:NumCh,1) = ...
         max([max(pGCout(NchLvlEst,nsmpl),0), LvlLinPrev(:,1)*ExpDecayVal]')';
      LvlLin(1:NumCh,2) = ...
          max([max(cGCLvlEst,0), LvlLinPrev(:,2)*ExpDecayVal]')';
      LvlLinPrev = LvlLin;
      
      %%%%% Modified: 14 July 05
      LvlLinTtl = GCparam.LvlEst.Weight * ...
          LvlLinRef.*(LvlLin(:,1)/LvlLinRef).^GCparam.LvlEst.Pwr(1) ...
       + ( 1 - GCparam.LvlEst.Weight ) * ...
          LvlLinRef.*(LvlLin(:,2)/LvlLinRef).^GCparam.LvlEst.Pwr(2);

      LvldB(:,nsmpl) = 20*log10( max(LvlLinTtl,LvlLinMinLim) ) ...
                                   + GCparam.LvlEst.RMStoSPLdB;    
    else 
     error([ 'GCparam.Ctrl should be "fix" or "tim[e-varying]" '])
    end;

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%% Signal path %%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Filtering High-Pass Asym. Comp. Filter
     fratVal = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
              (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*LvldB(:,nsmpl);
     Fr2Val = Fp1(:).*fratVal;
 
     [ACFcoef] = MakeAsymCmpFiltersV2(fs,Fr2Val,b2val,c2val);   
     if nsmpl == 1, 
       [dummy,ACFstatus] =  ACFilterBank(ACFcoef,[]);  % initiallization
     end;

     [SigOut,ACFstatus] = ACFilterBank(ACFcoef,ACFstatus,pGCout(:,nsmpl));
     cGCout(:,nsmpl) = SigOut;

     GCresp.Fr2(:,nsmpl) = Fr2Val;
     GCresp.fratVal(:,nsmpl) = fratVal;

    if nsmpl==1 || rem(nsmpl,nDisp)==0,
     waitbar(nsmpl./LenSnd, waithand);
    end % waitbar
    
end % loop over samples


%%%% Signal path Gain Normalization at Reference Level (GainRefdB) %%%

fratRef = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
          (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*GCparam.GainRefdB;

cGCRef = CmprsGCFrsp(Fr1,fs,GCparam.n,b1,c1,fratRef,b2val,c2val); 
GCresp.cGCRef = cGCRef;
GCresp.LvldB  = LvldB;

GainFactor = 10^(GCparam.GainCmpnstdB/20)*(cGCRef.NormFctFp2 * ones(1,LenSnd));
cGCout = GainFactor.*cGCout;

%%%%%%%%%%
close(waithand);
return
