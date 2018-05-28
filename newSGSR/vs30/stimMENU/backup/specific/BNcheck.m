function OK = BNcheck;

% BNcheck
% Checks params for BNmenu

global StimMenuStatus SGSR PRPstatus
OK = 0; StimMenuStatus.paramsOK = 0;
hh = StimMenuStatus.handles; 

persistent Rseed
if isempty(Rseed), % initial call to NTDcheck -> initialize Rseed
   Rseed = SetRandState; % this way, the max SPL values will
   % setstring(hh.RandseedEdit,num2str(Rseed));
   % .. not fluctuate from try to try
   return; % do not perform time-consuming checks on first entry
end
textcolors;

UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck(0,-1,1); % (~ForceBothActive, manyLevels, sweepEnable)
if ~splOK, return; end;
pp.SPL = repmat(pp.SPL(:), 1,2);
%--- presentation
pp.Rseed = abs(UIdoubleFromStr(hh.RandseedEdit,1));
%--- durations & freqs
pp.TotDur = abs(UIdoubleFromStr(hh.TotDurEdit,1));
pp.MidFreq = 1e3*abs(UIdoubleFromStr(hh.MidFreqEdit,inf,1)); pp.MidFreq = pp.MidFreq(:);
pp.DDfreq = abs(UIdoubleFromStr(hh.DDfreqEdit,1));
pp.MeanSepa = abs(UIdoubleFromStr(hh.MeanSepaEdit,1));
pp.Ncomp = abs(UIdoubleFromStr(hh.NcompEdit,1));
try,   [pp.Tilt, pp.SPL] = localDecodeTilt(hh.TiltEdit, pp.SPL);
catch, pp.Tilt = UIdoubleFromStr(hh.TiltEdit, pp.Ncomp);
end
pp.order = UIintFromToggle(hh.OrderButton)-1;
%--- provide params that are fixed now but may be varied in future versions
pp.RampDur = 10; % ms
pp.BNversion =  9; % for data analysis; 
%   vs2: Ntoken removed, multiple MidFreq's enabled
%   vs3: spectral tilt
%   vs4: multiplicity of spectral tilt & advice stuff
%   vs5: tilt does not affect overall level
%   vs6: round # samples to product of small factors
%   vs7: true random seed is codetermined by freq parameters
%   vs8: Tilt==888 then throw away that component
%   vs9: disable multiple MidFreq; enable multiple SPLs

% any non-numerical or oversized input that hasn't been caught yet?

if ~CheckNaNandInf(pp), return; end;

if any(pp.MidFreq>maxStimFreq),
   UIerror(strvcat('Frequency too high','Note: center freq in Khz!!'), [hh.MidFreqEdit]);
   return;
end

global LastAdvice LastUsedAdvice 
if isequal(pp.Tilt,999),
   if isempty(LastAdvice),
      UIerror('LastAdvice is empty', hh.TiltEdit);
      return
   end
   if length(LastAdvice)>pp.Ncomp,
      UIerror('Excessive length of LastAdvice', hh.TiltEdit);
      return
   end
   pp.Tilt = LastAdvice;
   LastUsedAdvice = LastAdvice;
elseif isequal(pp.Tilt,-999), % rep
   if isempty(LastUsedAdvice),
      UIerror('LastUsedAdvice is empty', hh.TiltEdit);
      return
   end
   if length(LastAdvice)>pp.Ncomp,
      UIerror('Excessive length of LastUsedAdvice', hh.TiltEdit);
      return
   end
   pp.Tilt = LastUsedAdvice;
end

StimMenuStatus.params = pp;

% prepare stimulus
BN = prepareBNstim(pp);
if ~isempty(BN.mess),
   switch BN.mess,
   case 'crowded',
      UIerror('Components too crowded', ...
         [hh.NcompEdit, hh.MeanSepaEdit]);
   case 'smallDD',
      UIerror('DDfreq < 1 Hz', hh.DDfreqEdit);
   case 'separatio',
      UIerror(strvcat('Mean Separation too low',...
         'compared to DDfreq'), [hh.DDfreqEdit hh.MeanSepaEdit]);
   case 'overlap',
      UIerror(strvcat('Overlapping beat components;',...
         'increase Mean Separation,',...
         'decrease DDfreq,',...
         'or decrease # components'), ...
         [hh.DDfreqEdit, hh.NcompEdit, hh.MeanSepaEdit]);
   otherwise,
      error(BN.mess);
   end
   return
end

% update min/maxDF info
carFreq = BN.Kfreq*BN.DDfreq/1e3;
Fmin = 0.05*round(20*min(carFreq));
Fmax = 0.05*round(20*max(carFreq));
setstring(hh.FreqInfo,strvcat(['Fmin: ' num2str(Fmin) ' kHz'],...
   ['Fmax: ' num2str(Fmax) ' kHz']));

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limLevel = updateMaxSPLinfo(BN.maxSPL(:,1), BN.maxSPL(:,end), pp.MidFreq(:), pp.active);
if any(pp.SPL(:,1)>limLevel(1)) | any(pp.SPL(:,2)>limLevel(2)),
   UIerror('Level(s) too high', hh.LevelEdit);
   return;
end

if ~ReportNsubSeq(size(pp.SPL,1)),
   return
end

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global SMS

SMS = BN2SMS(pp);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('Checking parameters...OK');

function [T, spl] = localDecodeTilt(h, spl);
tstr = lower(getstring(h));
[CC, Nw] = words2cell(tstr);
T = [];
for iw=1:Nw,
   ww = CC{iw};
   if lower(ww(1))=='n',
      nz = str2num(ww(2:end));
      T = [T 888*ones(1,nz)];
   elseif ~isempty(find(ww=='^')),
      [A, B] = strtok(ww,'^');
      a = str2num(A);
      Na = str2num(B(2:end));
      T = [T repmat(a,1,Na)];
   else, T = [T, str2num(ww)];
   end
end
if all(spl==-999), % interpret tilt as primary levels
   itoss = find(T==888);
   nitoss = find(T~=888);
   spl = max(T(nitoss)) + 0*spl; % 0*spl: correct size
   % power = p2db(sum(db2p(T)));
   T = -T;
   T = T-min(T(nitoss));
   if ~isempty(itoss), T(itoss) = 888; end;
end












