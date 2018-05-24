function dsplib
%DSPLIB Open the latest version of DSP System Toolbox block library
%
%  Other information available for the DSP System Toolbox:
%
%    demo toolbox dsp     - Open the product demos
%    doc dsp              - view the product documentation
%    help dsp             - view the product Contents file

% Copyright 1995-2011 The MathWorks, Inc.

if ~issimulinkinstalled
  error(message('dsp:dsplib:simulinkLicenseFailed'));
end

% Attempt to open library
try
   open_system('dsplibv4');
catch  %#ok<CTCH>
   error(message('dsp:dsplib:unhandledCase'));
end
