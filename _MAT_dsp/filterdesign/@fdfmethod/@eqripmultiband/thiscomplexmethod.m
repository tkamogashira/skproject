function m = thiscomplexmethod(this)
%THISCOMPLEXMETHOD   

%   Copyright 2008 The MathWorks, Inc.

if isequal(this.privUGridFlag,0)
    warning(message('dsp:fdfmethod:eqripmultiband:thiscomplexmethod:UniformGridFalseIgnored'));
end

m = @cfirpm;

% [EOF]
