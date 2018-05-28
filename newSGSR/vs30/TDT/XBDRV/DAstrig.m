function DAstrig(Din);

% function DAstrig(Din);
% XBUS DAstrig, Din is devive number
% Default Din = 1

if nargin<1, Din=1; end;
s232('DAstrig', Din);
