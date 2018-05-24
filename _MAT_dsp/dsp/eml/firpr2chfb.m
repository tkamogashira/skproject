function [varargout] = firpr2chfb(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen
myfun = 'firpr2chfb';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
    case {0,1,2,3,4}
        % [h0,h1,g0,g1]
        [errid,errmsg,h0,h1,g0,g1] = eml_try_catch(myfun,varargin{:});
        errid = coder.internal.const(errid);
        errmsg = coder.internal.const(errmsg);
        h0 = coder.internal.const(h0);
        g0 = coder.internal.const(g0);
        h1 = coder.internal.const(h1);
        g1 = coder.internal.const(g1);
        eml_lib_assert(isempty(errmsg),errid,errmsg);
        varargout{1} = h0;
        varargout{2} = h1;
        varargout{3} = g0;
        varargout{4} = g1;
    otherwise
        eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
            'Too many output arguments.');
end