function DAreps(Din, Nreps);

% function DAreps(Din, Nreps);
% XBUS DAreps, Din is device number; Nreps is # reps
% Default Din = 1
% Default Nreps = 1

if nargin<1, Din=1; end;
if nargin<2, Nreps=1; end;
s232('DAreps', Din, Nreps);
