function ugrid = set_UniformGrid(this, ugrid)
%set_UniformGrid   PreSet function for the 'UniformGrid' property.

%   Copyright 2008 The MathWorks, Inc.

%We need to set privUGridFlag to a value different than its default
%to know that the user has explicitly set the UniformGrid property. This
%will allow us to send warnings if the user sets contradicting values
%between UniformGrid and MinPhase, MaxPhase, MinOrder, and StopbandShape.
if ugrid
    set(this, 'privUGridFlag',1);
else
    set(this, 'privUGridFlag',0);
end

% [EOF]
