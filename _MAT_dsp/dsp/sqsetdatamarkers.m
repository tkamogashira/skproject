function sqsetdatamarkers(hcbo,eventStruct)
%SQSETDATAMARKERS Set interactive data markers. 
%   SQSETDATAMARKERS is used as the 'ButtonDownFcn' of a line
%   in order to enable Data Markers.

%   Copyright 1988-2003 The MathWorks, Inc.

setdatamarkers(hcbo, eventStruct, @string_fcn);

%-------------------------------------------------------------------
function str = string_fcn(h,eventData)

ax = ancestor(h, 'axes');

% Get the analysis specific strings to display.
hxlbl = get(ax,'Xlabel'); xlbl = get(hxlbl,'String'); 
hylbl = get(ax,'Ylabel'); ylbl = get(hylbl,'String'); 

% Truncate the original x-label
if strncmp(xlbl,'Final',1),
    xlbl = 'Boundary Points';
else%if strncmp(xlbl,'Number',1),
    xlbl = 'Iterations';    
end
% Truncate the original y-label
if strncmp(ylbl,'Final',1),
    ylbl = 'Codewords';
else%if strncmp(ylbl,'Mean',1),
    ylbl = 'MSE';    
end
str{1,1} = sprintf('%s: %0.7g',xlbl,eventData.Position(1));
str{end+1,1} = sprintf('%s: %0.7g',ylbl,eventData.Position(2));

% [EOF]
