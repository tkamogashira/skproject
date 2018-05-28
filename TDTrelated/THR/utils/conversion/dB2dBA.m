function LA = dB2dBA(L, f);
% dB2dBA - convert dB SPL to dBA
%    dB2dBA(L, f) returns the level in dBA of a tone @ f Hz having a level of L dB SPL

% source: http://www.phys.unsw.edu.au/~jw/dB.html


LA = L + 20*log10(local_A(f)./local_A(1000));

function A = local_A(f);
% linear weigthing factor
f2 = f.^2;
A = 12200^2*f.^4./((f2+20.6^2).*(f2+12200^2).*sqrt(f2+107.7^2).*sqrt(f2+737.9^2));



