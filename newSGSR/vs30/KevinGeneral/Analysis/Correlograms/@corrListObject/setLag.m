function CLO = setLag(CLO, lag)
% SETLAG Sets the lag of the corrListObject instance
%
% CLO = setLag(CLO, lag)
%   Replaces the existing lag of CLO by the given lag.
%
% Arguments:
%   CLO: the corrListObject being adjusted.
%   lag: a row vector containing the new lag vector for correlograms. The
%        values should be equally spaced and symmetric.

if ~isEquallySpaced(lag)
    error('The new lag should be equally spaced');
end
if ~isequal(-lag(1), lag(end))
    error('The new lag should be symmetric');
end

D = diff(lag);
CLO.props.corrBinWidth = D(1);
CLO.props.corrMaxLag = lag(end);
CLO.props.lag = lag;