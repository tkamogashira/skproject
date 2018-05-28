function Mess = sys3UnloadedError(Dev);
% sys3UnloadedError - error message for unloaded device
%    sys3UnloadedError(Dev) returns an appropriate error message if no circuit
%    was loaded to device Dev, '' otherwise. Omitted Dev or Dev=='' 
%    means sys3defaultdev.
%
%    Example
%      error(sys3UnloadedError('RX6'))
%    will prodce the error message 'No circuit loaded to RX6' is that is
%    the case.
%
%    See also sys3status.

% this fnc does not call sys3circuitInfo to avoid side effects (connecting devices via sys3dev)
if nargin<1, Dev = ''; end

if isempty(Dev), Dev = sys3defaultdev; end

if ~ischar(Dev),
    Mess = 'Dev argument must be a string identifying the TDT device.';
    return
end

L = 0; % default: no circuit loaded
CtInfo = private_circuitInfo;
if ~isempty(CtInfo),
    L = ~isempty(sys3circuitInfo(Dev));
end

if L, Mess='';
else, Mess = ['No circuit loaded to ' Dev '.'];
end




