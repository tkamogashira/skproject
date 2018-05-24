function this = fixedlog(q)
%FIXEDLOG   Construct a FIXEDLOG object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.fixedlog;
this.Max = double(max(q.Max));
this.Min = double(min(q.Min));
    
r = q.Range;
this.MinRange = r(1);
this.MaxRange = r(2);
    
this.NOverflows = q.NOverflows;
this.NOperations = q.NOperations; 
    

% [EOF]
