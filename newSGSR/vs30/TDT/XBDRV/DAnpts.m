function DAnpts(Din, Npts);

% function DAnpts(Din, Npts);
% XBUS DAnpts, Din is device number
% Npts is # samples to be converted
% Default Din = 1
% Default Npts = -1 (indefinite)

if nargin<1, Din=1; end;
if nargin<2, Npts=-1; end;
s232('DAnpts', Din, Npts);
