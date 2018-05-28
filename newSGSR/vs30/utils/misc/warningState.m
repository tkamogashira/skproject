function warningState(flag)
% warningState - manipulate MatLab's warning state
%   warningState('off') stores current state and turns warnings off
%   warningState('restore') restores stored state. If no state was stored,
%   warning state is set to backtrace.
%
%   See also: warning.

persistent WS
if isempty(WS), WS = 'backtrace'; end

switch lower(flag)
case 'off',
   WS = warning;
   warning off;
case 'restore', 
   warning(WS)
otherwise, error(['Invalid flag ''' flag '''.']);
end


