function A = insert(A, offset, S, Nwin);
% insert - smoothly insert a subarray into an array
%     insert(A,offset,S,Nwin) replaces A(offset+(1:M)) by S, but linearly
%     interpolates the Nwin most outer samples of this M-long path between
%     A and S (Note: M is the length of S). This fixes any "jumps" at the 
%     endpoints of the replaced elements.


if ~isvector(A) || ~isvector(S),
    error('Both A and S must be vectors');
end

if offset<0,
    error('Offset must be nonnegative integer.');
end
M = numel(S);
irange = offset+(1:M);
if max(irange)>numel(A),
    error('S does not fit in the specified part of A.');
end

if Nwin>M,
    error('Nwin may not exceed length(S).');
end
Wmix = linspace(0,1,Nwin);
% replace tails of S by mixture of S and A
ileft = 1:Nwin; % first Nwin samples of S
S(ileft) = Wmix.*S(ileft) + (1-Wmix).*A(offset+ileft);
irite = M-Nwin+1:M; % last Nwin samples of S
S(irite) = (1-Wmix).*S(irite) + Wmix.*A(offset+irite);

% now simply replace the requested ptch of A by the tempered S
A(offset+(1:M)) = S;










