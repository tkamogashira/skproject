function X = simplegate(X,NsamRamp);
% simplegate - simple cos^2 gating of a waveform
%    simplegate(X,Nramp) applies a cos^2 ramp of Nramp samples to both the
%    start and the end of waveform X. Nramp may not exceed the length of X.
%
%    For matrices, gating is applied to the columns of X. 
%
%    See also exactgate, cyclegate.

if isvector(X),
    isrow = size(X,2)>1;
    X = X(:);
else,
    isrow = 0;
end

GateWin = sin(linspace(0,pi/2, NsamRamp+2).').^2;
GateWin = GateWin(2:end-1);
for icol=1:size(X,2),
    X(1:NsamRamp, icol) = X(1:NsamRamp, icol).*GateWin;
    X(end+1-NsamRamp:end, icol) = X(end+1-NsamRamp:end, icol).*flipud(GateWin);
end

if isrow, % restore original 'orientation'
    X = X.';
end












