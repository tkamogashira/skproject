function DAtgo(Din);

% function DAtgo(Din);
% XBUS DAtgo, Din is device number
% Default Din = 1

if nargin<1, Din=1; end;
s232('DAtgo', Din);
