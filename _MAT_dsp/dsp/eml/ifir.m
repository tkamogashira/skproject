function [varargout] = ifir(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'ifir';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1,2}
    % h or [h,g]
    [errid,errmsg,h,g] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    h = coder.internal.const(h);
    g = coder.internal.const(g);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = h;
    varargout{2} = g;
    
  case 3
    % [h,g,d]
    [errid,errmsg,h,g,d] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    h = coder.internal.const(h);
    g = coder.internal.const(g);
    d = coder.internal.const(d);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = h;
    varargout{2} = g;
    varargout{3} = d;
     
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

