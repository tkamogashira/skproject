function S2close;

% function S2close;
% Closes a S232 application (see TDT's SISU guide)
% Ap & XB are unlocked if necessary

global S2claimed;

if isempty(S2claimed), return; end;
if ~S2claimed, return, end;

s232('S2close');
S2claimed = 0;

