function z = fresp(w, f, bw, fs, diff)
%FRESP Response given formants.
%   Z = FRESP(W, F, BW, FS) returns the complex frequency response
%   of a cascade of formants specified by the vector of center
%   frequencies F and bandwidths BW given the sampling rate in FS.
%
%   FRESP(W, F, BW, FS, DIFF) where DIFF is set to a nonzero value
%   indicates that the input signal is not to be differentiated by a
%   single pole at 1 + 0i.

%   Copyright (c) by Michael Kiefte 2000-2001.

if nargin < 5
  diff = 0;
end

z = ones(size(w));
w = exp(sqrt(-1)*2*pi*w/fs);

for i = 1:length(f)
  [a b c] = setabc(f(i), bw(i), pi/fs);
  if f(i) < 0
    r = roots([a b c]);
    for j = 1:2
      z = sqrt(a)*(w-r(j)).*z;
    end
  else
    r = roots([1 -b -c]);
    for j = 1:2
      z = sqrt(a)*z./(w-r(j));
    end
  end
end
