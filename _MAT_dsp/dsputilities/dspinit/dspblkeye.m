function dspblkeye()
% DSPBLKEYE is the mask function for the DSP System Toolbox Identity
% Block

% Copyright 1995-2010 The MathWorks, Inc.

% ---------------------------------------------------------------------
% Control dialog parameter visibility
%
% Parameters:
%     Inherit, N, Ts,
%     additionalParams, allowOverrides,
%     dataType,isSigned,wordLen,udDataType,fracBitsMode,numFracBits,
%     OutDataTypeStr, LastOutDataTypeStr
% ---------------------------------------------------------------------
blkh    = gcbh;
blkobj  = get_param(blkh,'object');
vis     = blkobj.MaskVisibilities;
lastvis = vis; % cache away for comparison below

% Always show checkbox to inherit from an input port.
% Hide all other parameters (and adjust below if needed).
vis(2:end) = {'off'};

if strcmp(blkobj.Inherit,'off')
    % All output port attributes are specified using dialog params.
    % Show all parameters that allow for output port specification.
    [N_SIZE, SAMP_TIME, OUT_UDT_STR] = deal(2, 3, 12);
    vis(N_SIZE)      = {'on'};
    vis(SAMP_TIME)   = {'on'};
    vis(OUT_UDT_STR) = {'on'};
end

% Change visibilities only if something has changed
if ~isequal(vis, lastvis)
    blkobj.MaskVisibilities = vis; % update
end
