function TW = TimeWindowCheck(hh);
% TimeWindowCheck - read & check timewindow specification in edit control

TW = [];
set(hh.TimeWindowEdit, 'foregroundcolor', [0 0 0]);
TimeWindow = getstring(hh.TimeWindowEdit);
TimeWindow = lower(trimspace(TimeWindow));
if ~isequal('repdur', TimeWindow) & ~isequal('burstdur', TimeWindow),
   TimeWindow = str2num(TimeWindow);
end
doReturn = 1;
if isempty(TimeWindow) | (~ischar(TimeWindow) & length(TimeWindow)>2),
   UIerror(strvcat('Time window must be either',...
      'a single number,', ...
      'a pair of numbers,', ...
      'or the one of these strings:', ...
      '"repdur" "burstdur"'), hh.TimeWindowEdit);
elseif any(isnan(TimeWindow)) ...
      | any(isinf(TimeWindow)) ...
      | any(~isreal(TimeWindow)) ...
      | any(TimeWindow<0), ...
      UIerror('TimeWindow values must be non-negative real numbers',hh.TimeWindowEdit);
else, doReturn = 0;
end
if doReturn, return; end;

TW = TimeWindow;

