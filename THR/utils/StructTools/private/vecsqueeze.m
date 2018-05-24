function x = vecsqueeze(x)
%VECSQUEEZE squeeze vector
%   VECSQUEEZE(X) squeeze vector X by replacing consecutive elements by their middle value.

%B. Van de Sande 25-04-2003

idx = find(diff(x) > 1); N = (length(idx)+1);
breaks = reshape([1, vectorzip(idx, idx+1), length(x)], 2, N);
v = floor(mean(x(breaks), 1));
