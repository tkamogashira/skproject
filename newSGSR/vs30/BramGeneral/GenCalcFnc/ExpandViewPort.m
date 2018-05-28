function ViewPort = ExpandViewPort(ViewPort, AnWin)
%EXPANDVIEWPORT expand viewport property
%   ViewPort = ExpandViewPort(ViewPort, AnWin) expands the viewport property.
%   The shortcut 'auto' designates a viewport from the onset of the analysis
%   window to the offset.
%   If an invalid viewport is supplied, then the empty matrix is returned.

%B. Van de Sande 22-03-2004

if ischar(ViewPort) && strcmpi(ViewPort, 'auto')
    ViewPort = AnWin([1, end]);
elseif ~isnumeric(ViewPort) || ~isequal(sort(size(ViewPort)), [1, 2]) || any(ViewPort < 0) || (diff(ViewPort) < 0) 
   ViewPort = [];
else
    ViewPort = ViewPort(:)'; 
end