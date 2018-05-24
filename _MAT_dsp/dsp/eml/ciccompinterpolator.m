function [varargout] = ciccompinterpolator(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'ciccompinterpolator';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1}
    % h
    [errid,errmsg,h] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    h = coder.internal.const(h);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = h;
        
  case 2
    % [h,m]
    [errid,errmsg,h,m] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    h = coder.internal.const(h);
    m = coder.internal.const(m);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = h;
    varargout{2} = m;
         
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end
