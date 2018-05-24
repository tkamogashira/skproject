function [varargout] = tf2ca(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'tf2ca';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1,2}
    % [d1,d2]
    [errid,errmsg,d1,d2] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    d1 = coder.internal.const(d1);
    d2 = coder.internal.const(d2);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = d1;
    varargout{2} = d2;
    
  case 3
    % [d1,d2,beta]
    [errid,errmsg,d1,d2,beta] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    d1 = coder.internal.const(d1);
    d2 = coder.internal.const(d2);
    beta = coder.internal.const(beta);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = d1;
    varargout{2} = d2;
    varargout{3} = beta;
    
       
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

