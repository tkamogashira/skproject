%
%       Compressive Gammachirp Filterbank 
%	Version 2.05
%       Toshio IRINO
%       Created:   6 Sept 2003
%       Modified:  7 June 2004
%       Modified:  12 July 2004  (PpgcEstShiftERB)
%       Modified:  14 July 2004  (LinPpgc)
%       Modified:  4  Aug 2004  (introducing GCresp)
%       Modified:  16 Aug 2004  (ExpDecayVal)
%       Modified:  31 Aug 2004  (introducing GCFBv2_SetParam)
%       Modified:  8  Sept 2004 (TTS. tidy up the names. 2.00 -> 2.01)
%       Modified:  10 Sept 2004 (Normalization at Level estimation path)
%       Modified:  7 Oct 2004   (c2val is level dependent 2.02)
%       Modified:  22 Oct 2004  (level estimation  2.03) 
%       Modified:  8 Nov 2004   (error detection of SndIn)
%       Modified:  30 Nov 2004  (c2val control)
%       Modified:  23 May 2005  (v205. Pc == average of two input, RMS2dBSPL,
%			 Fast filtering when 'fix' : under construction)
%       Modified:  24 May 2005  (v205 Mod in LinLvl1 =..., LvldB= ...)
%       Modified:   3 Jun 2005  (v205)
%       Modified:   1 Jun 2005  (v205, GCparam.GainCmpnstdB)
%       Modified:  14 July 2005  (v205, GCparam.LvlEst.RefdB, Pwr, Weight)
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
  disp(['*** Outer/Middle Ear correction: ' GCparam.OutMidCrct ' ***']);
  CmpnOutMid = OutMidCrctFilt(GCparam.OutMidCrct,fs,0);
  % 1kHz: -4 dB, 2kHz: -1 dB, 4kHz: +4 dB
  Snd = filter(CmpnOutMid,1,SndIn);
else 
  disp('*** No Outer/Middle Ear correction ***');
  Snd = SndIn;
end;

% for compensation filer,  use OutMidCrctFilt('ELC',fs,0,1);

%%%%% Gammachirp  %%%
disp('*** Gammmachirp Calculation ***');
if 0,  disp(GCparam), end;
tic;

SwFastPrcs = 0;
if SwFastPrcs == 1,
   error('Fast processing for linear cGC:  Under construction.');
   %%%%%%%%%%% for HP-AF %%%

   b2val = GCparam.b2(1,1)*ones(NumCh,1) + GCparam.b2(1,2)*Ef(:);
   %c2val = GCparam.c2(1,1)*ones(NumCh,1) + GCparam.c2(1,2)*Ef(:); 
   c2valRef = GCparam.c2(1,1)*ones(NumCh,1) + GCparam.c2(1,2)*Ef(:) ...
   + (GCparam.c2(2,1)*ones(NumCh,1) + GCparam.c2(2,2)*Ef(:))*GCparam.LvlRefdB;
   GCresp.b2val = b2val;
   %GCresp.c2val = c2val;
   GCresp.c2valRef = c2valRef;

   fratVal = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
            (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:))*GCparam.LvlRefdB;
   fr2val = Fp1(:).*fratVal;
   [ACFcoef] = MakeAsymCmpFiltersV2(fs,fr2val,b2val,c2valRef);   
end;

%%%% Start calculation %%%%%

%%% Passive Gammachirp filtering  %%%
 Tstart = clock;
 cGCout    = zeros(NumCh, LenSnd);
 pGCout    = zeros(NumCh, LenSnd);
 Ppgc      = zeros(NumCh, LenSnd);  

  for nch=1:NumCh

    % passive gammachirp
    pgc = GammaChirp(Fr1(nch),fs,GCparam.n,b1,c1,0,'','peak'); % pGC
    pGCout(nch,1:LenSnd)=fftfilt(pgc,Snd);       % fast fft based filtering 
                                                 
    %%% Fast processing for fixed cGC:  Under construction. %%%
    if SwFastPrcs == 1  &  strcmp(GCparam.Ctrl,'fix') == 1  
       error('Fast processing for linear cGC:  Under construction.');
       cGCout(nch,:) = pGCout(nch,:);
       for Nfilt = 1:4;
         cGCout(nch,:) = filter(ACFcoef.bz(nch,:,Nfilt), ...
                             ACFcoef.ap(nch,:,Nfilt),  cGCout(nch,:));
       end;
    end;  

    if nch == 1 | rem(nch,20)==0  
      disp(['Passive-Gammachirp  ch #' num2str(nch) ...
	    ' / #' num2str(NumCh) '.    elapsed time = ' ...
	    num2str(fix(etime(clock,Tstart)*10)/10) ' (sec)']);
    end;
  end;
       


%%%% Frequency Response for determining normalization factor 
%%%% normalization factor for level estimation path

GCresp.Fr2 = zeros(NumCh,LenSnd);
GCresp.fratVal = zeros(NumCh,LenSnd);
%
% not necessary when  LvlEst.frat = 1.08 ( max(pGCout) = max(cGCout) = 0 dB)
% cGCLvlEst = CmprsGCFrsp(Fr1,fs,GCparam.n,b1,c1, ...
%             GCparam.LvlEst.frat,GCparam.LvlEst.b2,GCparam.LvlEst.c2);
% NormLvlEst = cGCLvlEst.NormFctFp2;
% GCresp.cGCLvlEst = cGCLvlEst;

%%%% Level independent b2 & level-dependent c2 for signal pass at LvlRefdB %%%
b2val = GCparam.b2(1,1)*ones(NumCh,1) + GCparam.b2(1,2)*Ef(:);
% c2val = GCparam.c2(1,1)*ones(NumCh,1) + GCparam.c2(1,2)*Ef(:); 
c2valRef = GCparam.c2(1,1)*ones(NumCh,1) + GCparam.c2(1,2)*Ef(:) ...
   + (GCparam.c2(2,1)*ones(NumCh,1) + GCparam.c2(2,2)*Ef(:))*GCparam.LvlRefdB;
GCresp.b2val = b2val;
GCresp.c2valRef = c2valRef;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Now signal path filtering
%%% by calculating HP-AF for every time slice

nDisp = 20*fs/1000; % display every 20 ms
cGCout = zeros(NumCh,LenSnd);
GCresp.Fr2     = zeros(NumCh,LenSnd);
GCresp.fratVal = zeros(NumCh,LenSnd);
LvldB  = zeros(NumCh,LenSnd);
LvlLinPrev = zeros(NumCh,2);
ExpDecayVal = exp(-1/(GCparam.LvlEst.DecayHL*fs/1000)*log(2)); % decay exp.

NchShift  = round(GCparam.LvlEst.LctERB/ERBspace1);
NchLvlEst = min(max(1, (1:NumCh)'+NchShift),NumCh);  % shift in NumCh
Fp1LvlEst = Fp1(NchLvlEst(:));
zrs = zeros(NumCh,1);
LvlLinMinLim = 10^(-GCparam.LvlEst.RMStoSPLdB/20); % minimum should be 0 dBSPL
LvlLinRef    = 10.^(( GCparam.LvlEst.RefdB - GCparam.LvlEst.RMStoSPLdB)/20); 

Tstart = clock;
for nsmpl=1:LenSnd

   if strcmp(GCparam.Ctrl,'fix') == 1  
      LvldB(:,nsmpl) = GCparam.LvlRefdB*ones(NumCh,1); % fixed value

   elseif strcmp(GCparam.Ctrl(1:3),'tim') == 1,  % when time-varying 

%%%% Level estimation path %%%%
      Fr2LvlEst = GCparam.LvlEst.frat * Fp1LvlEst;
      [ACFcoefLvlEst] = ...
       MakeAsymCmpFiltersV2(fs,Fr2LvlEst,GCparam.LvlEst.b2, GCparam.LvlEst.c2);
      if nsmpl == 1,       %%  initiallization 
        [dummy,ACFstatusLvlEst] = ACFilterBank(ACFcoefLvlEst,[]);  
      end;
      [cGCLvlEst,ACFstatusLvlEst] =...
	 ACFilterBank(ACFcoefLvlEst,ACFstatusLvlEst,pGCout(NchLvlEst,nsmpl));

      %% SigLvlEst = NormLvlEst .* SigLvlEst; %%%% Removed 14 July 05
      %% SumLvlLin = pGCout(:,nsmpl) + SigLvlEst;
      %% SumLvlLin = abs(pGCout(:,nsmpl)) + abs(SigLvlEst);
      %% LvlLin1 = max([pGCout(:,nsmpl), LvlLinPrev1*ExpDecayVal, zrs]')';
      %%                       <-- NchLvlEst  <-- Bug!
      %% LvlLin2 = max([cGCLvlEst,       LvlLinPrev2*ExpDecayVal, zrs]')'; 
      %%%%% Modified:  24 May 05 
      LvlLin(1:NumCh,1) = ...
         max([max(pGCout(NchLvlEst,nsmpl),0), LvlLinPrev(:,1)*ExpDecayVal]')';
      LvlLin(1:NumCh,2) = ...
          max([max(cGCLvlEst,0), LvlLinPrev(:,2)*ExpDecayVal]')';
      LvlLinPrev = LvlLin;
      
      %%%%
      %%  LvldB(:,nsmpl) = 20*log10(max((LvlLin1+LvlLin2)/2,0.1)) ...
      %%                    + GCparam.LvlEst.RMStoSPLdB;    % average <-- v205 
      %%%%% Removed: 14 July 05
      %% LvldB(:,nsmpl) = 20*log10(max((LvlLin1+LvlLin2)/2,alim)) ...
      %%                    + GCparam.LvlEst.RMStoSPLdB;  % average <-- v205 
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

 %%%%% Signal path %%%%%%%
   % Filtering High-Pass Asym. Comp. Filter
   fratVal = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
            (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*LvldB(:,nsmpl);
   Fr2Val = Fp1(:).*fratVal;
   c2val = GCparam.c2(1,1)*ones(NumCh,1) + GCparam.c2(2,1)*LvldB(:,nsmpl);

   [ACFcoef] = MakeAsymCmpFiltersV2(fs,Fr2Val,b2val,c2val);   
   if nsmpl == 1, 
     [dummy,ACFstatus] =  ACFilterBank(ACFcoef,[]);  % initiallization
   end;
   
   [SigOut,ACFstatus] = ACFilterBank(ACFcoef,ACFstatus,pGCout(:,nsmpl));
   cGCout(:,nsmpl) = SigOut;

   GCresp.Fr2(:,nsmpl) = Fr2Val;
   GCresp.fratVal(:,nsmpl) = fratVal;

   if nsmpl==1 | rem(nsmpl,nDisp)==0,
%%% [  20*log10([max(LvlLin(:,1)) max(LvlLin(:,2)) max(LvlLinTtl) ])...
%%%  + GCparam.LvlEst.RMStoSPLdB      max(LvldB(:,nsmpl))]
     disp(['Compressive GC: Time ' num2str(nsmpl/fs*1000,3) ...
	    ' (ms) / ' num2str(LenSnd/fs*1000) ' (ms).    elapsed time = ' ...
	    num2str(fix(etime(clock,Tstart)*10)/10) ' (sec)']);
   end;
end;


%%%% Signal path Normalization factor at Reference Level
fratRef = GCparam.frat(1,1) + GCparam.frat(1,2)*Ef(:) + ...
          (GCparam.frat(2,1) + GCparam.frat(2,2)*Ef(:)).*GCparam.LvlRefdB;

cGCRef = CmprsGCFrsp(Fr1,fs,GCparam.n,b1,c1,fratRef,b2val,c2valRef); 
GCresp.cGCRef = cGCRef;
GCresp.LvldB  = LvldB;

%%%% Result
GainFactor = 10^(GCparam.GainCmpnstdB/20)*(cGCRef.NormFctFp2 * ones(1,LenSnd));
cGCout = GainFactor.*cGCout;

return


