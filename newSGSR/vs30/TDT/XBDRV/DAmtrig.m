function DAmtrig(Din);

% function DAmtrig(Din);
% XBUS DAmtrig, Din is device number
% Default Din = 1

if nargin<1, Din=1; end;
s232('DAmtrig', Din);
