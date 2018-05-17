%       Inverse Filterbank with Fixed Passive/Compressive Gammachirp
%       No dynamic resynthesis
%	Version 2.05
%       Toshio IRINO
%       Created:   9 Nov 2004 
%       Modified:  11 Nov 2004  Renamed and based on InvPGCFBv2.m
%       Modified:  18 July 2005  v205
%
%   function [SynSnd, SynGCout] = InvFxGCFB2(GCout,GCparam,GCresp,SwMethod)
%      INPUT:  GCout: pGCout or cGCout
%              GCparam:  Gammachirp parameters 
%              Fp: peak frequency vector for synthesis filter 
%              SwMethod: 1: pGCout - pGCsyn
%                        2: cGCout - pGCsyn
%                        3: cGCout - Fixed(Ref) cGCsyn
%        
%      OUTPUT: SynSnd:  Synthetic Sound
%
%
% References: 
%  Irino, T. and Unoki, M.:  IEEE ICASSP'98 paper, AE4.4 (12-15, May, 1998)
%  Irino, T. and Patterson, R.D. :  JASA, Vol.101, pp.412-419, 1997.
%  Irino, T. and Patterson, R.D. :  JASA, Vol.109, pp.2008-2022, 2001.
%  Patterson, R.D., Unoki, M. and Irino, T. :  JASA, Vol.114,pp.1529-1542,2003.
%
%
function [SynSnd,SynGCout] = InvFxGCFB2(GCout,GCparam,GCresp,SwMethod)

%%%% Handling Input Parameters %%%%%
if nargin < 4,         help InvFxGCFBv2;           end;


GCparam = GCFBv205_SetParam(GCparam);

%%%%%%%%%%%%%
fs = GCparam.fs;
NumCh0 = GCparam.NumCh;
if length(GCparam.b1) == 1 & length(GCparam.c1) == 1
  b1 = GCparam.b1(1);  % Freq. independent 
  c1 = GCparam.c1(1);  % Freq. independent 
else
  error('Not prepared yet: Freq. dependent b1, c1');
end;

[NumCh, LenSnd] = size(GCout);
if NumCh ~= NumCh0, error('Mismatch in NumCh'); end;

if SwMethod == 1 
    disp('*** Inverse Passive Gammmachirp Calculation ***');
    Fr1 = GCresp.Fr1;
elseif SwMethod == 2;
    disp('*** Inverse Passive Gammmachirp Calculation ***');
    Fr1 = Fpeak2Fr(GCparam.n,b1,c1,GCresp.cGCRef.Fp2); % pGC peak == Fp2
elseif  SwMethod == 3
    disp('*** Inverse Fixed Compressive Gammmachirp Calculation ***');
    Fr1 = GCresp.Fr1;
end;


LenInv = 50/1000*fs;  % 50 ms zero filling for processing
zz = zeros(NumCh,LenInv);
TrGCout = fliplr(GCout);  %%% time-reversal %%
TrGCout = [zz TrGCout zz];
[NumCh,LenTr] = size(TrGCout);
SynGCout = zeros(NumCh,LenTr);
TrGCout1 = zeros(NumCh,LenTr);

%%%%% Time-Reversal ACfilter cGC %%%

Tstart = clock;
nDisp = 20*fs/1000; % display every 20 ms
if SwMethod == 3,  % The same function is applied like wavelet trans.
   [ACFcoef] = MakeAsymCmpFiltersV2(fs,...
               GCresp.cGCRef.Fr2,GCresp.cGCRef.b2,GCresp.cGCRef.c2);   
   [dummy,ACFstatus] =  ACFilterBank(ACFcoef,[]);  % initiallization
   for nsmpl = 1:LenTr
     [SigOut,ACFstatus] = ACFilterBank(ACFcoef,ACFstatus,TrGCout(:,nsmpl));
     TrGCout1(:,nsmpl) = GCresp.cGCRef.NormFctFp2.*SigOut;
     if nsmpl==1 | rem(nsmpl,nDisp)==0,
       disp(['Time-Reversal ACF-cGC : Time ' num2str(nsmpl/fs*1000,3) ...
	    ' (ms) / ' num2str(LenSnd/fs*1000) ' (ms).    elapsed time = ' ...
	    num2str(fix(etime(clock,Tstart)*10)/10) ' (sec)']);
     end;
   end;
   TrGCout = TrGCout1;
end;

%%%%% Time-Reversal Passive Gammachirp  %%%

for nch=1:NumCh
    pgc = GammaChirp(Fr1(nch),fs,GCparam.n,b1,c1,0,'','peak');
    SynGCout(nch,1:LenTr) =  fftfilt(pgc,TrGCout(nch,:));
    if nch == 1 | rem(nch,20)==0  
      disp(['Time-Reversal Passive-Gammachirp  ch #' num2str(nch) ...
	    ' / #' num2str(NumCh) '.    elapsed time = ' ...
	    num2str(fix(etime(clock,Tstart)*10)/10) ' (sec)']);
    end;
end;

SynGCout = fliplr(SynGCout);
SynSnd = mean(SynGCout)*sqrt(NumCh); % Approximately all right
                                     % Maybe depend on filter shape
                                     % 11 Nov 2004

%%%%% Inverse of Outer-Mid Ear Compensation %%%%
if length(GCparam.OutMidCrct) > 2
 disp(['*** Inverse Outer/Middle Ear correction: ' GCparam.OutMidCrct ' ***']);
 InvOutMid = OutMidCrctFilt(GCparam.OutMidCrct,fs,0,1); % Inverse
 %% OutMidCrct--> 1kHz: -4 dB, 2kHz: -1 dB, 4kHz: +4 dB
 %% [dummy NpIOM] = max(abs(InvOutMid));
 SynSnd = filter(InvOutMid,1,SynSnd);  
 Nout = LenInv+length(InvOutMid)+(1:LenSnd);
else 
 disp('*** No Outer/Middle Ear correction ***');
 Nout = LenInv+(1:LenSnd);
end;

SynSnd   = SynSnd(Nout);
SynGCout = SynGCout(:,Nout);

disp(' ');
return
