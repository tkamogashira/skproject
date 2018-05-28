function boolean = isempty(EDFds)
%EDFDATASET/ISEMPTY builtin ISEMPTY-function overloaded for EDF dataset objects

%B. Van de Sande 07-08-2003

for n = 1:length(EDFds), boolean(n) = isvoid(EDFds(n).dataset); end
boolean = all(boolean);