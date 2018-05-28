function apl=APlock(Mtry, Fstart)

% function apl=APlock(Mtry, Fstart)
% issues an AP2 request-for-lock (see TDT's SISU guide)
%    ARG    DEFAULT     MEANING
%   Mtry     {1}       period of request in ms
%   Fstart   {0}       0/1 increments/resets lock counter
%  returns 0 if lock cannot be acquired, 1 if lock is acquired

if (nargin<1), Mtry=1; end;
if (nargin<2), Fstart=0; end;

   
apl=s232('APlock', Mtry, Fstart);

