function trueSper=DAsperiod(Din, Sper);

% function trueSper=DAsperiod(Din, Sper);
% XBUS DAperiod, Din is device number
% Sper is sample period in us
% Default Din = 1
% Default Sper = 50 us (~20-kHz sample rate)
% TrueSper is true sample period in us, possibly
%  different from Sper because of rounding errors (12.5-MHz clock)

if nargin<1, Din=1; end;
if nargin<2, Sper=50; end;
trueSper=s232('DAsperiod', Din, Sper);
