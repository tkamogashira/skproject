function DAclkout(Din, Dcode);

% function DAclkout(Din, Scode);
% XBUS DAclkout, Din is device number
% Dcode is pathch line code
% Default Din = 1
% Default Dcode = 5 = NONE

if nargin<1, Din=1; end;
if nargin<2, Dcode=5; end;
s232('DAclkout', Din, Dcode);
