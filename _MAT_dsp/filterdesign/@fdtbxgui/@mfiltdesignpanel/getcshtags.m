function [cshtags, cshtool] = getcshtags(this)
%GETCSHTAGS   Get the cshtags.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

cshtool = 'fdatool';
cshtags.differentialdelay = fullfile('fdatool_mfilt_diffdelay', 'dsp');
cshtags.numberofsections  = fullfile('fdatool_mfilt_nsections', 'dsp');
cshtags.design            = fullfile('fdatool_mfilt_create', 'dsp');
cshtags.type              = fullfile('fdatool_mfilt_type', 'dsp');

% [EOF]
