function DAclkin(Din, Scode);

% function DAclkin(Din, Scode);
% XBUS DAclkin, Din is device number
% Scode is clock source
% Default Din = 1
% Default Scode = 1 = INTERNAL

if nargin<1, Din=1; end;
if nargin<2, Scode=1; end;
s232('DAclkin', Din, Scode);
