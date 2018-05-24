function b = dspblkanalytic2(varargin)
%MATLAB Library Function

% Copyright 2010 The MathWorks, Inc.
%#codegen
coder.allowpcode('plain');
myfun = 'dspblkanalytic2';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});
[errid,errmsg,b] = eml_const(eml_try_catch(myfun,varargin{:}));
eml_lib_assert(isempty(errmsg),errid,errmsg);
