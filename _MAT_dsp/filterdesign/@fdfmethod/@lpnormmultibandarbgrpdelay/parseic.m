function args = parseic(this,args,DenOrder)
%PARSEIC Make sure InitDen has the correct length

%   Copyright 2010 The MathWorks, Inc.

if ~isempty(this.InitDen),
  InitDen = this.InitDen(:).';
  if length(InitDen)~=DenOrder+1,
    error(message('dsp:fdfmethod:lpnormmultibandarbgrpdelay:parseic:InvalidDen'));
  else
    args = [args, {InitDen}];
  end
end

if ~isempty(this.InitNum)
  warning(message('dsp:fdfmethod:lpnormmultibandarbgrpdelay:parseic:IgnoreInitNum'));
end

% [EOF]
