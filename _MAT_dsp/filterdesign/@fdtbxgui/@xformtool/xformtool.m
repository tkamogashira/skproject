function this = xformtool(filtobj)
%XFORMTOOL Create an XFormTool object

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

error(nargchk(1,1,nargin,'struct'));

if ~isa(filtobj, 'dfilt.singleton')
    error(message('dsp:fdtbxgui:xformtool:xformtool:FilterErr'));
end

this = fdtbxgui.xformtool;

settag(this);

this.Filter = filtobj;

% [EOF]
