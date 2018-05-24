function [varargout] = firlpnorm(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'firlpnorm';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});

switch nargout
  case {0,1}
    % B
    [errid,errmsg,b] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    b = coder.internal.const(b);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = b;
    
  case 2
    % [B,ERR]
    [errid,errmsg,b,err] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    b = coder.internal.const(b);
    err = coder.internal.const(err);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = b;
    varargout{2} = err;
     
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

