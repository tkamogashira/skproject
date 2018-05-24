function [b, str] = issupported(this)
%ISSUPPORTED   Returns true if the filter supports other arithmetics.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% If the method is there, the filter might be supported.
b = ismethod(this.Filter, 'qtoolinfo');

% If the method errors out, the filter is not supported.
if b,
    try
        info = qtoolinfo(this.Filter);
    catch
        b = false;
    end
end

if nargout > 1,
    if isa(this.Filter, 'dfilt.cascade')
        str = getString(message('dsp:fdtbxgui:fdtbxgui:Thefixedpointattributes'));
    else
        str = getString(message('dsp:fdtbxgui:fdtbxgui:Thestructuredoesnotcurrentlysupport',this.Filter.FilterStructure));
    end
end

% [EOF]
