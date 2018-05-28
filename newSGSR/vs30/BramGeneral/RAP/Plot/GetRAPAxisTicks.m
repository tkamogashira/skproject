function [TickVec, TickMode] = GetRAPAxisTicks(Limits, Inc)
%GetRAPAxisTicks    get ticks for RAP plot
%   [TickVec, TickMode] = GetRAPAxisTicks(Limits, Inc)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-11-2003

if isequal(Inc, 'auto'), 
    TickVec  = []; %The vector with Ticks is ignored by setting the TickMode to
                   %'auto', because the latter is set after the former property ...
    TickMode = 'auto';
else,
    MinL = Limits(1); MaxL = Limits(2);
    
    nTicks   = (MaxL-MinL)/Inc;
    TickVec  = MinL + (0:nTick-1).*Inc;
    TickMode = 'manual';
end