function OK = EREVcheck;

% EREVcheck
% Checks params for EREVmenu

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
[splOK, pp.SPLtone, pp.active, pp.SPLnoise] = SPLandChannelCheck(0,1,[0 1]);
if ~splOK, return; end;
%--- presentation
pp.Ntoken = round(abs(UIdoubleFromStr(hh.NTokenEdit,1)));
%--- durations & freqs
pp.TotDur = abs(UIdoubleFromStr(hh.NoiseRepEdit,1));
pp.NoiseDur = abs(UIdoubleFromStr(hh.NoiseDurEdit,1));
   pp.NoiseRep = 4*ceil(1e3*pp.TotDur/pp.NoiseDur/4);
pp.AdaptDur =  3*pp.NoiseDur;
pp.NoiseBW = abs(UIdoubleFromStr(hh.NoiseBWEdit,1));
pp.ToneFreq = abs(UIdoubleFromStr(hh.ToneFreqEdit,1));
pp.FreqPos = UIintfromToggle(hh.FreqPosButton); % 1|2|3 = below|centered|above
pp.SpecType = UIintFromToggle(hh.NoiseTypeButton); % 1|2 ~ EqAmp|Gauss
pp.RejectAtt =  UIdoubleFromStr(hh.RejectAttEdit,1);
pp.RejectFreq =  UIdoubleFromStr(hh.RejectFreqEdit,2);
%--- provide params that are fixed now but may be varied in future versions
pp.RampDur = 10; % ms
pp.Rseed = abs(UIdoubleFromStr(hh.RandseedEdit,1));

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;


% level erev -> set Ntoken to 1
if length(pp.SPLnoise)>1,
   pp.Ntoken=1;
end
StimMenuStatus.params = pp;

% other checks
Doreturn = 1;
if (pp.ToneFreq > maxstimfreq),
   UIerror('Tone frequency too high', hh.ToneFreqEdit);
elseif (pp.ToneFreq+0.5*pp.NoiseBW > maxstimfreq),
   UIerror('Bandwidth too large', hh.NoiseBWEdit);
elseif (pp.ToneFreq-0.5*pp.NoiseBW < 0),
   UIerror('Bandwidth too large', hh.NoiseBWEdit);
elseif (pp.NoiseDur<2.5),
   UIerror('Noise cycle smaller than 2.5 ms', hh.NoiseDurEdit);
elseif (pp.NoiseDur>2e3),
   UIerror('Noise cycle exceeds 2000 ms', hh.NoiseDurEdit);
elseif (pp.TotDur > 60),
   UIerror(strvcat('total duration ','exceeds 60 s'), ...
      [hh.NoiseRepEdit hh.NoiseDurEdit]);
elseif (pp.TotDur <= 0),
   UIerror('total duration must be positive', [hh.NoiseRepEdit]);
elseif (pp.ToneFreq*pp.NoiseDur*1e-3 < 100),
   UIerror(strvcat('Noise cycle contains', 'less than 100 tone cycles'),...
      [hh.ToneFreqEdit hh.NoiseDurEdit]);
elseif (pp.RejectAtt<0),
   UIerror('Reject attenuation must be non-negative', hh.RejectAttEdit);
elseif (pp.Ntoken<=0),
   UIerror('# tokens must be positive integer', hh.NTokenEdit);
elseif (pp.Ntoken>5),
   UIerror('# tokens cannot exceed 5', hh.NTokenEdit);
else, Doreturn=0;
end
if Doreturn, return; end;

if (pp.RejectAtt>0),
   if length(pp.RejectFreq)~=2,
      UIerror('Specify reject band as [Flow Fhigh]', hh.RejectFreqEdit);
      return
   end
end

% call noise-generating function that returns max SPL of noise
pp.ErevVersion = 2; 
maxSPL = prepareEREVstim(pp);

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limLevel = updateMaxSPLinfo(maxSPL(1), maxSPL(end), NaN, pp.active);
if any(pp.SPLtone>limLevel),
   UIerror('Level(s) too high', [hh.LevelEdit hh.Level2Edit]);
   return;
end

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global SMS

SMS = EREV2SMS(pp);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('Checking parameters...OK');








