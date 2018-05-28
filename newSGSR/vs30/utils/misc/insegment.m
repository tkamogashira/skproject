function I = insegment(X,S);
% INSEGMENT - find distribution of vector elements over a set of segments
%    I = INSEGMENT(X,[s0 s1 .. sn]) returns a cell array of indices
%    that tell in which interval the corresponding elements of X lie:
%    s0<=X(I{1})<s1; s2<=X(I{2})<s2, etc.

Nseg = length(S)-1;
I = cell(1,Nseg);
for iseg = 1:Nseg,
   I{iseg} = find((S(iseg)<=X)&(X<S(iseg+1)));
end