function x=dama2ml(dbn);

% function x=dama2ml(dbn);
% DAMA16 -> Matlab array

if nargin<1, error('no dbn specified'); end;

qpush16(dbn);
x=pop16;