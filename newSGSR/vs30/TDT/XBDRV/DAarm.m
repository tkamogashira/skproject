function DAarm(Din);

% function DAarm(Din);
% XBUS DAarm, Din is device number
% Default Din = 1

if nargin<1, Din=1; end;
s232('DAarm', Din);
