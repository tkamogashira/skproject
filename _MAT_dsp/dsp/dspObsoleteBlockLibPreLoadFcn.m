%dspObsoleteBlockLibPreLoadFcn pre-load function callback for obsolete
%   DSP System Toolbox block libraries.
%

% Copyright 1995-2011 The MathWorks, Inc.
function dspObsoleteBlockLibPreLoadFcn(mdlFileString)

% Save current warning backtrace state
s = warning('query','backtrace');

% Issue the warning (with backtrace off)
warning off backtrace;

warning(message('dsp:dspObsoleteBlockLibPreLoadFcn:obsoleteBlks', mdlFileString));
                                 

% Restore warning backtrace state
warning(s);
