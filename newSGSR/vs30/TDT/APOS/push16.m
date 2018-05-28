function push16(Buf, N);

% function push16(Buf, N);
% APOS push16 - pushes N points from MatLab variable Buf 
% onto 16-bit stack buffer
% default N is length(Buf)

if nargin<2, N=length(Buf); end;
s232('push16', Buf, N);

