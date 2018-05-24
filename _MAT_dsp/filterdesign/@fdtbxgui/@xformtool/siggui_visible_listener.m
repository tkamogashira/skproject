function siggui_visible_listener(hObj, ~)
%SIGGUI_VISIBLE_LISTENER The listener for the visible property
%   Does the actual work

%   Copyright 2011 The MathWorks, Inc.

visState = get(hObj, 'Visible');

set(hObj.Container, 'Visible', visState);
set(hObj.Handles.button, 'Visible', visState)
if iscalledbydspblks(hObj)
  set(hObj.Handles.inputprocessing_lbl, 'Visible', visState)
  set(hObj.Handles.inputprocessing_popup, 'Visible', visState)
end

% [EOF]
