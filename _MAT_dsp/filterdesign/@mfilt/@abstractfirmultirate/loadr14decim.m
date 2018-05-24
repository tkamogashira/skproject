function loadr14decim(H)
%LOADR14DECIM   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Send warning
warning(message('dsp:mfilt:abstractfirmultirate:loadr14decim:loadingR14mfilt', 'The MAT-file you are loading contains an object saved', 'in a previous version of MATLAB which supported NonProcessedSamples.', 'This property is no longer supported, therefore when filtering,', 'the length of the output signal may be different than what it was', 'in previous versions. Information related to the state of the object', 'will not be loaded. Please resave the MAT-file.'));

% [EOF]
