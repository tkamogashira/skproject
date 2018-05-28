function [y, samp] = StimSam(DS, isub);
% StimSam - stimulus waveform of a dataset condition
%   SYNTAX: [y, samper] = StimSam(DS, isub)
%        y: samples in column vector, or Nx2 matrix if stereo
%   samper: sample period in us
%
%   See also SAVEWAVEFORM

CachePar = {DS.id, isub};
had = fromCacheFile(mfilename, CachePar);
if ~isempty(had),
   y = had.y;
   samp = had.samp;
   return;
end

xval = DS.xval(isub); % value of indep var @ requested subseq
pp = DS.stimparam; 

global SGSR
if (inLeuven | inUtrecht | inRotterdam) & ~AP2present, % use default sample freqs
   SGSR.samFreqs = [60096155 125000003]/1e3;
end
% try to get samplefreq from dataset; if successful, they override above defaults
try, 
   SGSR.samFreqs = DS.recparam.samFreqs;
end

if ~AP2present,
   CDuseCalib('', 'B');
end

global SMS
switch DS.fileformat,
case 'IDF/SPK',
   pp.stimcntrl.repcount = 1; % force single rep
   SMS = idf2sms(pp);
case 'SGSR',
   pp.reps = 1; % force single rep
   if strcmp(DS.stimtype,'ARMIN')
       pp.flipfreqs = DS.Stimulus.IndepVar.Values;
   end
   eval(['SMS = ' DS.stimtype '2SMS(pp);']);
end

% prepare waveforms
global PRPinstr
SMS2PRP(0,1); xplay = PRPinstr.PLOT.varValues; % x-values in play order;
[dum iplay] = min(abs(xplay-xval)); % index of requested subseq

% extract waveform params and waveform
samp = PRPinstr.PLAY(iplay).SamP;
global SGSR;
Nswitch = round(1e3*SGSR.switchDur/samp);

y = localGetSamples(PRPinstr.PLAY(iplay), DS.chan, Nswitch);

% store in cache
res = CollectInStruct(y, samp);
ToCacheFile(mfilename, 10, CachePar, res);

% -------locals----------
function s = localGetSamples(pin, act, Nswitch);
if act==0,
   s1 = PL2samp(pin.playList(1,:));
   s2 = PL2samp(pin.playList(2,:));
   N1 = length(s1);
   N2 = length(s2);
   if N1<N2, s1 = [s1 zeros(1,N2-N1)];
   elseif N1>N2, s2 = [s2 zeros(1,N1-N2)];
   end
   s = [s1;s2];
else,
   pl = pin.playList(1,:);
   s = PL2samp(pl);
end
s = s(:,Nswitch+1:end).';

function y = PL2samp(p);
global SampleLib
z1 = min(find(p==0));
p = p(1:z1-1);
dbn = p(1:2:end);
rep = p(2:2:end);
y = [];
for ii=1:length(dbn),
   dd = dbn(ii);
   if dd>0,
      nn = dama2ml(dd);
   else,
      nn = SampleLib.cell{-dd};
   end
   y = [y repmat(nn, 1,rep(ii))];
end




