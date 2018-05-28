function DAclear(Din);

% function DAclear(Din);
% XBUS DAclear, Din is devive number
% Default Din = 1

if nargin<1, Din=1; end;
s232('DAclear', Din);
