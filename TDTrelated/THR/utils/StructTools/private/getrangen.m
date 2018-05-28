function N = getrangen(R, dt)
%GETRANGEN  get number of elements in time range
%   N = GETRANGEN(R, dt) gives number of elements in time range R if binwidth is given by dt.

%B. Van de Sande 01-05-2003

N = R/dt;
