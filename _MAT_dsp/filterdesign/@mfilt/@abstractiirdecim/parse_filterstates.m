function hTar = parse_filterstates(Hd,hTar)
%PARSE_FILTERSTATES Store filter states in hTar for realizemdl

%   Copyright 2009 The MathWorks, Inc.

if strcmpi(hTar.MapStates,'on')
    error(message('dsp:mfilt:abstractiirdecim:parse_filterstates:NotSupported', class( Hd ))); 
end

% Extract current filter states
IC = getinitialconditions(Hd);
IC = zeros(size(IC));

% Store the filter states
setprivstates(hTar,IC);


% [EOF]
