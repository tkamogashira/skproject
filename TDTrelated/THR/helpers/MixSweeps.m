function  [X, Y, NM] = MixSweeps(X, Y);
% MixSweeps - basic visting order of two combined sweeps
%    [X, Y, MN] = MixSweeps(X, Y), where inputs X and Y are 1D arrays, having
%    lengths N and M, respectively, turns X and Y into N*M-long arrays 
%    holding all combinations X(i) Y(j) values in a systematic order 
%    (with X the "faster moving" one):
%        X: X1 X2 .. XN  X1 X2 .. XN ...  XN
%        Y: Y1 Y1 .. Y1  Y2 Y2 .. Y2 ...  YM
%    The 3rd output, NM, holds the two counts in a 2x1 array: NM = [N M].
%    This is useful for passing to EvalDurPanel, etc.
%
%    See makestimRF, EvalDurPanel.

NM = [numel(X) numel(Y)];
[X, Y] = sameSize(X(:), Y(:).');
X = X(:);
Y = Y(:);



