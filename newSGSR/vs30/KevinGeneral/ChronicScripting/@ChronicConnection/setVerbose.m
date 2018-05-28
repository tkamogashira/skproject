function chronicConnection = setVerbose( chronicConnection, newState )
%SETVERBOSE Summary of this function goes here
%   Detailed explanation goes here

if any(newState == [0 1])
    chronicConnection.verbose = newState;
else
    error('The new state of verbose must be 0 or 1');
end