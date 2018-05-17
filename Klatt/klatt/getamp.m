function a = getamp(ndb)
%GETAMP dB to amplitude

%   Copyright (c) 2001 by Michael Kiefte.

% a = 2.^(min(96, ndb)/6);
% a(ndb <= -72) = 0;
% return

% above within .12 dB of original code below

dtable = [1.8 1.6 1.43 1.26 1.12 1 .89 .792 .702 .623 .555]';
stable = [65536 32768 16384 8192 4096 2048 1024 512 256 128 ...
        64 32 16 8 4 2 1 .5 .25 .125 .0625 .0312 .0156 .0078 ...
        .0039 .00195 .000975 .000487]';

ndb1 = ndb;
a = zeros(size(ndb));
ndb1(ndb1 > 96) = 96;
ndb2 = fix(ndb1/6);
ndb3 = ndb1-(6*ndb2);
xx1 = zeros(size(ndb));
idx = find(ndb1 > -72);
xx1(idx) = stable(17 - ndb2(idx));
xx2 = dtable(6 - ndb3);
a = xx1.*xx2;
