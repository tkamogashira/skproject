function [varargout] = cl2tf(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'cl2tf';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1,2}
    % [b,a]
    [errid,errmsg,b,a] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    b = coder.internal.const(b);
    a = coder.internal.const(a);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = b;
    varargout{2} = a;
    
  case 3
    % [b,a,bnump]
    [errid,errmsg,b,a,bnump] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    b = coder.internal.const(b);
    a = coder.internal.const(a);
    bnump = coder.internal.const(bnump);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = b;
    varargout{2} = a;
    varargout{3} = bnump;
    
       
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

