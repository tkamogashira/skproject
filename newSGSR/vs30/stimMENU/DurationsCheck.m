function [OK, burstDur, riseDur, fallDur, Delay] = ...
   DurationsCheck(singleBurstDur, NoGating, NoBurstDur);

% reads & checks Durations part of most stimmenus 
% SYNTAX:
%  function [OK, burstDur, riseDur, fallDur, Delay] = DurationsCheck(singleBurstDur);
% delay is optional argout (not all stimmenus have delay option)
% optional input arg singleBurstDur indicates that only single 
% values of burstDur are allowed [default is 0];

textcolors;
if nargin<1, singleBurstDur=0; end;
if nargin<2, NoGating=0; end;
if nargin<3, NoBurstDur=0; end;
if singleBurstDur, maxNBD = 1; 
else, maxNBD = 2; end;

global StimMenuStatus
hh = StimMenuStatus.handles;

OK = 0;

if NoBurstDur, burstDur = 1e10;
else, burstDur = abs(UIdoubleFromStr(hh.BurstDurEdit,maxNBD));
end
if NoGating,
   riseDur = 0;
   fallDur = 0;
else,
   riseDur = abs(UIdoubleFromStr(hh.RiseDurEdit,2));
   % split in rise and fall part
   fallDur = riseDur(end);
   riseDur = riseDur(1);
end

if nargout>4,
   % convert from single value to [left/right]
   Delay = doubleDelay(UIdoubleFromStr(hh.DelayEdit,1));
else,
   Delay = 0;
end
     
if ~checkNanAndInf([burstDur riseDur fallDur Delay]), return; end;

if any(burstDur<(riseDur+fallDur)),
   UIerror('burst duration too small to realize ramps', ...
      [hh.BurstDurEdit hh.RiseDurEdit]);
   return;
end

OK = 1;
