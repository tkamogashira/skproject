function this = doublelog(q)
%DOUBLELOG   Construct a DOUBLELOG object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.doublelog;
this.Max = double(max(q.Max));
this.Min = double(min(q.Min));

r = q.Range;
this.MinFxPtRange = r(1);
this.MaxFxPtRange = r(2);

this.NOutOfRange = q.NOverflows;
this.NOperations = q.NOperations; 

% [EOF]
