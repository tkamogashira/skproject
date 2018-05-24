function [b,a] = iirnotch(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
    coder.extrinsic('eml_try_catch');
    eml_assert_all_constant(varargin{:});
    [errid,errmsg,b,a] = eml_try_catch('iirnotch',varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    b = coder.internal.const(b);
    a = coder.internal.const(a);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
end