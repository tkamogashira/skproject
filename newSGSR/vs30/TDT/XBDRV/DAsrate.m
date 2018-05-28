function DAsrate(Din, Sper);

% function DAsrate(Din, Sper);
% XBUS DAsrate, Din is device number
% Sper is sample period in us
% Default Din = 1
% Default Sper = 50 us (~20-kHz sample rate)

if nargin<1, Din=1; end;
if nargin<2, Sper=50; end;
s232('DAsrate', Din, Sper);
