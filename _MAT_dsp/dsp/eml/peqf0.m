function [varargout] = peqf0(varargin)
%MATLAB Code Generation Library Function

% Copyright 2013 The MathWorks, Inc.
%#codegen    
myfun = 'peqf0';
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
    % [h,ms]
    [errid,errmsg,h,ms] = eml_try_catch(myfun,varargin{:});
    errid = coder.internal.const(errid);
    errmsg = coder.internal.const(errmsg);
    h = coder.internal.const(h);
    ms = coder.internal.const(ms);
    eml_lib_assert(isempty(errmsg),errid,errmsg);
    varargout{1} = h;
    varargout{2} = ms;
         
  otherwise
    eml_lib_assert(0,'MATLAB:nargoutchk:tooManyOutputs',...
                   'Too many output arguments.');
end

