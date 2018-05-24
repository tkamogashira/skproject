function [cshtags, cshtool] = getcshtags(this)
%GETCSHTAGS   Get the cshtags.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

cshtool = 'fdatool';

cshtags.arithmetic      = fullfile('fdatool_qtool_arithmetic', 'dsp');
cshtags.castbeforesum   = fullfile('fdatool_qtool_castbeforesum', 'dsp');
cshtags.filterinternals = fullfile('fdatool_qtool_filterinternals', 'dsp');
cshtags.unsigned        = fullfile('fdatool_qtool_unsigned', 'dsp');
cshtags.normalized      = fullfile('fdatool_qtool_normalized', 'dsp');
cshtags.roundmode       = fullfile('fdatool_qtool_roundmode', 'dsp');
cshtags.overflowmode    = fullfile('fdatool_qtool_overflowmode', 'dsp');
cshtags.apply           = fullfile('fdatool_qtool_apply', 'dsp');

% [EOF]
