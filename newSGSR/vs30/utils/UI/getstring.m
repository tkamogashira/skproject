function str = getstring(handle);
% getstring - get string property from uicontrol
%  syntax: str = getstring(handle);

str = get(handle, 'string');