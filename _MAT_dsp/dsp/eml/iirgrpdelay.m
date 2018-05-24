function [varargout] = iirgrpdelay(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'iirgrpdelay';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1,2}
    % num or [num,den]
    [errid,errmsg,num,den] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    num = coder.internal.const(num);
    den = coder.internal.const(den);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = num;
    varargout{2} = den;
    
  case 3
    % [num,den,tau]
    [errid,errmsg,num,den,tau] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    num = coder.internal.const(num);
    den = coder.internal.const(den);
    tau = coder.internal.const(tau);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = num;
    varargout{2} = den;
    varargout{3} = tau;
     
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

