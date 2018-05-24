function [varargout] = tf2cl(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'tf2cl';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1,2}
    % [k1,k2]
    [errid,errmsg,k1,k2] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    k1 = coder.internal.const(k1);
    k2 = coder.internal.const(k2);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = k1;
    varargout{2} = k2;
    
  case 3
    % [k1,k2,beta]
    [errid,errmsg,k1,k2,beta] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    k1 = coder.internal.const(k1);
    k2 = coder.internal.const(k2);
    beta = coder.internal.const(beta);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = k1;
    varargout{2} = k2;
    varargout{3} = beta;
    
       
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

