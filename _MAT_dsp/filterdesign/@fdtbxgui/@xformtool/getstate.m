function state = getstate(hXT)
%GETSTATE Returns the state of the XFormTool

%   Copyright 1999-2011 The MathWorks, Inc.

state.SourceType = get(hXT, 'SourceType');
state.TargetType = get(hXT, 'TargetType');
state.SourceFrequency = get(hXT, 'SourceFrequency');
state.TargetFrequency = get(hXT, 'TargetFrequency');

prt = get(hXT.Parent);
if prt.UserData.flags.calledby.dspblks > 0
  state.InputProcessing = get(hXT, 'InputProcessing');
end

% [EOF]
