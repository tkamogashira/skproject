function h = cicdecimator(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen   
    myfun = 'cicdecimator';
    coder.extrinsic('eml_try_catch');
    eml_assert_all_constant(varargin{:});
    [errid,errmsg,h] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    h = coder.internal.const(h);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
end

