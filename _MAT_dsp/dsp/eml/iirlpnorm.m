function [varargout] = iirlpnorm(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'iirlpnorm';
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
    % [num,den,err]
    [errid,errmsg,num,den,err] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    num = coder.internal.const(num);
    den = coder.internal.const(den);
    err = coder.internal.const(err);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = num;
    varargout{2} = den;
    varargout{3} = err;
    
   case {4,5}
    % [num,den,err,sos,g]
    [errid,errmsg,num,den,err,sos,g] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    num = coder.internal.const(num);
    den = coder.internal.const(den);
    err = coder.internal.const(err);
    sos = coder.internal.const(sos);
    g = coder.internal.const(g);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = num;
    varargout{2} = den;
    varargout{3} = err;
    varargout{4} = sos;
    varargout{5} = g;
     
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

