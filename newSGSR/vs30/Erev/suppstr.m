function [sps, mess] = suppStr(Fsupp, Lsup, Fprobe, Lprobe, M, pp);
% suppStr - char string for suppression measurements


if nargin<5, M=6; end % 6 comp
if nargin<6, 
   global BNbuffer
   pp = BNbuffer.pp;
end
sps = '';
mess = '';

% zwuis numerology
Kmeansepa = round(pp.MeanSepa/pp.DDfreq);
N4 = 4*ceil(pp.Ncomp/4);
sepa = 1:N4;
sepa = reshape(sepa,4,N4/4);
sepa = sepa([3 4 1 2],:);
sepa = reshape(sepa,1,N4);
sepa = sepa(1:pp.Ncomp-1);
sepa = sepa - round(mean(sepa)) + Kmeansepa;

minDF = min(sepa)*pp.DDfreq;
maxDF = max(sepa)*pp.DDfreq;

% compute component frequencies as multiples of DDfreq
Kmidf = round(pp.MidFreq/pp.DDfreq);
Kfreq = [0 cumsum(sepa)];
Kfreq = Kfreq - round(mean(Kfreq)) + Kmidf;
Ncomp = pp.Ncomp;
%=====================
freq = Kfreq*pp.DDfreq;

N = pp.Ncomp;
BW = N*pp.MeanSepa;
CF = pp.MidFreq;


FsuppLow = Fsupp - 0.5*(M-1)*pp.MeanSepa;
FprobeLow = Fprobe - 0.5*(M-1)*pp.MeanSepa;

minFreq = min(freq); maxFreq = max(freq);
disp(['min/max ' num2sstr([minFreq maxFreq]) ' Hz' ]); 


if FsuppLow<min(freq),
   mess = 'Frequencies outside range';
   return;
end

[dum, isup] = min(abs(FsuppLow-freq));
[dum, ipro] = min(abs(FprobeLow-freq));

NPreZero = isup-1;
NTweenZero = ipro-isup-M;
NpostZero = N - NPreZero -NTweenZero - 2*M;

if any([NPreZero NTweenZero NpostZero]<0),
   mess = 'Frequencies outside range';
   return;
end

sps = [...
      'n' num2str(NPreZero) ' '...
      num2sstr(Lsup) '^' num2str(M) ' ' ...
      'n' num2str(NTweenZero) ' ' ...
      num2sstr(Lprobe) '^' num2str(M) ' ' ...
      'n' num2str(NpostZero) ...
   ];

sps = strSubst(sps, 'n0', '');















