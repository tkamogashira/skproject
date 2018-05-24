function Href = reffilter(this)
%REFFILTER   CIC reference filter.
%   Href = REFFILTER(Hm) is a copy of filter Hm since CIC filters do not
%   have a reference double-precision floating-point filter.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

Href = copy(this);

% [EOF]
