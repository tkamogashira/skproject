function T = ET1calibInterval(X);
% ET1calibInterval - set interval between ET1 calibrations
%   ET1calibInterval(X) sets the interval to X minutes;
%   ET1calibInterval ALWAYS sets the interval to 0 minutes;
%   ET1calibInterval NEVER sets the interval to inf minutes;
%   I = ET1calibInterval returns the current interval.

global SGSR

if nargin>0,
   if isequal('ALWAYS', upper(X)), X = 0;
   elseif isequal('NEVER', upper(X)), X = inf;
   end
   if ~isnumeric(X), error('X must be numerical value.'); end
   SGSR.ET1calibrateInterval = X;
end

T = SGSR.ET1calibrateInterval;









